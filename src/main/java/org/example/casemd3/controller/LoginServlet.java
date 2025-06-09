package org.example.casemd3.controller;

import org.example.casemd3.dao.*;
import org.example.casemd3.model.FaceId;
import org.example.casemd3.service.AuthService;
import org.example.casemd3.service.FaceIdService;
import org.example.casemd3.service.UserService;
import org.example.casemd3.service.UserSessionService;
import org.example.casemd3.util.DeviceUtil;
import org.example.casemd3.util.UserAgentUtil;
import eu.bitwalker.useragentutils.UserAgent;
import eu.bitwalker.useragentutils.Browser;
import eu.bitwalker.useragentutils.OperatingSystem;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

@WebServlet("/login")
@MultipartConfig
public class LoginServlet extends HttpServlet {
    private final AuthService authService = new AuthService();
    private final UserSessionService userSessionService = new UserSessionService();
    private final FaceIdService faceIdService = new FaceIdService();
    private final UserService userService = new UserService();

    public LoginServlet() throws SQLException {
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String method = req.getParameter("method");

        if ("account".equals(method)) {
            handleAccountLogin(req, resp);
        } else if ("face".equals(method)) {
            handleFaceLogin(req, resp);
        } else {
            req.setAttribute("error", "Phương thức đăng nhập không hợp lệ");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }

    private void handleAccountLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        try {
            int userId = authService.loginUser(email, password);
            if (userId != -1) {
                createSessionAndRedirect(req, resp, userId, email, remember);
            } else {
                req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException("Lỗi đăng nhập tài khoản", e);
        }
    }

    private void handleFaceLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            Part filePart = req.getPart("photo");
            if (filePart == null || filePart.getSize() == 0) {
                req.setAttribute("error", "Vui lòng chọn ảnh khuôn mặt");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }

            List<FaceId> faceIds = faceIdService.getAllFaceIds();

            if (faceIds == null || faceIds.isEmpty()) {
                req.setAttribute("error", "Không có dữ liệu khuôn mặt trong hệ thống");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }

            String uploadedFaceToken = faceIdService.detectFaceToken(filePart.getInputStream());
            if (uploadedFaceToken == null) {
                req.setAttribute("error", "Không nhận diện được khuôn mặt");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }

            FaceId matchedFace = faceIdService.recognizeUser(uploadedFaceToken, faceIds);
            if (matchedFace != null) {
                int userId = matchedFace.getUser_id();
                String email = userService.getEmailByUserId(userId);
                createSessionAndRedirect(req, resp, userId, email, null);
            } else {
                req.setAttribute("error", "Không tìm thấy người dùng tương ứng");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đăng nhập bằng khuôn mặt thất bại: " + e.getMessage());
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }


    private void createSessionAndRedirect(HttpServletRequest req, HttpServletResponse resp,
                                          int userId, String email, String remember)
            throws IOException, SQLException {

        // Phân tích User-Agent
        String userAgentString = req.getHeader("User-Agent");
        UserAgent userAgent = UserAgent.parseUserAgentString(userAgentString);
        String browserName = userAgent.getBrowser().getName();                // Chrome, Firefox, v.v.
        String rawDeviceType = userAgent.getOperatingSystem().getDeviceType().getName();
        String deviceType = DeviceUtil.getDeviceTypeName(rawDeviceType);

        // Lấy IP từ header X-Forwarded-For nếu có
        String ip = req.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            ip = ip.split(",")[0].trim(); // lấy IP đầu tiên
        } else {
            ip = req.getRemoteAddr();
        }

        if ("0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) {
            ip = "127.0.0.1";
        }


        HttpSession session = req.getSession(true);
        String sessionId;

        if (!userSessionService.hasSessionWithUserAgent(userId, browserName)) {
            sessionId = UUID.randomUUID().toString();
            userSessionService.createSession(sessionId, userId, deviceType, browserName);
        } else {
            sessionId = userSessionService.getSessionIdByUserAgent(userId, browserName);
            userSessionService.updateLoginTimestamp(sessionId);
        }

        session.setAttribute("userId", userId);
        session.setAttribute("email", email);
        session.setAttribute("sessionId", sessionId);

        if ("on".equals(remember)) {
            Cookie userCookie = new Cookie("remember_user", String.valueOf(userId));
            Cookie sessionCookie = new Cookie("remember_session", sessionId);
            userCookie.setMaxAge(60 * 60 * 24 * 7); // 7 ngày
            sessionCookie.setMaxAge(60 * 60 * 24 * 7);
            resp.addCookie(userCookie);
            resp.addCookie(sessionCookie);
        }

        resp.sendRedirect("/profile");
    }

}

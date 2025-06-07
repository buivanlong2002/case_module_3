package org.example.casemd3.controller;

import org.example.casemd3.dao.*;
import org.example.casemd3.model.FaceId;
import org.example.casemd3.service.FaceIdService;
import org.example.casemd3.util.UserAgentUtil;

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
    private final AuthDao authDao = new AuthDao();
    private final UserSessionDAO sessionDAO = new UserSessionDAO();
    private final FaceIdDao faceIdDao = new FaceIdDao();
    private final UserDAO userDAO = new UserDAO();

    public LoginServlet() throws SQLException {
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String method = req.getParameter("method");
        Part filePart = req.getPart("photo");

        if ("account".equals(method)) {
            handleAccountLogin(req, resp);
        } else if ("face".equals(method)) {
            handleFaceLogin(req, resp);
        } else {
            resp.getWriter().println("Phương thức đăng nhập không hợp lệ");
        }
    }

    private void handleAccountLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        try {
            int userId = authDao.validateUser(email, password);
            if (userId != -1) {
                createSessionAndRedirect(req, resp, userId, email, remember);
            } else {
                req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleFaceLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Part filePart = req.getPart("photo");
        FaceIdService faceIdService = new FaceIdService();

        try {
            List<FaceId> faceIds = faceIdDao.findAllFaceIds();
            if (faceIds == null || faceIds.isEmpty()) {
                req.setAttribute("error", "Không có dữ liệu khuôn mặt trong hệ thống");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }

            String uploadedFaceToken = faceIdService.detectFaceToken(filePart.getInputStream());
            if (uploadedFaceToken == null) {
                req.setAttribute("error", "Không nhận diện được khuôn mặt trong ảnh");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }

            FaceId matchedFace = faceIdService.recognizeUser(uploadedFaceToken, faceIds);
            if (matchedFace != null) {
                int userId = matchedFace.getId();
                String email = userDAO.getEmailByUserId(userId);
                createSessionAndRedirect(req, resp, userId, email, null);
            } else {
                req.setAttribute("error", "Không tìm thấy người dùng tương ứng");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đăng nhập bằng khuôn mặt thất bại");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }

    private void createSessionAndRedirect(HttpServletRequest req, HttpServletResponse resp, int userId, String email, String remember) throws IOException, SQLException {
        String userAgentRaw = req.getHeader("User-Agent");
        String browserName = UserAgentUtil.getBrowserName(userAgentRaw);
        String ip = req.getRemoteAddr();
        if ("0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) {
            ip = "127.0.0.1";
        }

        HttpSession session = req.getSession(true);
        String sessionId;

        if (!sessionDAO.isUserAgentExists(userId, browserName)) {
            sessionId = UUID.randomUUID().toString();
            sessionDAO.insertSession(sessionId, userId, ip, browserName);
        } else {
            sessionId = sessionDAO.getSessionIdByUserAgent(userId, browserName);
            sessionDAO.updateLoginTime(sessionId);
        }

        session.setAttribute("userId", userId);
        session.setAttribute("email", email);
        session.setAttribute("sessionId", sessionId);

        if ("on".equals(remember)) {
            Cookie userCookie = new Cookie("remember_user", String.valueOf(userId));
            Cookie sessionCookie = new Cookie("remember_session", sessionId);
            userCookie.setMaxAge(60 * 60 * 24 * 7);
            sessionCookie.setMaxAge(60 * 60 * 24 * 7);
            resp.addCookie(userCookie);
            resp.addCookie(sessionCookie);
        }

        resp.sendRedirect("/profile");
    }
}

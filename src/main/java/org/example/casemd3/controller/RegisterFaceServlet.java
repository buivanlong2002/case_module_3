package org.example.casemd3.controller;

import org.example.casemd3.dao.FaceIdDao;
import org.example.casemd3.model.FaceId;
import org.example.casemd3.model.User;
import org.example.casemd3.service.FaceIdService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/register-face")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // Giới hạn 10MB
public class RegisterFaceServlet extends HttpServlet {

    private final FaceIdService faceService = new FaceIdService();


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // Lấy ảnh từ form
        Part imagePart = req.getPart("photo");
        if (imagePart == null || imagePart.getSize() == 0) {
            sendJsonResponse(resp, false, "Không có ảnh được gửi lên.", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (InputStream imageStream = imagePart.getInputStream()) {
            String faceToken = faceService.detectFaceToken(imageStream);
            if (faceToken == null) {
                sendJsonResponse(resp, false, "Không phát hiện khuôn mặt.", HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            // Tạo và lưu FaceId
            FaceId faceId = new FaceId();
            faceId.setUser_id(user.getUser_id());
            faceId.setFaceIdToken(faceToken);

            if (!faceService.saveFaceId(faceId)) {
                sendJsonResponse(resp, false, "Lưu Face ID thất bại.", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                return;
            }

            sendJsonResponse(resp, true, "Đăng ký Face ID thành công!", HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(resp, false, "Lỗi xử lý ảnh: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void sendJsonResponse(HttpServletResponse resp, boolean success, String message, int statusCode) throws IOException {
        resp.setStatus(statusCode);
        String jsonResponse = String.format("{\"success\": %b, \"message\": \"%s\"}", success, message.replace("\"", "\\\""));
        resp.getWriter().write(jsonResponse);
    }
}
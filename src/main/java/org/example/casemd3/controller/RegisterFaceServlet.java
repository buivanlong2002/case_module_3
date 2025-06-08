package org.example.casemd3.controller;

import org.example.casemd3.dao.FaceIdDao;
import org.example.casemd3.model.FaceId;
import org.example.casemd3.model.User;
import org.example.casemd3.service.FaceIdService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/register-face")
@MultipartConfig
public class RegisterFaceServlet extends HttpServlet {

    private FaceIdService faceService;
    private FaceIdDao faceIdDAO;

    @Override
    public void init() {
        faceService = new FaceIdService(); // đã có sẵn
        faceIdDAO = new FaceIdDao();       // DAO để lưu database
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }



        // Lấy ảnh từ form
        Part imagePart = req.getPart("image");
        if (imagePart == null || imagePart.getSize() == 0) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Không có ảnh được gửi lên.");
            return;
        }

        try (InputStream imageStream = imagePart.getInputStream()) {
            String faceToken = faceService.detectFaceToken(imageStream);
            if (faceToken == null) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Không phát hiện khuôn mặt.");
                return;
            }

            // Tạo đối tượng FaceId, lưu vào DB
            FaceId faceId = new FaceId();
            faceId.setUser_id(user.getUser_id());
            faceId.setFaceIdToken(faceToken);

            boolean saved = faceIdDAO.save(faceId);
            if (!saved) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lưu Face ID thất bại.");
                return;
            }

            resp.setContentType("application/json");
            resp.getWriter().write("{\"message\": \"Đăng ký Face ID thành công!\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý ảnh.");
        }
    }
}

package org.example.casemd3.controller;

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

@WebServlet("/face-id-upload")
@MultipartConfig
public class FaceIdUploadServlet extends HttpServlet {
    private final FaceIdService faceIdService = new FaceIdService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Part filePart = req.getPart("photo");
        try {
            String faceToken = faceIdService.detectFaceToken(filePart.getInputStream());
            if (faceToken != null) {
//                faceIdService.saveOrUpdateFaceToken(user.getId(), faceToken);
                req.setAttribute("message", "Đăng ký Face ID thành công!");
            } else {
                req.setAttribute("error", "Không phát hiện được khuôn mặt trong ảnh.");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi xử lý ảnh: " + e.getMessage());
        }
        req.getRequestDispatcher("face_id.jsp").forward(req, resp);
    }
}

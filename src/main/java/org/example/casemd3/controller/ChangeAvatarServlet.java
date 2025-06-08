package org.example.casemd3.controller;

import org.example.casemd3.dao.UserDAO;
import org.example.casemd3.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;

@WebServlet(name = "ChangeAvatarServlet", urlPatterns = {"/ChangeAvatarServlet"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 2 * 1024 * 1024,   // 2MB
        maxRequestSize = 4 * 1024 * 1024 // 4MB
)
public class ChangeAvatarServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/avatars";
    private UserDAO userDAO = new UserDAO();

    public ChangeAvatarServlet() throws SQLException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Part filePart = request.getPart("avatarFile");
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Bạn chưa chọn ảnh!");
            request.getRequestDispatcher("changeAvatar.jsp").forward(request, response);
            return;
        }

        String contentType = filePart.getContentType();
        if (!contentType.equals("image/jpeg") && !contentType.equals("image/png")) {
            request.setAttribute("error", "Chỉ chấp nhận file ảnh JPG hoặc PNG!");
            request.getRequestDispatcher("changeAvatar.jsp").forward(request, response);
            return;
        }

        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String fileName = user.getUser_id() + "_" + System.currentTimeMillis() + getFileExtension(filePart);
        File file = new File(uploadDir, fileName);

        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lưu file ảnh!");
            request.getRequestDispatcher("changeAvatar.jsp").forward(request, response);
            return;
        }

        String imagePath = UPLOAD_DIR + "/" + fileName;
        user.setImage(imagePath);

        try {
            UserDAO.updateAvatar(user.getUser_id(), imagePath);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật ảnh đại diện trong cơ sở dữ liệu.");
            request.getRequestDispatcher("changeAvatar.jsp").forward(request, response);
            return;
        }

        session.setAttribute("currentUser", user);
        response.sendRedirect("profile");
    }

    private String getFileExtension(Part part) {
        String submittedFileName = part.getSubmittedFileName();
        if (submittedFileName == null) return "";
        int dot = submittedFileName.lastIndexOf('.');
        if (dot > 0) {
            return submittedFileName.substring(dot);
        }
        return "";
    }
}

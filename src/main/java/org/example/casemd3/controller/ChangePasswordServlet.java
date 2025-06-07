package org.example.casemd3.controller;

import org.example.casemd3.dao.UserDAO;
import org.example.casemd3.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/changePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    private final UserDAO userDao = new UserDAO();

    public ChangePasswordServlet() throws SQLException {}

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        boolean hasError = false;

        // Kiểm tra các trường rỗng
        if (currentPassword == null || currentPassword.isEmpty()) {
            req.setAttribute("errorCurrentPassword", "Vui lòng nhập mật khẩu hiện tại.");
            hasError = true;
        }

        if (newPassword == null || newPassword.isEmpty()) {
            req.setAttribute("errorNewPassword", "Vui lòng nhập mật khẩu mới.");
            hasError = true;
        } else if (newPassword.length() < 6) {
            req.setAttribute("errorNewPassword", "Mật khẩu phải có ít nhất 6 ký tự.");
            hasError = true;
        }

        if (confirmPassword == null || confirmPassword.isEmpty()) {
            req.setAttribute("errorConfirmPassword", "Vui lòng xác nhận mật khẩu mới.");
            hasError = true;
        } else if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("errorConfirmPassword", "Mật khẩu xác nhận không khớp.");
            hasError = true;
        }

        if (hasError) {
            req.getRequestDispatcher("change-password.jsp").forward(req, resp);
            return;
        }

        try {
            boolean isCurrentPasswordCorrect = userDao.checkPassword(user.getUser_id(), currentPassword);
            if (isCurrentPasswordCorrect) {
                req.setAttribute("errorCurrentPassword", "Mật khẩu hiện tại không đúng.");
                req.getRequestDispatcher("change-password.jsp").forward(req, resp);
                return;
            }

            boolean updated = userDao.updatePasswordByUserId(user.getUser_id(), newPassword);
            if (updated) {
                req.setAttribute("message", "Đổi mật khẩu thành công.");
                req.setAttribute("askLogoutOtherDevices", true);
            } else {
                req.setAttribute("error", "Đổi mật khẩu thất bại.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại sau.");
        }

        req.getRequestDispatcher("change-password.jsp").forward(req, resp);
    }
}

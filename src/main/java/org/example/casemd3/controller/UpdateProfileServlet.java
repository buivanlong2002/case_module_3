package org.example.casemd3.controller;

import org.example.casemd3.dao.UserDAO;
import org.example.casemd3.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "UpdateProfileServlet", value = "/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String birthdayStr = request.getParameter("birthday");
        String address = request.getParameter("address");

        // Cập nhật vào đối tượng user
        currentUser.setEmail(email);
        currentUser.setUsername(username);
        currentUser.setPhone(phone);
        if (birthdayStr != null && !birthdayStr.isEmpty()) {
            currentUser.setBirthday(java.sql.Date.valueOf(birthdayStr));
        } else {
            currentUser.setBirthday(null);
        }
        currentUser.setAddress(address);

        boolean updated = UserDAO.updateProfile(currentUser);
        if (updated) {
            session.setAttribute("currentUser", currentUser);
            response.sendRedirect("profile");
        } else {
            request.setAttribute("error", "Cập nhật thông tin thất bại.");
            request.getRequestDispatcher("/edit-profile.jsp").forward(request, response);
        }
    }
}

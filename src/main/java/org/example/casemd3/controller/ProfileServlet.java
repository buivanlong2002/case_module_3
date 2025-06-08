package org.example.casemd3.controller;

import org.example.casemd3.model.User;
import org.example.casemd3.dao.UserDAO;
import org.example.casemd3.service.UserService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "ProfileServlet", value = "/profile")
public class ProfileServlet extends HttpServlet {
    private final UserService userService = new UserService();

    public ProfileServlet() throws SQLException {
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = (String) request.getSession().getAttribute("email");

        if (email == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User user = userService.findUserByEmail(email);
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("currentUser", user);

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}

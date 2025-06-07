package org.example.casemd3.controller;

import org.example.casemd3.dao.UserSessionDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private UserSessionDAO sessionDAO = new UserSessionDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession httpSession = req.getSession(false);
        if (httpSession != null) {
            String sessionId = (String) httpSession.getAttribute("sessionId");
            if (sessionId != null) {
                try {
                    sessionDAO.deleteSession(sessionId);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            httpSession.invalidate();
        }
        resp.sendRedirect("login.jsp");
    }
}


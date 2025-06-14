package org.example.casemd3.controller;

import org.example.casemd3.dao.UserSessionDAO;
import org.example.casemd3.model.UserSession;
import org.example.casemd3.service.UserSessionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
@WebServlet("/session-list")
public class SessionListServlet extends HttpServlet {
    private final UserSessionService sessionService = new UserSessionService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession httpSession = req.getSession(false);
        if (httpSession == null || httpSession.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) httpSession.getAttribute("userId");
        List<UserSession> sessions = sessionService.getSessionsByUser(userId);
        req.setAttribute("sessions", sessions);
        req.getRequestDispatcher("session-list.jsp").forward(req, resp);
    }
}

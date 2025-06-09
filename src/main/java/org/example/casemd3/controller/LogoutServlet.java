package org.example.casemd3.controller;

import org.example.casemd3.dao.UserSessionDAO;
import org.example.casemd3.service.UserSessionService;

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
    private final UserSessionService sessionService = new UserSessionService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession httpSession = req.getSession(false);
        if (httpSession != null) {
            String sessionId = (String) httpSession.getAttribute("sessionId");
            if (sessionId != null) {
                sessionService.deleteSessionByUserAgent(sessionId);
            }
            httpSession.invalidate();
        }
        resp.sendRedirect("login.jsp");
    }
}


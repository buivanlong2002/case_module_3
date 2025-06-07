package org.example.casemd3.controller;

import org.example.casemd3.dao.UserSessionDAO;
import org.example.casemd3.model.UserSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/remote-logout")
public class RemoteLogoutServlet extends HttpServlet {
    private UserSessionDAO sessionDAO = new UserSessionDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession httpSession = req.getSession(false);
        if (httpSession == null || httpSession.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) httpSession.getAttribute("userId");
        String sessionId = req.getParameter("sessionId");

        if (sessionId == null || sessionId.isEmpty()) {
            resp.sendRedirect("session-list");
            return;
        }

        try {
            List<UserSession> sessions = sessionDAO.getSessionsByUser(userId);

            boolean belongsToUser = sessions.stream()
                    .anyMatch(s -> s.getSessionId().equals(sessionId));

            if (!belongsToUser) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Phiên đăng nhập không thuộc về bạn");
                return;
            }

            sessionDAO.deleteSession(sessionId);

            String currentSessionId = httpSession.getId();
            if (sessionId.equals(currentSessionId)) {
                httpSession.invalidate();
                resp.sendRedirect("login.jsp");
            } else {
                resp.sendRedirect("session-list");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

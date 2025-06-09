package org.example.casemd3.controller;

import org.example.casemd3.model.UserSession;
import org.example.casemd3.service.UserSessionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/remote-logout")
public class RemoteLogoutServlet extends HttpServlet {
    private final UserSessionService userSessionService = new UserSessionService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession currentSession = req.getSession(false);
        if (currentSession == null || currentSession.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) currentSession.getAttribute("userId");
        String targetSessionId = req.getParameter("sessionId");

        if (targetSessionId == null || targetSessionId.isEmpty()) {
            resp.sendRedirect("session-list");
            return;
        }

        try {
            List<UserSession> userSessions = userSessionService.getSessionsByUser(userId);
            boolean belongsToUser = userSessions.stream()
                    .anyMatch(session -> session.getSessionId().equals(targetSessionId));

            if (!belongsToUser) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Phiên đăng nhập không thuộc về bạn.");
                return;
            }

            // Nếu là phiên hiện tại thì xóa DB + invalidate session
            String currentSessionId = currentSession.getId();
            userSessionService.deleteSessionBySessionId(targetSessionId);

            if (targetSessionId.equals(currentSessionId)) {
                currentSession.invalidate();
                resp.sendRedirect("login.jsp");
            } else {
                resp.sendRedirect("session-list");
            }

        } catch (Exception e) {
            throw new ServletException("Lỗi khi đăng xuất từ xa", e);
        }
    }
}

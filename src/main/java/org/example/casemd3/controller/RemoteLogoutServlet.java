package org.example.casemd3.controller;

import org.example.casemd3.dao.UserSessionDAO;
import org.example.casemd3.model.UserSession;
import org.example.casemd3.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
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
        String otp = req.getParameter("otp");

        if (sessionId == null || otp == null) {
            resp.sendRedirect("session-list");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Kiểm tra OTP hợp lệ
            String sqlOtp = "SELECT id, is_used, created_at FROM email_otps WHERE user_id = ? AND otp_code = ? ORDER BY created_at DESC LIMIT 1";
            PreparedStatement psOtp = conn.prepareStatement(sqlOtp);
            psOtp.setInt(1, userId);
            psOtp.setString(2, otp);
            ResultSet rsOtp = psOtp.executeQuery();

            if (rsOtp.next()) {
                boolean isUsed = rsOtp.getBoolean("is_used");
                Timestamp createdAt = rsOtp.getTimestamp("created_at");
                if (isUsed) {
                    resp.getWriter().println("Mã OTP đã được sử dụng");
                    return;
                }

                long now = System.currentTimeMillis();
                long diff = now - createdAt.getTime();
                if (diff > 5 * 60 * 1000) { // OTP quá 5 phút
                    resp.getWriter().println("Mã OTP đã hết hạn");
                    return;
                }

                // Đánh dấu OTP đã dùng
                int otpId = rsOtp.getInt("id");
                PreparedStatement psUpdate = conn.prepareStatement("UPDATE email_otps SET is_used = TRUE WHERE id = ?");
                psUpdate.setInt(1, otpId);
                psUpdate.executeUpdate();

                // Kiểm tra phiên đăng nhập có thuộc user hay không
                List<UserSession> sessions = sessionDAO.getSessionsByUser(userId);
                boolean belongsToUser = sessions.stream()
                        .anyMatch(s -> s.getSessionId().equals(sessionId));

                if (!belongsToUser) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Phiên đăng nhập không thuộc về bạn");
                    return;
                }

                // Xóa phiên đăng nhập
                sessionDAO.deleteSession(sessionId);

                // Nếu xóa phiên hiện tại thì invalidate luôn session
                String currentSessionId = (String) httpSession.getAttribute("sessionId");
                if (sessionId.equals(currentSessionId)) {
                    httpSession.invalidate();
                    resp.sendRedirect("login.jsp");
                } else {
                    resp.sendRedirect("session-list");
                }
            } else {
                resp.getWriter().println("Mã OTP không hợp lệ");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

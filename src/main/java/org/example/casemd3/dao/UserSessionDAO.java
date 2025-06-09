package org.example.casemd3.dao;

import org.example.casemd3.model.UserSession;
import org.example.casemd3.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static org.example.casemd3.util.DBConnection.getConnection;

public class UserSessionDAO {

    public void insertSession(String sessionId, int userId, String ip, String userAgent) throws SQLException {
        try (Connection conn = getConnection()) {
            String sql = "INSERT INTO user_sessions(session_id, user_id, login_time, ip_address, user_agent) VALUES (?, ?, NOW(), ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, sessionId);
            ps.setInt(2, userId);
            ps.setString(3, ip);
            ps.setString(4, userAgent);
            ps.executeUpdate();
        }
    }

    public List<UserSession> getSessionsByUser(int userId) throws SQLException {
        List<UserSession> sessions = new ArrayList<>();
        try (Connection conn = getConnection()) {
            String sql = "SELECT session_id, login_time, ip_address, user_agent FROM user_sessions WHERE user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserSession s = new UserSession();
                s.setSessionId(rs.getString("session_id"));
                s.setLoginTime(rs.getTimestamp("login_time"));
                s.setIpAddress(rs.getString("ip_address"));
                s.setUserAgent(rs.getString("user_agent"));
                sessions.add(s);
            }
        }
        return sessions;
    }



    public boolean isUserAgentExists(int userId, String userAgent) {
        String sql = "SELECT * FROM user_sessions WHERE user_id = ? AND user_agent = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, userAgent);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public String getSessionIdByUserAgent(int userId, String userAgent) {
        String sql = "SELECT session_id FROM user_sessions WHERE user_id = ? AND user_agent = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, userAgent);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("session_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public boolean isSessionValid(int userId, String sessionId) {
        String sql = "SELECT 1 FROM user_sessions WHERE user_id = ? AND session_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, sessionId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public void updateLoginTime(String sessionId) throws SQLException {
        String sql = "UPDATE user_sessions SET login_time = CURRENT_TIMESTAMP WHERE session_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sessionId);
            stmt.executeUpdate();
        }
    }

    public void deleteAllSessionsExcept(int userId, String currentSessionId) throws SQLException {
        String sql = "DELETE FROM user_sessions WHERE user_id = ? AND session_id != ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, currentSessionId);
            ps.executeUpdate();
        }
    }

    public void deleteBySessionId(String sessionId) throws SQLException {
        String sql = "DELETE FROM user_sessions WHERE session_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sessionId);
            stmt.executeUpdate();
        }
    }
    public void deleteSession(String userAgent) throws SQLException {
        try (Connection conn = getConnection()) {
            String sql = "DELETE FROM user_sessions WHERE user_agent = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, userAgent);
            ps.executeUpdate();
        }
    }

}

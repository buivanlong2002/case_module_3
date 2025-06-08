package org.example.casemd3.service;


import org.example.casemd3.dao.UserSessionDAO;
import org.example.casemd3.model.UserSession;

import java.sql.SQLException;
import java.util.List;

public class UserSessionService {
    private final UserSessionDAO userSessionDAO;

    public UserSessionService() {
        this.userSessionDAO = new UserSessionDAO();
    }

    /**
     * Tạo mới một phiên đăng nhập cho người dùng.
     *
     * @param sessionId  Mã phiên (session ID).
     * @param userId     ID người dùng.
     * @param ipAddress  Địa chỉ IP của người dùng.
     * @param userAgent  Trình duyệt hoặc thiết bị sử dụng.
     */
    public void createSession(String sessionId, int userId, String ipAddress, String userAgent) {
        try {
            userSessionDAO.insertSession(sessionId, userId, ipAddress, userAgent);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy danh sách các phiên đăng nhập của người dùng.
     *
     * @param userId ID người dùng.
     * @return Danh sách phiên đăng nhập.
     */
    public List<UserSession> getSessionsByUser(int userId) {
        try {
            return userSessionDAO.getSessionsByUser(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Xóa phiên dựa trên user-agent (thiết bị hoặc trình duyệt).
     *
     * @param userAgent Chuỗi user-agent cần xóa.
     */
    public void deleteSessionByUserAgent(String userAgent) {
        try {
            userSessionDAO.deleteSession(userAgent);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Kiểm tra xem người dùng đã đăng nhập từ user-agent cụ thể chưa.
     *
     * @param userId    ID người dùng.
     * @param userAgent Thiết bị hoặc trình duyệt.
     * @return true nếu tồn tại, false nếu không.
     */
    public boolean hasSessionWithUserAgent(int userId, String userAgent) {
        return userSessionDAO.isUserAgentExists(userId, userAgent);
    }

    /**
     * Lấy session ID theo user-agent của người dùng.
     *
     * @param userId    ID người dùng.
     * @param userAgent Thiết bị hoặc trình duyệt.
     * @return Mã session nếu có, null nếu không.
     */
    public String getSessionIdByUserAgent(int userId, String userAgent) {
        return userSessionDAO.getSessionIdByUserAgent(userId, userAgent);
    }

    /**
     * Kiểm tra tính hợp lệ của một phiên đăng nhập.
     *
     * @param userId    ID người dùng.
     * @param sessionId Mã session.
     * @return true nếu hợp lệ, false nếu không.
     */
    public boolean isSessionValid(int userId, String sessionId) {
        return userSessionDAO.isSessionValid(userId, sessionId);
    }

    /**
     * Cập nhật thời gian đăng nhập cuối cùng của một session.
     *
     * @param sessionId Mã session.
     */
    public void updateLoginTimestamp(String sessionId) {
        try {
            userSessionDAO.updateLoginTime(sessionId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Xóa tất cả các phiên đăng nhập khác của người dùng, ngoại trừ phiên hiện tại.
     *
     * @param userId           ID người dùng.
     * @param currentSessionId Mã session hiện tại không bị xóa.
     */
    public void deleteAllSessionsExcept(int userId, String currentSessionId) {
        try {
            userSessionDAO.deleteAllSessionsExcept(userId, currentSessionId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}


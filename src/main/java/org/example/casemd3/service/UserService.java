package org.example.casemd3.service;

import org.example.casemd3.dao.UserDAO;
import org.example.casemd3.model.User;

import java.sql.SQLException;
import java.util.Date;

/**
 * Service xử lý logic nghiệp vụ liên quan đến User.
 */
public class UserService {
    private final UserDAO userDAO;

    public UserService() throws SQLException {
        this.userDAO = new UserDAO();
    }

    /**
     * Tìm user theo email.
     * @param email email người dùng.
     * @return đối tượng User hoặc null nếu không tìm thấy.
     */
    public User findUserByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    /**
     * Lấy email theo userId.
     * @param userId ID người dùng.
     * @return email hoặc null nếu không tìm thấy.
     * @throws SQLException nếu lỗi truy vấn.
     */
    public String getEmailByUserId(int userId) throws SQLException {
        return userDAO.getEmailByUserId(userId);
    }

    /**
     * Cập nhật mật khẩu cho user.
     * @param userId ID người dùng.
     * @param newPassword mật khẩu mới.
     * @return true nếu cập nhật thành công, false nếu thất bại.
     * @throws SQLException nếu lỗi truy vấn.
     */
    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        return userDAO.updatePasswordByUserId(userId, newPassword);
    }

    /**
     * Kiểm tra mật khẩu của user có đúng không.
     * @param userId ID người dùng.
     * @param password mật khẩu cần kiểm tra.
     * @return true nếu mật khẩu đúng, false nếu sai.
     * @throws SQLException nếu lỗi truy vấn.
     */
    public boolean checkPassword(int userId, String password) throws SQLException {
        return userDAO.checkPassword(userId, password);
    }

    /**
     * Cập nhật ảnh đại diện cho user.
     * @param userId ID người dùng.
     * @param avatarUrl URL ảnh đại diện mới.
     */
    public void updateAvatar(int userId, String avatarUrl) {
        UserDAO.updateAvatar(userId, avatarUrl);
    }

    /**
     * Cập nhật thông tin profile cho user.
     * @param user đối tượng User chứa thông tin mới.
     * @return true nếu cập nhật thành công, false nếu thất bại.
     */
    public boolean updateProfile(User user) {
        return UserDAO.updateProfile(user);
    }
}

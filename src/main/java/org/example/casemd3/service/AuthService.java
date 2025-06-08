package org.example.casemd3.service;


import org.example.casemd3.dao.AuthDao;

import java.sql.SQLException;

public class AuthService {
    private final AuthDao authDao;

    public AuthService() {
        this.authDao = new AuthDao();
    }

    /**
     * Kiểm tra thông tin đăng nhập.
     * @param email Email người dùng.
     * @param password Mật khẩu người dùng.
     * @return ID người dùng nếu hợp lệ, -1 nếu không đúng.
     */
    public int loginUser(String email, String password) {
        try {
            return authDao.validateUser(email, password);
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Đăng ký người dùng mới.
     * @param username Tên người dùng.
     * @param email Email.
     * @param password Mật khẩu.
     * @return true nếu đăng ký thành công, false nếu thất bại.
     */
    public boolean registerUser(String username, String email, String password) {
        try {
            if (authDao.isUserOrEmailExist(username, email)) {
                return false; // Tài khoản đã tồn tại
            }
            return authDao.insertUser(username, email, password);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Kiểm tra tên người dùng hoặc email đã tồn tại.
     */
    public boolean isUserOrEmailExist(String username, String email) {
        try {
            return authDao.isUserOrEmailExist(username, email);
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }
}

package org.example.casemd3.dao;

import org.example.casemd3.model.User;
import org.example.casemd3.util.DBConnection;

import java.sql.*;

public class UserDAO {
    private Connection connection = DBConnection.getConnection();

    public UserDAO() throws SQLException {
    }


    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("image"),
                        rs.getString("address"),
                        rs.getDate("birthday")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getEmailByUserId(int userId) throws SQLException {
        String query = "SELECT email FROM users WHERE user_id = ?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)
        ) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("email");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return null;
    }

    public boolean updatePasswordByUserId(int userId, String newPassword) throws SQLException {
        String query = "UPDATE users SET password = ? WHERE user_id = ?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)
        ) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public boolean checkPassword(int userId, String password) throws SQLException {
        String query = "SELECT password FROM users WHERE username = ?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)
        ) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                return storedPassword.equals(password);
            }
        }
        return false;
    }
    public static void updateAvatar(int userId, String avatarUrl) {
        String sql = "UPDATE users SET image = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, avatarUrl);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static boolean updateProfile(User user) {
        String sql = "UPDATE users SET email = ?, username = ?, phone = ?, birthday = ?, address = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getPhone());

            if (user.getBirthday() != null) {
                ps.setDate(4, new Date(user.getBirthday().getTime()));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }

            ps.setString(5, user.getAddress());
            ps.setInt(6, user.getUser_id());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}


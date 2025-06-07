package org.example.casemd3.dao;



import org.example.casemd3.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserFaceImageDAO {

    public String getImgBase64ByUserId(int userId) throws SQLException {
        String sql = "SELECT imgBase64 FROM UserFaceImages WHERE userId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("imgBase64");
                }
            }
        }
        return null; // không tìm thấy userId
    }

    public boolean existsImgBase64(String imgBase64) throws SQLException {
        String sql = "SELECT 1 FROM UserFaceImages WHERE imgBase64 = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, imgBase64);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // true nếu tồn tại
            }
        }
    }
    public int getUserIdByImgBase64(String imgBase64) throws SQLException {
        String sql = "SELECT userId FROM UserFaceImages WHERE imgBase64 = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, imgBase64);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("userId");
            } else {
                return -1; // Không tìm thấy
            }
        }
    }
}

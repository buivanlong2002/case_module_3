package org.example.casemd3.dao;

import org.example.casemd3.model.FaceId;
import org.example.casemd3.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class FaceIdDao {

    /**
     * Lấy toàn bộ danh sách faceId trong hệ thống.
     *
     * @return Danh sách các FaceId.
     * @throws SQLException Nếu có lỗi xảy ra khi truy vấn cơ sở dữ liệu.
     */
    public List<FaceId> findAllFaceIds() throws SQLException {
        List<FaceId> faceIds = new ArrayList<>();
        String query = "SELECT * FROM faceId";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()
        ) {
            while (rs.next()) {
                int id = rs.getInt("id");
                int user_id = rs.getInt("user_id");
                String token = rs.getString("face_token");
                faceIds.add(new FaceId(id, user_id, token));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        return faceIds;
    }

    /**
     * Lấy danh sách các token khuôn mặt đã đăng ký của một người dùng cụ thể.
     *
     * @param userId ID người dùng.
     * @return Danh sách chuỗi token khuôn mặt.
     */
    public List<String> getFaceTokensByUserId(int userId) {
        List<String> tokens = new ArrayList<>();
        String sql = "SELECT face_token FROM faceId WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                tokens.add(rs.getString("face_token"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tokens;
    }

    /**
     * Xóa một token khuôn mặt khỏi cơ sở dữ liệu.
     *
     * @param token Chuỗi token khuôn mặt cần xóa.
     * @return true nếu xóa thành công, false nếu không.
     */
    public boolean deleteFaceToken(String token) {
        String sql = "DELETE FROM faceId WHERE face_token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lưu một bản ghi khuôn mặt mới vào cơ sở dữ liệu.
     *
     * @param faceId Đối tượng FaceId chứa thông tin user_id và face_token.
     * @return true nếu lưu thành công, false nếu thất bại.
     * @throws SQLException Nếu có lỗi xảy ra khi thực hiện câu lệnh SQL.
     */
    public boolean save(FaceId faceId) throws SQLException {
        String sql = "INSERT INTO faceId (user_id, face_token) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, faceId.getUser_id());
            ps.setString(2, faceId.getFaceIdToken());
            return ps.executeUpdate() > 0;
        }
    }
}

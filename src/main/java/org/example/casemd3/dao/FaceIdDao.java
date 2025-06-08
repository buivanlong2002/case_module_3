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
    public List<FaceId> findAllFaceIds() throws SQLException {
        List<FaceId> faceIds = new ArrayList<>();
        String query = "SELECT * FROM faceId";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()
        ) {
            while (rs.next()) {
                int id = rs.getInt("id"); // hoặc "user_id" nếu cột tên vậy
                int user_id = rs.getInt("user_id");
                String token = rs.getString("face_token"); // hoặc "face_id_token"
                faceIds.add(new FaceId(id, user_id ,token));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        return faceIds;
    }

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

    public boolean save(FaceId faceId) throws SQLException {
        String sql = "INSERT INTO face_id (user_id, token_face) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, faceId.getUser_id());       // user_id
            ps.setString(2, faceId.getFaceIdToken());    // token_face
            return ps.executeUpdate() > 0;
        }
    }

}

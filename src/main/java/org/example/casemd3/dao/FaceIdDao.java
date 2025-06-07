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
                String token = rs.getString("face_token"); // hoặc "face_id_token"
                faceIds.add(new FaceId(id, token));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        return faceIds;
    }

}

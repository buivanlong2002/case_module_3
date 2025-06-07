package org.example.casemd3.dao;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.example.casemd3.util.DBConnection;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class AuthDao {
    public int validateUser(String email, String password) throws SQLException {
        String sql = "SELECT user_id FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        }
        return -1; // không tìm thấy user hợp lệ
    }
    // Kiểm tra username hoặc email đã tồn tại chưa
    public boolean isUserOrEmailExist(String username, String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // Thêm user mới vào database
    public boolean insertUser(String username, String email, String password) throws SQLException {
        String sql = "INSERT INTO users(username, email, password) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }

    public String sendFaceImageAndGetBase64(String base64Image) throws IOException {
        String apiUrl = "http://127.0.0.1:5000/analyze-image/";
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; utf-8");
        conn.setRequestProperty("Accept", "application/json");
        conn.setDoOutput(true);

        String jsonInputString = "{\"imageBase64\":\"" + base64Image + "\"}";

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int code = conn.getResponseCode();
        if (code == 200) {
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {

                StringBuilder response = new StringBuilder();
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }

                com.google.gson.JsonObject jsonObject = JsonParser.parseString(response.toString()).getAsJsonObject();
                String status = jsonObject.get("status").getAsString();
                if ("success".equals(status)) {
                    JsonObject dataObj = jsonObject.get("data").getAsJsonObject();

                    // Lấy chuỗi base64 ảnh từ API trả về
                    if (dataObj.has("base64")) {
                        return dataObj.get("base64").getAsString();
                    } else {
                        return null; // Không có base64 trong response
                    }
                } else {
                    return null; // API trả lỗi
                }
            }
        } else {
            return null; // HTTP lỗi
        }
    }

}



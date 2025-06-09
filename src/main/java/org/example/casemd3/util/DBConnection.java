package org.example.casemd3.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://gondola.proxy.rlwy.net:11091/railway";
            String user = "root";
            String pass = "PjxtSxlkWLrrdUVwuXbPcPKiTiSFHzTG";
            return DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy driver JDBC", e);
        }
    }
}


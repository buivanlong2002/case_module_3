package org.example.casemd3.controller;

import org.example.casemd3.util.DBConnection;
import org.example.casemd3.util.EmailOTPUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/generate-otp")
public class GenerateOtpServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, IOException {
        HttpSession httpSession = req.getSession(false);
        if (httpSession == null || httpSession.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) httpSession.getAttribute("userId");
        String sessionId = req.getParameter("sessionId");
        if (sessionId == null) {
            resp.sendRedirect("session-list");
            return;
        }

        String otpCode = EmailOTPUtil.generateOTP();

        try (Connection conn = DBConnection.getConnection()) {
            // Lấy email user
            String email = null;
            PreparedStatement psEmail = conn.prepareStatement("SELECT email FROM users WHERE user_id = ?");
            psEmail.setInt(1, userId);
            ResultSet rs = psEmail.executeQuery();
            if (rs.next()) {
                email = rs.getString("email");
            }
            if (email == null) {
                resp.getWriter().println("Không tìm thấy email người dùng");
                return;
            }

            // Lưu OTP vào DB
            PreparedStatement psOtp = conn.prepareStatement(
                    "INSERT INTO email_otps(user_id, otp_code, created_at) VALUES (?, ?, NOW())");
            psOtp.setInt(1, userId);
            psOtp.setString(2, otpCode);
            psOtp.executeUpdate();

            // Gửi email OTP (ở đây giả lập)
            EmailOTPUtil.sendOtpEmail(email, otpCode);

            req.setAttribute("sessionId", sessionId);
            req.getRequestDispatcher("verify-otp.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}


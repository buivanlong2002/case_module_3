package org.example.casemd3.controller;

import org.example.casemd3.dao.AuthDao;
import org.example.casemd3.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final AuthService authService = new AuthService();
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String method = req.getParameter("method");
        if (!"account".equals(method)) {
            req.setAttribute("error", "Phương thức không hợp lệ.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        String username = req.getParameter("username");
        String email = req.getParameter("gmail"); // Đồng bộ với JSP
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            req.setAttribute("error", "Email không hợp lệ.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        if (authService.isUserOrEmailExist(username, email)) {
            req.setAttribute("error", "Tên đăng nhập hoặc email đã tồn tại.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        boolean inserted = authService.registerUser(username, email, password);
        if (inserted) {
            resp.sendRedirect("login.jsp");
        } else {
            req.setAttribute("error", "Đăng ký thất bại, vui lòng thử lại.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        }
    }
}
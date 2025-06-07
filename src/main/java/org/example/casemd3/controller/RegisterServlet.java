package org.example.casemd3.controller;

import org.example.casemd3.dao.AuthDao;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final AuthDao authDao = new AuthDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");


        try {
            if (authDao.isUserOrEmailExist(username, email)) {
                resp.setContentType("text/html;charset=UTF-8");
                resp.getWriter().println("Tên đăng nhập hoặc email đã tồn tại. Vui lòng chọn tên khác.");
                return;
            }

            boolean inserted = authDao.insertUser(username, email, password);
            if (inserted) {
                resp.sendRedirect("login.jsp");
            } else {
                resp.setContentType("text/html;charset=UTF-8");
                resp.getWriter().println("Đăng ký thất bại, vui lòng thử lại.");
            }
        } catch (SQLException e) {
            resp.setContentType("text/html;charset=UTF-8");
            resp.getWriter().println("Lỗi đăng ký: " + e.getMessage());
        }
    }
}

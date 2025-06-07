package org.example.casemd3.controller;


import org.example.casemd3.dao.UserSessionDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")  // Hoặc giới hạn đường dẫn như /secure/* nếu muốn
public class AuthFilter implements Filter {
    private final UserSessionDAO sessionDAO = new UserSessionDAO();

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) servletRequest;
        HttpServletResponse resp = (HttpServletResponse) servletResponse;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();

        // Cho phép truy cập không cần đăng nhập vào các trang login, register, static...
        if (uri.contains("/login") || uri.contains("/register") || uri.contains("/css") || uri.contains("/js")) {
            chain.doFilter(req, resp);
            return;
        }

        if (session != null && session.getAttribute("userId") != null && session.getAttribute("sessionId") != null) {
            int userId = (int) session.getAttribute("userId");
            String sessionId = (String) session.getAttribute("sessionId");

            // Kiểm tra sessionId có còn trong DB không
            boolean stillValid = sessionDAO.isSessionValid(userId, sessionId);
            if (stillValid) {
                chain.doFilter(req, resp); // Cho qua
                return;
            } else {
                session.invalidate(); // Hủy phiên nếu không còn hợp lệ
            }
        }

        // Nếu không có session hợp lệ → redirect về login
        resp.sendRedirect("/login.jsp");
    }
}


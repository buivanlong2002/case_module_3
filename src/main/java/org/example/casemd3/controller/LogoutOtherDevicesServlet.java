package org.example.casemd3.controller;

import org.example.casemd3.dao.UserSessionDAO;
import org.example.casemd3.model.User;
import org.example.casemd3.model.UserSession;
import org.example.casemd3.util.UserAgentUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/logout-other-devices")
public class LogoutOtherDevicesServlet extends HttpServlet {
    private final UserSessionDAO sessionDAO = new UserSessionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        int userId = currentUser.getUser_id();
        String userAgent = req.getHeader("User-Agent");
        String browserName = UserAgentUtil.getBrowserName(userAgent);
        System.out.println(userAgent);
        try {
            List<UserSession> sessions = sessionDAO.getSessionsByUser(userId);

            for (UserSession us : sessions) {
                if (!us.getUserAgent().equals(browserName)) {
                    sessionDAO.deleteSession(us.getUserAgent());
                }
            }

            req.setAttribute("message", " Bạn đã đăng xuất khỏi tất cả thiết bị khác.");
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("message", " Có lỗi khi đăng xuất thiết bị khác.");
        }

        req.getRequestDispatcher("change-password.jsp").forward(req, resp);
    }


}

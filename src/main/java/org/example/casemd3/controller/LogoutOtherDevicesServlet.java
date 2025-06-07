package org.example.casemd3.controller;

import org.example.casemd3.dao.UserSessionDAO;
import org.example.casemd3.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/logout-other-devices")
public class LogoutOtherDevicesServlet extends HttpServlet {
    private final UserSessionDAO sessionDAO = new UserSessionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        String currentSessionId = session.getId();
        System.out.println(currentSessionId);

        //            sessionDAO.invalidateOtherSessions(currentUser.getUser_id(), currentSessionId);
        req.setAttribute("message", "Bạn đã đăng xuất khỏi tất cả thiết bị khác.");
        req.getRequestDispatcher("change-password.jsp").forward(req, resp);
    }
}

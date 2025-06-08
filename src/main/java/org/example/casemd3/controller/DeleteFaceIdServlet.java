package org.example.casemd3.controller;


import org.example.casemd3.dao.FaceIdDao;
import org.example.casemd3.model.User;
import org.example.casemd3.service.FaceIdService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DeleteFaceIdServlet", urlPatterns = {"/deleteFaceId"})
public class DeleteFaceIdServlet extends HttpServlet {

    private final FaceIdService faceIdService = new FaceIdService();



    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String tokenToDelete = req.getParameter("token");
        if (tokenToDelete != null && !tokenToDelete.isEmpty()) {
            faceIdService.deleteFaceToken( tokenToDelete);
        }

        resp.sendRedirect("face_id");
    }
}

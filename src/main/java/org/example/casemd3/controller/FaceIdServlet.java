package org.example.casemd3.controller;

;
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
import java.util.List;

@WebServlet(name = "FaceIdServlet", urlPatterns = {"/face_id"})
public class FaceIdServlet extends HttpServlet {
    private final FaceIdDao faceIdDao = new FaceIdDao();


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        List<String> faceTokens = faceIdDao.getFaceTokensByUserId(user.getUser_id());
        req.setAttribute("faceTokens", faceTokens);

        req.getRequestDispatcher("/face_id.jsp").forward(req, resp);
    }
}

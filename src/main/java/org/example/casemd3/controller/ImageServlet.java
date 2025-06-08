package org.example.casemd3.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "D:/uploads/avatar";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestedImage = request.getPathInfo(); // ví dụ: /abc123.jpg

        if (requestedImage == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        File imageFile = new File(UPLOAD_DIR, requestedImage);
        if (!imageFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (requestedImage.endsWith(".png")) {
            response.setContentType("image/png");
        } else if (requestedImage.endsWith(".jpg") || requestedImage.endsWith(".jpeg")) {
            response.setContentType("image/jpeg");
        } else {
            response.setContentType("application/octet-stream");
        }

        try (FileInputStream fis = new FileInputStream(imageFile);
             OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[1024];
            int len;
            while ((len = fis.read(buffer)) != -1) {
                os.write(buffer, 0, len);
            }
        }
    }
}

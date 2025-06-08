<%@ page import="org.example.casemd3.model.User" %><%--
  Created by IntelliJ IDEA.
  User: LONGBV
  Date: 08/06/2025
  Time: 2:40 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Đăng ký Face ID</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            max-width: 500px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        video {
            display: none; /* Ẩn camera */
        }
        canvas {
            display: none; /* Ẩn canvas */
        }
    </style>
</head>
<body>

<div class="container text-center">
    <h2>Đăng ký Face ID mới</h2>
    <p>Hệ thống sẽ tự động chụp ảnh khuôn mặt sau 2 giây để đăng ký Face ID.</p>

    <video id="video" autoplay playsinline></video>
    <canvas id="canvas"></canvas>

    <form id="faceForm" action="register-face" method="post" enctype="multipart/form-data">
        <input type="hidden" name="photoBase64" id="photoBase64" />
        <button type="submit" class="btn btn-primary mt-3" disabled id="submitBtn">Đăng ký Face ID</button>
        <a href="profile" class="btn btn-secondary mt-3">Quay lại</a>
    </form>

    <div id="message" class="mt-3"></div>
</div>

<script>
    const video = document.getElementById('video');
    const canvas = document.getElementById('canvas');
    const photoBase64Input = document.getElementById('photoBase64');
    const submitBtn = document.getElementById('submitBtn');
    const message = document.getElementById('message');

    // Yêu cầu quyền truy cập camera
    navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
            video.srcObject = stream;
            video.play();

            // Sau 2 giây, tự động chụp ảnh
            setTimeout(() => {
                capturePhoto();
                stopVideoStream(stream);
            }, 2000);
        })
        .catch(err => {
            message.innerHTML = '<div class="alert alert-danger">Không thể truy cập camera: ' + err.message + '</div>';
        });

    function capturePhoto() {
        const context = canvas.getContext('2d');
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;

        context.drawImage(video, 0, 0, canvas.width, canvas.height);

        // Chuyển ảnh sang base64
        const dataURL = canvas.toDataURL('image/png');
        photoBase64Input.value = dataURL;

        message.innerHTML = '<div class="alert alert-success">Ảnh khuôn mặt đã được chụp tự động. Bạn có thể đăng ký Face ID.</div>';
        submitBtn.disabled = false;
    }

    function stopVideoStream(stream) {
        stream.getTracks().forEach(track => track.stop());
        video.srcObject = null;
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-container {
            max-width: 400px;
            margin: 80px auto;
            padding: 30px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        #video, #canvas {
            display: none;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="login-container">
        <h2 class="text-center mb-4">Đăng nhập</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                    ${error}
            </div>
        </c:if>

        <!-- Form đăng nhập bằng tài khoản -->
        <form action="login" method="post">
            <input type="hidden" name="method" value="account" />
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="text" name="email" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <label><input type="checkbox" name="remember"> Ghi nhớ đăng nhập</label><br>
            <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
        </form>

        <hr>

        <!-- Nút đăng nhập bằng khuôn mặt -->
        <button type="button" class="btn btn-success w-100" onclick="startFaceLogin()">Đăng nhập bằng Face ID</button>

        <!-- Camera ẩn -->
        <video id="video" autoplay playsinline></video>
        <canvas id="canvas"></canvas>

        <p id="faceStatus" class="text-center mt-3 text-secondary" style="display: none;">Đang nhận diện khuôn mặt...</p>

        <p class="text-center mt-3">
            Chưa có tài khoản?
            <a href="register.jsp">Đăng ký</a>
        </p>
    </div>
</div>

<script>
    function startFaceLogin() {
        const video = document.getElementById("video");
        const canvas = document.getElementById("canvas");
        const statusText = document.getElementById("faceStatus");

        statusText.style.display = "block";
        statusText.textContent = "Đang mở camera...";

        navigator.mediaDevices.getUserMedia({ video: true })
            .then(stream => {
                video.srcObject = stream;

                // Chờ 2 giây rồi chụp ảnh
                setTimeout(() => {
                    statusText.textContent = "Đang xác thực...";

                    const ctx = canvas.getContext("2d");
                    canvas.width = video.videoWidth;
                    canvas.height = video.videoHeight;
                    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

                    // Tắt camera
                    stream.getTracks().forEach(track => track.stop());

                    // Gửi ảnh
                    canvas.toBlob(blob => {
                        const formData = new FormData();
                        formData.append("method", "face");
                        formData.append("photo", blob, "face.jpg");

                        fetch("login", {
                            method: "POST",
                            body: formData
                        })
                            .then(response => response.text())
                            .then(html => {
                                document.open();
                                document.write(html);
                                document.close();
                            });
                    }, "image/jpeg");
                }, 1500);
            })
            .catch(err => {
                alert("Không thể truy cập camera: " + err.message);
            });
    }
</script>

</body>
</html>

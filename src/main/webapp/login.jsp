<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #6e8efb, #a777e3);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', sans-serif;
        }
        .login-container {
            max-width: 450px;
            padding: 2.5rem;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            animation: fadeIn 0.5s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .form-control {
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #6e8efb;
            box-shadow: 0 0 0 0.25rem rgba(110, 142, 251, 0.25);
        }
        .btn-primary, .btn-success {
            border-radius: 10px;
            padding: 12px;
            font-weight: 500;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-primary:hover, .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        .btn-primary {
            background: #6e8efb;
            border: none;
        }
        .btn-success {
            background: #28c76f;
            border: none;
        }
        #video, #canvas {
            display: none;
        }
        #faceStatus {
            transition: opacity 0.3s ease;
        }
        .form-label {
            font-weight: 500;
            color: #333;
        }
        .alert {
            border-radius: 10px;
            margin-bottom: 1.5rem;
        }
        .text-secondary {
            color: #6c757d !important;
        }
        .register-link {
            color: #6e8efb;
            text-decoration: none;
            font-weight: 500;
        }
        .register-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2 class="text-center mb-4 fw-bold">Đăng nhập</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">
                ${error}
        </div>
    </c:if>

    <!-- Form đăng nhập bằng tài khoản -->
    <form action="login" method="post">
        <input type="hidden" name="method" value="account" />
        <div class="mb-3">
            <label class="form-label"><i class="fas fa-envelope me-2"></i>Email</label>
            <input type="text" name="email" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label"><i class="fas fa-lock me-2"></i>Mật khẩu</label>
            <input type="password" name="password" class="form-control" required>
        </div>
        <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" name="remember" id="remember">
            <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
        </div>
        <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
    </form>

    <div class="d-flex align-items-center my-4">
        <hr class="flex-grow-1"> <span class="mx-2 text-secondary">Hoặc</span> <hr class="flex-grow-1">
    </div>

    <!-- Nút đăng nhập bằng khuôn mặt -->
    <button type="button" class="btn btn-success w-100" onclick="startFaceLogin()">
        <i class="fas fa-camera me-2"></i>Đăng nhập bằng Face ID
    </button>

    <!-- Camera ẩn -->
    <video id="video" autoplay playsinline></video>
    <canvas id="canvas"></canvas>

    <p id="faceStatus" class="text-center mt-3 text-secondary" style="display: none;">
        <i class="fas fa-spinner fa-spin me-2"></i>Đang nhận diện khuôn mặt...
    </p>

    <p class="text-center mt-4">
        Chưa có tài khoản? <a href="register.jsp" class="register-link">Đăng ký</a>
    </p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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

                setTimeout(() => {
                    statusText.textContent = "Đang xác thực...";

                    const ctx = canvas.getContext("2d");
                    canvas.width = video.videoWidth;
                    canvas.height = video.videoHeight;
                    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

                    stream.getTracks().forEach(track => track.stop());

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
                statusText.style.display = "none";
            });
    }
</script>
</body>
</html>
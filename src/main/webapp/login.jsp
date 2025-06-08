<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8f9fa;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', 'Segoe UI', sans-serif;
            padding: 20px;
        }
        .login-form {
            max-width: 380px;
            width: 100%;
        }
        .form-control {
            border: none;
            border-bottom: 1px solid #d1d5db;
            border-radius: 0;
            background: transparent;
            padding: 8px 0;
            font-size: 0.95rem;
            color: #1f2937;
            transition: border-color 0.2s ease;
        }
        .form-control:focus {
            border-color: #60a5fa;
            box-shadow: none;
            background: transparent;
        }
        .form-label {
            font-weight: 500;
            color: #1f2937;
            font-size: 0.85rem;
            margin-bottom: 6px;
        }
        .btn-primary {
            border-radius: 8px;
            padding: 10px;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            background: linear-gradient(90deg, #60a5fa, #3b82f6);
            border: none;
            transition: all 0.2s ease;
        }
        .btn-primary:hover {
            background: linear-gradient(90deg, #3b82f6, #2563eb);
            transform: scale(1.02);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .face-id-button {
            background: #4b5563;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }
        .face-id-button:hover {
            background: #374151;
        }
        .face-id-button svg {
            width: 20px;
            height: 20px;
        }
        .face-id-button::after {
            content: attr(title);
            position: absolute;
            bottom: -30px;
            left: 50%;
            transform: translateX(-50%);
            background: #1f2937;
            color: #fff;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.75rem;
            opacity: 0;
            pointer-events: none;
            white-space: nowrap;
            transition: opacity 0.2s ease;
        }
        .face-id-button:hover::after {
            opacity: 1;
        }
        #video, #canvas {
            display: none;
        }
        .error-message {
            color: #dc2626; /* Đỏ cảnh báo */
            font-size: 0.85rem;
            margin-top: 8px;
            text-align: center;
            line-height: 1.4;
            font-weight: 500;
        }

        .text-secondary {
            color: #6b7280 !important;
            font-size: 0.85rem;

            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
            line-height: 1.5;
        }
        .form-check {
            margin-bottom: 1.25rem;
        }
        .form-check-label {
            color: #1f2937;
            font-size: 0.85rem;
        }
        .register-link {
            color: #60a5fa;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.85rem;
        }
        .register-link:hover {
            text-decoration: underline;
        }
        .button-group {
            display: flex;
            gap: 8px;
            align-items: center;
        }
    </style>
</head>
<body>
<div class="login-form">
    <h2 class="text-center mb-4 fw-semibold" style="color: #1f2937; font-size: 1.5rem;">Đăng nhập</h2>

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
        <div class="form-check">
            <input type="checkbox" class="form-check-input" name="remember" id="remember">
            <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
        </div>
        <div class="button-group">
            <button type="submit" class="btn btn-primary flex-grow-1">Đăng nhập</button>
            <button type="button" class="face-id-button" onclick="startFaceLogin()" title="Đăng nhập bằng Face ID">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="1.5" stroke-linecap="round">
                    <path d="M3 5c0-1.1.9-2 2-2h2M3 19c0 1.1.9 2 2 2h2M19 3c1.1 0 2 .9 2 2v2M19 21c1.1 0 2-.9 2-2v-2"></path>
                    <circle cx="9" cy="10" r="1"></circle>
                    <circle cx="15" cy="10" r="1"></circle>
                    <path d="M9 15c1.5 1 4.5 1 6 0"></path>
                </svg>
            </button>
        </div>
        <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
        </c:if>
    </form>

    <p id="faceStatus" class="text-center mt-3 text-secondary" style="display: none;">
        Đang nhận diện khuôn mặt...
    </p>

    <p class="text-center mt-3">
        Chưa có tài khoản? <a href="register.jsp" class="register-link">Đăng ký</a>
    </p>

    <!-- Camera ẩn -->
    <video id="video" autoplay playsinline></video>
    <canvas id="canvas"></canvas>
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
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
        #faceLoginForm {
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

        <!-- Nút kích hoạt đăng nhập bằng khuôn mặt -->
        <button type="button" class="btn btn-success w-100" onclick="startFaceLogin()">Đăng nhập bằng Face ID</button>

        <!-- Form đăng nhập bằng khuôn mặt -->
        <form id="faceLoginForm" action="login" method="post" enctype="multipart/form-data">
            <input type="hidden" name="method" value="face">
            <input type="file" name="photo" accept="image/*" class="form-control mt-3" required>
            <button type="submit" class="btn btn-secondary mt-2 w-100">Xác thực khuôn mặt</button>
        </form>

        <p class="text-center mt-3">
            Chưa có tài khoản?
            <a href="register.jsp">Đăng ký</a>
        </p>
    </div>
</div>

<script>
    function startFaceLogin() {
        document.getElementById('faceLoginForm').style.display = 'block';
    }
</script>

</body>
</html>

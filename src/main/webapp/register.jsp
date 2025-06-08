<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản</title>
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
        .register-form {
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
        .error-message {
            color: #dc2626;
            font-size: 0.85rem;
            margin-top: 8px;
            text-align: center;
            line-height: 1.4;
            font-weight: 500;
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
    </style>
</head>
<body>
<div class="register-form">
    <h2 class="text-center mb-4 fw-semibold" style="color: #1f2937; font-size: 1.5rem;">Đăng ký tài khoản</h2>

    <!-- Form đăng ký bằng tài khoản -->
    <form action="register" method="post">
        <input type="hidden" name="method" value="account" />
        <div class="mb-3">
            <label class="form-label">Tên tài khoản</label>
            <input type="text" name="username" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="text" name="gmail" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Mật khẩu</label>
            <input type="password" name="password" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Xác nhận mật khẩu</label>
            <input type="password" name="confirmPassword" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Đăng ký</button>
        <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
        </c:if>
    </form>

    <p class="text-center mt-3">
        Đã có tài khoản? <a href="login.jsp" class="register-link">Đăng nhập</a>
    </p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
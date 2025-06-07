<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác thực OTP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .form-container {
            max-width: 500px;
            margin: 80px auto;
            padding: 30px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="form-container">
        <h3 class="mb-4 text-center">Xác thực OTP để đăng xuất</h3>

        <form action="remote-logout" method="post">
            <input type="hidden" name="sessionId" value="${sessionId}" />

            <div class="mb-3">
                <label for="otp" class="form-label">Mã OTP đã gửi qua email</label>
                <input type="text" class="form-control" id="otp" name="otp" placeholder="Nhập mã OTP" required />
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-primary">Xác thực & Đăng xuất</button>
            </div>
        </form>

        <div class="mt-3 text-center">
            <a href="session-list" class="text-decoration-none">← Quay lại danh sách phiên</a>
        </div>
    </div>
</div>
</body>
</html>

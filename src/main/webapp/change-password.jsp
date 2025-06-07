<%--
  Created by IntelliJ IDEA.
  User: LONGBV
  Date: 05/06/2025
  Time: 10:50 SA
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Đổi mật khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        /* CSS tương tự profile.jsp để đồng bộ giao diện */
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .sidebar { min-height: 90vh; background: linear-gradient(135deg, #ffffff, #e9ecef); padding: 20px; border-right: 1px solid #dee2e6; box-shadow: 2px 0 10px rgba(0,0,0,0.05);}
        .profile-img { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 4px solid #ffffff; box-shadow: 0 0 10px rgba(0,0,0,0.1);}
        .nav-link { color: #495057; padding: 10px 15px; border-radius: 8px; transition: all 0.3s ease; margin: 5px 0; font-size: 0.95rem; }
        .nav-link:hover { background-color: #e9ecef; color: #007bff; }
        .nav-link.active { background-color: #007bff; color: white; font-weight: 500; box-shadow: 0 2px 5px rgba(0,123,255,0.2);}
        .content { padding: 30px; background-color: white; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); margin: 20px 0; max-width: 600px; }
        label { font-weight: 600; }
        input.form-control { margin-bottom: 15px; }
        .btn-primary { background-color: #007bff; border: none; padding: 10px 20px; border-radius: 8px; transition: background-color 0.3s ease;}
        .btn-primary:hover { background-color: #0056b3; }
    </style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) username = "Văn Long Bùi";
%>

<div class="container-fluid mt-4">
    <div class="row">
        <div class="col-md-3">
            <div class="sidebar">
                <div class="text-center mb-4">
                    <img src="profile-image.jpg" alt="Profile Image" class="profile-img mx-auto d-block" />
                    <h5 class="mt-3"><%= username %></h5>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item"><a class="nav-link" href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                    <li class="nav-item"><a class="nav-link active" href="change-password.jsp"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                    <li class="nav-item"><a class="nav-link" href="session-list"><i class="fas fa-desktop"></i> Kiểm tra các thiết bị đăng nhập</a></li>
                    <li class="nav-item"><a class="nav-link" href="logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
                </ul>
            </div>
        </div>

        <div class="col-md-9 d-flex justify-content-center">
            <div class="content">
                <h4>Đổi mật khẩu</h4>
                <hr />
                <form action="changePassword" method="post">
                    <label for="currentPassword">Mật khẩu hiện tại</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="form-control" required />
                    <label for="newPassword">Mật khẩu mới</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-control" required />
                    <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required />
                    <button type="submit" class="btn btn-primary mt-3">Cập nhật mật khẩu</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

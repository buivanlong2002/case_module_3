<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.example.casemd3.model.User" %>
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
    <meta charset="UTF-8">
    <title>Thông tin cá nhân</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f4f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .sidebar {
            min-height: 90vh;
            background: linear-gradient(135deg, #ffffff, #e9ecef);
            padding: 20px;
            border-right: 1px solid #dee2e6;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
        }
        .profile-img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #ffffff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .nav-link {
            color: #495057;
            padding: 10px 15px;
            border-radius: 8px;
            transition: all 0.3s ease;
            margin: 5px 0;
            font-size: 0.95rem;
        }
        .nav-link:hover {
            background-color: #e9ecef;
            color: #007bff;
        }
        .nav-link.active {
            background-color: #007bff;
            color: white;
            font-weight: 500;
            box-shadow: 0 2px 5px rgba(0,123,255,0.2);
        }
        .content {
            padding: 30px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            margin: 20px 0;
        }
        .content h4 {
            color: #343a40;
            font-weight: 600;
        }
        .personal-info-card {
            background: linear-gradient(135deg, #f8f9fa, #ffffff);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #e9ecef;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .personal-info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        .info-item {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            color: #495057;
        }
        .info-item i {
            margin-right: 10px;
            color: #007bff;
            font-size: 18px;
        }
        .btn-primary {
            background-color: #007bff;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="container-fluid mt-4">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-3">
            <div class="sidebar">
                <div class="text-center mb-4">
                    <img src="profile-image.jpg" alt="Profile Image" class="profile-img mx-auto d-block">
                    <h5 class="mt-3"><%= user.getUsername() %></h5>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="change-password.jsp"><i class="fas fa-lock"></i> Đổi mật khẩu</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="session-list"><i class="fas fa-desktop"></i> Thiết bị đăng nhập</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9">
            <div class="content" id="personal-info">
                <h4>Thông tin cá nhân</h4>
                <hr>
                <div class="personal-info-card">
                    <div class="info-item">
                        <i class="fas fa-envelope"></i>
                        <strong>Email:</strong>&nbsp;<%= user.getEmail() %>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-phone"></i>
                        <strong>Số điện thoại:</strong>&nbsp;<%= user.getPhone() != null ? user.getPhone() : "Chưa cập nhật" %>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-calendar"></i>
                        <strong>Ngày sinh:</strong>&nbsp;<%= user.getBirthday() != null ? user.getBirthday().toString() : "Chưa cập nhật" %>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <strong>Địa chỉ:</strong>&nbsp;<%= user.getAddress() != null ? user.getAddress() : "Chưa cập nhật" %>
                    </div>
                    <a href="editProfile.jsp" class="btn btn-primary mt-3">Chỉnh sửa thông tin</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

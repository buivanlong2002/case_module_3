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
                    <div class="profile-img-wrapper" title="Thay đổi ảnh đại diện">
                        <img src="<%= user.getImage() != null ? user.getImage() : "default.png" %>"
                             alt="Avatar mặc định" class="profile-img"/>
                        <a href="change-avatar.jsp" class="edit-icon" aria-label="Thay đổi ảnh đại diện">
                            <i class="fas fa-pencil-alt"></i>
                        </a>
                    </div>
                    <h5 class="mt-3"><%= user.getUsername() %></h5>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item"><a class="nav-link " href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                    <li class="nav-item"><a class="nav-link " href="change-password.jsp"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                    <li class="nav-item"><a class="nav-link" href="session-list"><i class="fas fa-desktop"></i> Kiểm tra các thiết bị đăng nhập</a></li>
                    <li class="nav-item"><a class="nav-link active" href="face_id.jsp"><i class="fas fa-user-circle"></i> Face Id</a></li>
                    <li class="nav-item"><a class="nav-link" href="logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
                </ul>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9">
            <div class="content">
                <h4>Danh sách Face ID đã đăng ký</h4>
                <hr>

                <c:choose>
                    <c:when test="${not empty faceTokens}">
                        <table class="table table-bordered align-middle mt-3">
                            <thead class="table-light">
                            <tr>
                                <th style="width: 5%;">#</th>
                                <th>Face Token</th>
                                <th style="width: 15%;">Hành động</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="token" items="${faceTokens}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>${token}</td>
                                    <td>
                                        <form action="deleteFaceId" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa Face ID này?');">
                                            <input type="hidden" name="token" value="${token}">
                                            <button type="submit" class="btn btn-danger btn-sm">
                                                <i class="fas fa-trash-alt"></i> Xóa
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info">Bạn chưa có Face ID nào được lưu.</div>
                    </c:otherwise>
                </c:choose>

                <div class="mt-4">
                    <a href="register-face.jsp" class="btn btn-primary">
                        <i class="fas fa-plus-circle"></i> Thêm Face ID mới
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Thông tin cá nhân</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --background-color: #f8f9fa;
            --card-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            --transition: all 0.3s ease;
        }

        body {
            background-color: var(--background-color);
            font-family: 'Inter', sans-serif;
            color: #2d3748;
            line-height: 1.6;
        }

        .sidebar {
            min-height: 100vh;
            background: linear-gradient(180deg, #ffffff, #f1f5f9);
            padding: 30px 20px;
            border-right: 1px solid #e2e8f0;
            box-shadow: 3px 0 15px rgba(0, 0, 0, 0.05);
        }

        .profile-img-wrapper {
            position: relative;
            width: 130px;
            height: 130px;
            margin: 0 auto;
            transition: transform var(--transition);
        }

        .profile-img-wrapper:hover {
            transform: scale(1.05);
        }

        .profile-img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #ffffff;
            box-shadow: var(--card-shadow);
        }

        .edit-icon {
            position: absolute;
            bottom: 8px;
            right: 8px;
            background-color: var(--primary-color);
            color: white;
            border-radius: 50%;
            padding: 8px;
            font-size: 16px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            transition: var(--transition);
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
        }

        .edit-icon:hover {
            background-color: #0056b3;
            transform: scale(1.1);
        }

        .nav-link {
            color: #4a5568;
            padding: 12px 20px;
            border-radius: 10px;
            transition: var(--transition);
            margin: 8px 0;
            font-size: 1rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-link:hover {
            background-color: #edf2f7;
            color: var(--primary-color);
            transform: translateX(5px);
        }

        .nav-link.active {
            background-color: var(--primary-color);
            color: white;
            font-weight: 600;
            box-shadow: 0 3px 8px rgba(0, 123, 255, 0.3);
        }

        .content {
            padding: 40px;
            background-color: white;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
            margin: 20px 0;
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .content h4 {
            color: #2d3748;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .personal-info-card {
            background: linear-gradient(135deg, #ffffff, #f8fafc);
            padding: 25px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            transition: var(--transition);
        }

        .personal-info-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .info-item {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            color: #4a5568;
            font-size: 1rem;
        }

        .info-item i {
            margin-right: 12px;
            color: var(--primary-color);
            font-size: 20px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 500;
            transition: var(--transition);
        }

        .btn-primary:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
            box-shadow: 0 3px 8px rgba(0, 123, 255, 0.3);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .sidebar {
                min-height: auto;
                padding: 20px;
            }

            .profile-img-wrapper {
                width: 100px;
                height: 100px;
            }

            .content {
                padding: 20px;
            }

            .nav-link {
                font-size: 0.9rem;
                padding: 10px 15px;
            }
        }
    </style>
</head>
<body>
<div class="container-fluid mt-4">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-lg-3 col-md-4">
            <div class="sidebar">
                <div class="text-center mb-4">
                    <div class="profile-img-wrapper" title="Thay đổi ảnh đại diện">
                        <img src="<%= user.getImage() != null ? user.getImage() : "default.png" %>"
                             alt="Avatar mặc định" class="profile-img"/>
                        <a href="change-avatar.jsp" class="edit-icon" aria-label="Thay đổi ảnh đại diện">
                            <i class="fas fa-pencil-alt"></i>
                        </a>
                    </div>
                    <h5 class="mt-3 fw-bold"><%= user.getUsername() %></h5>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item"><a class="nav-link active" href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                    <li class="nav-item"><a class="nav-link" href="change-password.jsp"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                    <li class="nav-item"><a class="nav-link" href="session-list"><i class="fas fa-desktop"></i> Kiểm tra thiết bị đăng nhập</a></li>
                    <li class="nav-item"><a class="nav-link" href="face_id.jsp"><i class="fas fa-user-circle"></i> Face ID</a></li>
                    <li class="nav-item"><a class="nav-link" href="logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
                </ul>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-lg-9 col-md-8">
            <div class="content" id="personal-info">
                <h4>Thông tin cá nhân</h4>
                <hr>
                <div class="personal-info-card">
                    <div class="info-item">
                        <i class="fas fa-envelope"></i>
                        <strong>Email:</strong> <%= user.getEmail() %>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-phone"></i>
                        <strong>Số điện thoại:</strong> <%= user.getPhone() != null ? user.getPhone() : "Chưa cập nhật" %>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-calendar"></i>
                        <strong>Ngày sinh:</strong> <%= user.getBirthday() != null ? user.getBirthday().toString() : "Chưa cập nhật" %>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <strong>Địa chỉ:</strong> <%= user.getAddress() != null ? user.getAddress() : "Chưa cập nhật" %>
                    </div>
                    <a href="editProfile.jsp" class="btn btn-primary mt-3">Chỉnh sửa thông tin</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Optional: Add smooth scrolling for sidebar links
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            const href = this.getAttribute('href');
            window.location.href = href;
        });
    });
</script>
</body>
</html>
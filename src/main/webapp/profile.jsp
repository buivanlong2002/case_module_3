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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thông tin cá nhân</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;500;600;700&display=swap" rel="stylesheet">

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
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
        }

        .profile-img-wrapper {
            position: relative;
            width: 120px;
            height: 120px;
            margin: 0 auto;
        }

        .profile-img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #ffffff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .edit-icon {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background-color: #007bff;
            color: white;
            border-radius: 50%;
            padding: 6px;
            font-size: 14px;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            transition: background-color 0.3s ease;
        }

        .edit-icon:hover {
            background-color: #0056b3;
        }

        .nav-link {
            color: #495057;
            padding: 10px 15px;
            border-radius: 8px;
            transition: all 0.3s ease;
            margin: 5px 0;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-link:hover {
            background-color: #e9ecef;
            color: #007bff;
        }

        .nav-link.active {
            background-color: #007bff;
            color: white;
            font-weight: 500;
            box-shadow: 0 2px 5px rgba(0, 123, 255, 0.2);
        }

        .content {
            padding: 30px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            margin: 20px 0;
            max-width: 900px;
        }

        .personal-info-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            transition: all 0.3s ease;
        }

        .personal-info-card:hover {
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
        }

        .info-item {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            color: #495057;
            font-size: 0.95rem;
        }

        .info-item i {
            margin-right: 10px;
            color: #007bff;
            font-size: 18px;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            box-shadow: 0 2px 5px rgba(0, 123, 255, 0.2);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .sidebar {
                min-height: auto;
                padding: 15px;
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
                padding: 8px 12px;
            }
        }
        .data-value {

            color: #121111;            /* màu xanh dương nổi bật */
            font-weight: 450;          /* chữ đậm vừa phải */
            letter-spacing: 0.02em;    /* khoảng cách chữ */
            margin-left: 6px;          /* cách ra khỏi label */
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
                             alt="" class="profile-img"/>
                        <a href="change-avatar.jsp" class="edit-icon" aria-label="Thay đổi ảnh đại diện">
                            <i class="fas fa-pencil-alt"></i>
                        </a>
                    </div>
                    <h5 class="mt-3"><%= user.getUsername() %></h5>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item"><a class="nav-link active" href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                    <li class="nav-item"><a class="nav-link" href="change-password.jsp"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                    <li class="nav-item"><a class="nav-link" href="session-list"><i class="fas fa-desktop"></i> Kiểm tra thiết bị đăng nhập</a></li>
                    <li class="nav-item"><a class="nav-link" href="face_id"><i class="fas fa-user-circle"></i> Face ID</a></li>
                    <li class="nav-item"><a class="nav-link" href="logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
                </ul>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9">
            <div class="content" id="personal-info">
                <h4 class="mb-3"><i class="fas fa-user"></i> Thông tin cá nhân</h4>
                <hr>
                <div class="personal-info-card shadow-sm p-4 rounded">
                    <h3 class="card-title mb-4">Thông tin cá nhân</h3>

                    <div class="info-item">
                        <i class="fas fa-envelope icon"></i>
                        <div>
                            <strong>Email:</strong>
                            <span class="data-value"><%= user.getEmail() %></span>
                        </div>
                    </div>

                    <div class="info-item">
                        <i class="fas fa-phone icon"></i>
                        <div>
                            <strong>Số điện thoại:</strong>
                            <span class="data-value"><%= user.getPhone() != null ? user.getPhone() : "Chưa cập nhật" %></span>
                        </div>
                    </div>

                    <div class="info-item">
                        <i class="fas fa-calendar icon"></i>
                        <div>
                            <strong>Ngày sinh:</strong>
                            <span class="data-value"><%= user.getBirthday() != null ? user.getBirthday().toString() : "Chưa cập nhật" %></span>
                        </div>
                    </div>

                    <div class="info-item">
                        <i class="fas fa-map-marker-alt icon"></i>
                        <div>
                            <strong>Địa chỉ:</strong>
                            <span class="data-value"><%= user.getAddress() != null ? user.getAddress() : "Chưa cập nhật" %></span>
                        </div>
                    </div>
                </div>

                <a href="editProfile.jsp" class="btn btn-primary mt-4 w-100">Chỉnh sửa thông tin</a>
                </div>

            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Smooth scrolling for sidebar links
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
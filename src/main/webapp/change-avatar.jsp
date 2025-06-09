<%@ page import="org.example.casemd3.model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <meta charset="UTF-8" />
    <title>Thay đổi ảnh đại diện</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
        }
        .avatar-container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            max-width: 500px;
            margin: 50px auto;
        }
        .avatar-preview {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #dee2e6;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: block;
            margin: 0 auto 20px;
        }
        .form-label {
            font-weight: 500;
        }
        .btn-primary {
            width: 100%;
        }
    </style>
</head>
<body>

<div class="avatar-container">
    <h4 class="text-center mb-4">Thay đổi ảnh đại diện</h4>


    <img src="<%= user.getImage() != null ? user.getImage() : "default.png" %>"
         alt="" class="profile-img"/>

    <form action="ChangeAvatarServlet" method="post" enctype="multipart/form-data">
        <div class="mb-3">
            <label for="avatarFile" class="form-label">Chọn ảnh mới (jpg, png, ≤ 2MB):</label>
            <input type="file" class="form-control" id="avatarFile" name="avatarFile"
                   accept="image/png, image/jpeg" required onchange="previewImage(event)">
        </div>
        <button type="submit" class="btn btn-primary mt-3">Cập nhật ảnh</button>
        <a href="profile" class="btn btn-outline-secondary w-100 mt-2">Hủy</a>
    </form>
</div>

<script>
    function previewImage(event) {
        const input = event.target;
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('preview').src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

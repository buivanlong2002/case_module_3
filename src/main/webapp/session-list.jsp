<%@ page import="org.example.casemd3.model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Kiểm tra thiết bị đăng nhập</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
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
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
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
      box-shadow: 0 2px 5px rgba(0,123,255,0.2);
    }

    .content {
      padding: 30px;
      background-color: white;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.05);
      margin: 20px 0;
      max-width: 900px;
    }

    h4 {
      color: #343a40;
      font-weight: 600;
    }

    .list-group-item {
      border-radius: 8px;
      margin-bottom: 10px;
      border: 1px solid #dee2e6;
      transition: all 0.3s ease;
    }

    .list-group-item:hover {
      box-shadow: 0 2px 5px rgba(0,0,0,0.08);
    }

    .btn-outline-danger {
      border-radius: 6px;
      padding: 6px 12px;
      font-size: 0.9rem;
      transition: all 0.3s ease;
    }

    .btn-outline-danger:hover {
      background-color: #dc3545;
      color: white;
      border-color: #dc3545;
      box-shadow: 0 2px 5px rgba(220,53,69,0.2);
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
  </style>
</head>
<body>
<%
  User user = (User) session.getAttribute("currentUser");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<div class="container-fluid mt-4">
  <div class="row">
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
          <li class="nav-item"><a class="nav-link" href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
          <li class="nav-item"><a class="nav-link" href="change-password.jsp"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
          <li class="nav-item"><a class="nav-link active" href="session-list"><i class="fas fa-desktop"></i> Kiểm tra thiết bị đăng nhập</a></li>
          <li class="nav-item"><a class="nav-link" href="face_id"><i class="fas fa-user-circle"></i> Face ID</a></li>
          <li class="nav-item"><a class="nav-link" href="logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
        </ul>
      </div>
    </div>

    <div class="col-md-9">
      <div class="content" id="devices">
        <h4 class="mb-3"><i class="fas fa-shield-alt"></i> Kiểm tra thiết bị đăng nhập</h4>
        <hr />
        <ul class="list-group">
          <c:if test="${not empty sessions}">
            <c:forEach var="s" items="${sessions}">
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <div>
                  <i class="fas fa-laptop me-2"></i>
                  <strong>Trình duyệt:</strong> ${s.userAgent}<br />
                  <small class="text-muted">IP: ${s.ipAddress} | Đăng nhập lúc: ${s.loginTime}</small>
                </div>
                <form action="remote-logout" method="post" style="margin:0;">
                  <input type="hidden" name="sessionId" value="${s.sessionId}" />
                  <button type="submit" class="btn btn-outline-danger btn-sm" title="Đăng xuất thiết bị này">
                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                  </button>
                </form>
              </li>
            </c:forEach>
          </c:if>
          <c:if test="${empty sessions}">
            <li class="list-group-item text-center text-muted">Không có thiết bị đăng nhập nào.</li>
          </c:if>
        </ul>
      </div>
    </div>
  </div>
</div>

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
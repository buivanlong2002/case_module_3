<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Thiết bị đăng nhập</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <style>
    /* CSS của bạn giữ nguyên */
    body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    .sidebar { min-height: 90vh; background: linear-gradient(135deg, #ffffff, #e9ecef); padding: 20px; border-right: 1px solid #dee2e6; box-shadow: 2px 0 10px rgba(0,0,0,0.05);}
    .profile-img { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 4px solid #ffffff; box-shadow: 0 0 10px rgba(0,0,0,0.1);}
    .nav-link { color: #495057; padding: 10px 15px; border-radius: 8px; transition: all 0.3s ease; margin: 5px 0; font-size: 0.95rem; }
    .nav-link:hover { background-color: #e9ecef; color: #007bff; }
    .nav-link.active { background-color: #007bff; color: white; font-weight: 500; box-shadow: 0 2px 5px rgba(0,123,255,0.2);}
    .content { padding: 30px; background-color: white; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); margin: 20px 0; max-width: 900px; }
    .btn-danger { background-color: #dc3545; border: none; padding: 6px 12px; border-radius: 6px; transition: background-color 0.3s ease; }
    .btn-danger:hover { background-color: #a71d2a; }
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
          <li class="nav-item"><a class="nav-link" href="change-password.jsp"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
          <li class="nav-item"><a class="nav-link active" href="session-list"><i class="fas fa-desktop"></i> Kiểm tra các thiết bị đăng nhập</a></li>
          <li class="nav-item"><a class="nav-link" href="logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
        </ul>
      </div>
    </div>

    <div class="col-md-9">
      <div class="content" id="devices">
        <h4 class="mb-3"><i class="fas fa-shield-alt"></i> Kiểm tra các thiết bị đăng nhập</h4>
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
                  <input type="hidden" name="ipAddress" value="${s.ipAddress}" />
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

<%--        <div class="text-end mt-4">--%>
<%--          <form action="logoutAllDevicesServlet" method="post" style="display:inline;">--%>
<%--            <button type="submit" class="btn btn-danger">--%>
<%--              <i class="fas fa-box-arrow-right"></i> Đăng xuất tất cả thiết bị--%>
<%--            </button>--%>
<%--          </form>--%>
<%--        </div>--%>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

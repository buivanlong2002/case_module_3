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
    <title>Kiểm tra Face ID</title>
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

        h4 {
            color: #343a40;
            font-weight: 600;
        }

        .table {
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #dee2e6;
        }

        .table th, .table td {
            vertical-align: middle;
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

        .btn-danger {
            background-color: #dc3545;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .btn-danger:hover {
            background-color: #a71d2a;
            box-shadow: 0 2px 5px rgba(220, 53, 69, 0.2);
        }

        .btn-secondary {
            padding: 8px 16px;
            border-radius: 6px;
            transition: all 0.3s ease;
            background-color: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
            box-shadow: 0 2px 5px rgba(108, 117, 125, 0.2);
        }

        .camera-container {
            position: relative;
            width: 400px;
            height: 300px;
            margin: 0 auto;
            border-radius: 15px;
            overflow: hidden;
            background: linear-gradient(135deg, #e0eafc, #cfdef3);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .camera-video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 15px;
        }

        .face-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: 3px solid transparent;
            border-image: linear-gradient(45deg, #007bff, #00c4cc) 1;
            border-radius: 50%;
            clip-path: ellipse(45% 55% at 50% 50%);
            pointer-events: none;
            animation: glow 2s infinite alternate;
            z-index: 10;
        }

        @keyframes glow {
            from { border-image: linear-gradient(45deg, #007bff, #00c4cc) 1; }
            to { border-image: linear-gradient(45deg, #00c4cc, #007bff) 1; }
        }

        .guidance-text {
            position: absolute;
            top: 10px;
            left: 50%;
            transform: translateX(-50%);
            color: #333;
            font-size: 1.1rem;
            font-weight: 500;
            opacity: 0;
            animation: fadeInOut 5s ease-in-out forwards;
            z-index: 20;
        }

        @keyframes fadeInOut {
            0% { opacity: 0; }
            10% { opacity: 1; }
            90% { opacity: 1; }
            100% { opacity: 0; }
        }

        .countdown-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 3rem;
            color: #ffffff;
            text-shadow: 0 0 10px rgba(0, 0, 0, 0.7);
            font-weight: bold;
            pointer-events: none;
            animation: scaleUp 1s infinite alternate;
            z-index: 20;
        }

        @keyframes scaleUp {
            from { transform: translate(-50%, -50%) scale(1); }
            to { transform: translate(-50%, -50%) scale(1.1); }
        }

        .capture-status {
            color: #28a745;
            font-weight: 600;
            font-size: 1.1rem;
            animation: fadeIn 0.5s ease-in;
            z-index: 20;
        }

        .preview-image {
            display: none;
            width: 400px;
            height: 300px;
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 15px;
            object-fit: cover;
            z-index: 30;
        }

        .success-message {
            display: none;
            color: #28a745;
            font-weight: 600;
            font-size: 1.2rem;
            text-align: center;
            margin-top: 10px;
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
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

            .camera-container {
                width: 300px;
                height: 225px;
            }

            .camera-video, .preview-image, #canvas {
                width: 300px;
                height: 225px;
            }
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
                    <li class="nav-item"><a class="nav-link" href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                    <li class="nav-item"><a class="nav-link" href="change-password.jsp"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                    <li class="nav-item"><a class="nav-link" href="session-list"><i class="fas fa-desktop"></i> Kiểm tra thiết bị đăng nhập</a></li>
                    <li class="nav-item"><a class="nav-link active" href="face_id"><i class="fas fa-user-circle"></i> Face ID</a></li>
                    <li class="nav-item"><a class="nav-link" href="logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
                </ul>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9">
            <div class="content">
                <h4 class="mb-3"><i class="fas fa-user-circle"></i> Kiểm tra Face ID</h4>
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
                                        <form action="deleteFaceId" method="post"
                                              on-submit="return confirm('Bạn có chắc chắn muốn xóa Face ID này?');">
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
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                            data-bs-target="#registerFaceModal">
                        <i class="fas fa-plus-circle"></i> Thêm Face ID mới
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal for Face ID Registration -->
<div class="modal fade" id="registerFaceModal" tabindex="-1" aria-labelledby="registerFaceModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form id="faceForm" action="register-face" method="post" enctype="multipart/form-data">
                <div class="modal-header">
                    <h5 class="modal-title" id="registerFaceModalLabel">Đăng ký Face ID mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng" id="closeModalBtn"></button>
                </div>
                <div class="modal-body text-center">
                    <p class="guidance-text">Vui lòng căn chỉnh khuôn mặt vào giữa khung</p>
                    <div class="camera-container position-relative">
                        <video id="video" width="400" height="300" autoplay muted playsinline class="camera-video"></video>
                        <canvas id="canvas" width="400" height="300" style="display:none;"></canvas>
                        <div class="face-overlay"></div>
                        <div id="countdown" class="countdown-text"></div>
                    </div>
                    <div id="captureStatus" class="capture-status mt-3" style="display:none;">
                        <i class="fas fa-check-circle"></i> Ảnh đã được chụp!
                    </div>
                    <img id="imgPreview" class="preview-image" alt="Preview ảnh chụp">
                    <button type="button" class="btn btn-secondary mt-2 d-none" id="retakeBtn">Chụp lại</button>
                    <div id="successMessage" class="success-message"></div>
                </div>
                <div class="modal-footer">
                    <input type="file" name="photo" id="faceImage" accept="image/*" style="display:none;" required />
                    <button type="submit" class="btn btn-primary" id="submitBtn" disabled>Đăng ký</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="cancelBtn">Hủy</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- JS -->
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

    const video = document.getElementById('video');
    const canvas = document.getElementById('canvas');
    const faceImageInput = document.getElementById('faceImage');
    const submitBtn = document.getElementById('submitBtn');
    const captureStatus = document.getElementById('captureStatus');
    const countdownEl = document.getElementById('countdown');
    const retakeBtn = document.getElementById('retakeBtn');
    const imgPreview = document.getElementById('imgPreview');
    const successMessage = document.getElementById('successMessage');

    let stream;

    // Hàm khởi động camera
    async function startCamera() {
        try {
            stream = await navigator.mediaDevices.getUserMedia({ video: true, audio: false });
            video.srcObject = stream;
        } catch (err) {
            alert('Không thể mở camera: ' + err);
        }
    }

    // Hàm dừng camera
    function stopCamera() {
        if (stream) {
            stream.getTracks().forEach(track => track.stop());
        }
    }

    // Hàm đếm ngược
    function startCountdown(seconds, callback) {
        let counter = seconds;
        countdownEl.textContent = counter;

        const interval = setInterval(() => {
            counter--;
            countdownEl.textContent = counter;
            if (counter <= 0) {
                clearInterval(interval);
                countdownEl.textContent = '';
                callback();
            }
        }, 1000);
    }

    // Hàm chụp ảnh
    function capturePhoto() {
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;

        const context = canvas.getContext('2d');
        context.drawImage(video, 0, 0, canvas.width, canvas.height);

        canvas.toBlob(blob => {
            const file = new File([blob], "face_capture.png", { type: "image/png" });

            const dataTransfer = new DataTransfer();
            dataTransfer.items.add(file);
            faceImageInput.files = dataTransfer.files;

            imgPreview.src = URL.createObjectURL(blob);
            imgPreview.style.display = 'block';

            captureStatus.style.display = 'block';
            submitBtn.disabled = false;
            retakeBtn.classList.remove('d-none');
            stopCamera();
        }, 'image/png');
    }

    // Hàm chụp lại
    function retakePhoto() {
        captureStatus.style.display = 'none';
        imgPreview.style.display = 'none';
        successMessage.style.display = 'none';
        submitBtn.disabled = true;
        retakeBtn.classList.add('d-none');
        faceImageInput.value = null;
        imgPreview.src = '';
        successMessage.textContent = '';
        startCamera();
        startCountdown(10, capturePhoto);
    }

    // Hàm gửi form và xử lý phản hồi
    async function submitForm() {
        const formData = new FormData(document.getElementById('faceForm'));

        try {
            const response = await fetch('register-face', {
                method: 'POST',
                body: formData
            });

            const result = await response.json();

            if (result.success) {
                successMessage.textContent = result.message || 'Đăng ký Face ID thành công!';
                successMessage.style.display = 'block';
                captureStatus.style.display = 'none';
                imgPreview.style.display = 'none';
                submitBtn.disabled = true;
                retakeBtn.classList.add('d-none');
                faceImageInput.value = null;
                imgPreview.src = '';
                setTimeout(() => {
                    const modal = bootstrap.Modal.getInstance(document.getElementById('registerFaceModal'));
                    modal.hide();
                }, 2000); // Tự động đóng modal sau 2 giây
            } else {
                alert(result.message || 'Đăng ký thất bại. Vui lòng thử lại!');
            }
        } catch (error) {
            alert('Lỗi khi gửi dữ liệu: ' + error.message);
        }
    }

    // Khi modal được mở
    const modalEl = document.getElementById('registerFaceModal');
    modalEl.addEventListener('show.bs.modal', () => {
        captureStatus.style.display = 'none';
        imgPreview.style.display = 'none';
        successMessage.style.display = 'none';
        submitBtn.disabled = true;
        retakeBtn.classList.add('d-none');
        faceImageInput.value = null;
        imgPreview.src = '';
        successMessage.textContent = '';
        countdownEl.textContent = '';
        startCamera();
        startCountdown(10, capturePhoto);
    });

    // Khi modal đóng
    modalEl.addEventListener('hidden.bs.modal', () => {
        stopCamera();
        imgPreview.style.display = 'none';
        imgPreview.src = '';
        successMessage.style.display = 'none';
        successMessage.textContent = '';
    });

    // Xử lý nút chụp lại
    retakeBtn.addEventListener('click', retakePhoto);

    // Xử lý nút Đăng ký
    submitBtn.addEventListener('click', (e) => {
        e.preventDefault(); // Ngăn submit mặc định
        submitForm();
    });

    // Nếu người dùng bấm hủy hoặc đóng modal
    document.getElementById('cancelBtn').addEventListener('click', () => {
        stopCamera();
        imgPreview.style.display = 'none';
        imgPreview.src = '';
        successMessage.style.display = 'none';
        successMessage.textContent = '';
    });
    document.getElementById('closeModalBtn').addEventListener('click', () => {
        stopCamera();
        imgPreview.style.display = 'none';
        imgPreview.src = '';
        successMessage.style.display = 'none';
        successMessage.textContent = '';
    });
</script>
</body>
</html>
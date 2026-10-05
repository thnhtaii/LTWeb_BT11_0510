<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - KT_QT 24133050</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .main-content {
            flex: 1 0 auto;
        }
        .navbar-custom {
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.15);
            padding: 14px 0;
        }
        .navbar-brand {
            font-weight: 800;
            letter-spacing: -0.5px;
            color: #ffffff !important;
            font-size: 1.35rem;
        }
        .navbar-nav .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
            padding: 8px 16px !important;
            border-radius: 8px;
            transition: all 0.2s ease-in-out;
        }
        .navbar-nav .nav-link:hover, .navbar-nav .nav-link.active {
            color: #ffffff !important;
            background-color: rgba(255, 255, 255, 0.15);
        }
        .badge-admin {
            background-color: #f59e0b;
            color: #78350f;
            font-weight: 700;
            font-size: 0.75rem;
            padding: 4px 8px;
            border-radius: 6px;
        }
        .footer-custom {
            background-color: #0f172a;
            color: #94a3b8;
            padding: 28px 0;
            flex-shrink: 0;
            margin-top: 40px;
            border-top: 3px solid #2563eb;
        }
        .footer-highlight {
            color: #38bdf8;
            font-weight: 600;
        }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>

    <header>
        <nav class="navbar navbar-expand-lg navbar-custom">
            <div class="container">
                <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/home">
                    <i class="fa-solid fa-play-circle text-warning fs-3"></i>
                    <span>KT_QT <span class="badge bg-warning text-dark fs-6 ms-1">Đề 04</span></span>
                </a>
                
                <button class="navbar-toggler text-white border-white" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarMain">
                    <!-- Menu yêu cầu đề thi: Trang Chủ, Sản phẩm, Đăng nhập, Trang quản trị (admin mới có) -->
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/home">
                                <i class="fa-solid fa-house me-1"></i> Trang Chủ
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/category/videos">
                                <i class="fa-solid fa-film me-1"></i> Sản phẩm
                            </a>
                        </li>
                        <c:if test="${sessionScope.user != null}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                                    <i class="fa-solid fa-cart-shopping me-1"></i> Giỏ hàng
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/orders">
                                    <i class="fa-solid fa-clock-rotate-left me-1"></i> Lịch sử đơn
                                </a>
                            </li>
                        </c:if>
                        <!-- Trang quản trị: Chỉ hiển thị khi session có user và user.admin == true -->
                        <c:if test="${sessionScope.user != null && sessionScope.user.admin}">
                            <li class="nav-item">
                                <a class="nav-link text-warning fw-bold" href="${pageContext.request.contextPath}/admin/home">
                                    <i class="fa-solid fa-shield-halved me-1"></i> Trang quản trị
                                    <span class="badge-admin ms-1">ADMIN</span>
                                </a>
                            </li>
                        </c:if>
                    </ul>

                    <!-- Khu vực người dùng / Đăng nhập / Đăng xuất -->
                    <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-lg-center">
                        <c:choose>
                            <c:when test="${sessionScope.user == null}">
                                <li class="nav-item">
                                    <a class="nav-link btn btn-outline-light px-3 py-1 me-2 text-white border border-white" href="${pageContext.request.contextPath}/login">
                                        <i class="fa-solid fa-right-to-bracket me-1"></i> Đăng nhập
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link btn btn-light px-3 py-1 text-primary fw-bold" style="background-color: #ffffff; color: #1e3a8a !important;" href="${pageContext.request.contextPath}/register">
                                        <i class="fa-solid fa-user-plus me-1"></i> Đăng ký
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle text-white d-flex align-items-center gap-2" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                        <div class="rounded-circle bg-white text-primary d-flex align-items-center justify-content-center fw-bold" style="width: 32px; height: 32px;">
                                            ${sessionScope.user.username.substring(0, 1).toUpperCase()}
                                        </div>
                                        <span>${sessionScope.user.fullname != null ? sessionScope.user.fullname : sessionScope.user.username}</span>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                                        <li class="px-3 py-2 border-bottom text-muted small">
                                            Đăng nhập với: <strong>${sessionScope.user.username}</strong>
                                            <c:if test="${sessionScope.user.admin}"><span class="badge bg-danger ms-1">Admin</span></c:if>
                                        </li>
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/cart">
                                                <i class="fa-solid fa-cart-shopping me-2"></i> Giỏ hàng
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/orders">
                                                <i class="fa-solid fa-clock-rotate-left me-2"></i> Lịch sử đặt hàng
                                            </a>
                                        </li>
                                        <li><hr class="dropdown-divider"></li>
                                        <c:if test="${sessionScope.user.admin}">
                                            <li>
                                                <a class="dropdown-item text-primary fw-bold" href="${pageContext.request.contextPath}/admin/home">
                                                    <i class="fa-solid fa-gauge me-2"></i> Bảng điều khiển Admin
                                                </a>
                                            </li>
                                            <li>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/users">
                                                    <i class="fa-solid fa-users-gear me-2"></i> Quản lý Người Dùng
                                                </a>
                                            </li>
                                            <li><hr class="dropdown-divider"></li>
                                        </c:if>
                                        <li>
                                            <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                                <i class="fa-solid fa-arrow-right-from-bracket me-2"></i> Đăng xuất
                                            </a>
                                        </li>
                                    </ul>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <main class="main-content py-4">
        <div class="container">
            <sitemesh:write property='body'/>
        </div>
    </main>

    <footer class="footer-custom">
        <div class="container">
            <div class="row align-items-center text-center text-md-start">
                <div class="col-md-6 mb-3 mb-md-0">
                    <h5 class="text-white fw-bold mb-1">
                        <i class="fa-solid fa-circle-play text-danger me-2"></i>CỔNG VIDEO TRỰC TUYẾN
                    </h5>
                    <p class="mb-0 small text-secondary">Hệ thống chia sẻ và giải trí video trực tuyến</p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <div class="d-inline-block text-start p-2 px-3 rounded bg-dark border border-secondary">
                        <div class="small">Họ tên: <span class="footer-highlight">Đỗ Thanh Thành Tài</span></div>
                        <div class="small">MSSV: <span class="footer-highlight">24133050</span></div>
                        <div class="small">Mã đề: <span class="badge bg-warning text-dark fw-bold">Đề số 04</span></div>
                    </div>
                </div>
            </div>
            <hr class="border-secondary my-3 opacity-25">
            <div class="text-center small text-secondary">
                © 2026-2027 KT_QT - Servlet + JDBC + JSP + Sitemesh 3 - Sinh viên: Đỗ Thanh Thành Tài (24133050)
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

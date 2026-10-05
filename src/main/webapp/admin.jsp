<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - Quản Trị Hệ Thống (24133050)</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f1f5f9;
            color: #1e293b;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .admin-wrapper {
            display: flex;
            flex: 1 0 auto;
        }
        .admin-sidebar {
            width: 260px;
            background: #0f172a;
            color: #cbd5e1;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            border-right: 1px solid #1e293b;
        }
        .admin-sidebar .sidebar-brand {
            padding: 20px;
            font-size: 1.25rem;
            font-weight: 800;
            color: #ffffff;
            border-bottom: 1px solid #1e293b;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .admin-sidebar .nav-link {
            color: #94a3b8;
            padding: 12px 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        .admin-sidebar .nav-link:hover, .admin-sidebar .nav-link.active {
            color: #ffffff;
            background: #1e293b;
            border-left-color: #3b82f6;
        }
        .admin-main {
            flex: 1 1 auto;
            display: flex;
            flex-direction: column;
            min-width: 0;
        }
        .admin-navbar {
            background: #ffffff;
            padding: 14px 25px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e2e8f0;
        }
        .admin-content {
            padding: 25px;
            flex: 1 0 auto;
        }
        .footer-admin {
            background: #ffffff;
            border-top: 1px solid #e2e8f0;
            padding: 16px 25px;
            color: #64748b;
            font-size: 0.875rem;
        }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>

    <div class="admin-wrapper">
        <aside class="admin-sidebar">
            <div class="sidebar-brand">
                <i class="fa-solid fa-shield-cat text-warning fs-4"></i>
                <span>ADMIN PANEL</span>
            </div>
            
            <div class="p-3">
                <div class="small text-uppercase text-secondary fw-bold px-2 mb-2" style="font-size: 0.7rem; letter-spacing: 1px;">QUẢN LÝ HỆ THỐNG</div>
                <nav class="nav flex-column gap-1">
                    <a class="nav-link rounded" href="${pageContext.request.contextPath}/admin/home">
                        <i class="fa-solid fa-chart-pie"></i> Bảng điều khiển
                    </a>
                    <a class="nav-link rounded" href="${pageContext.request.contextPath}/admin/users">
                        <i class="fa-solid fa-users-gear"></i> Quản lý Người Dùng
                    </a>
                    <a class="nav-link rounded" href="${pageContext.request.contextPath}/category/videos">
                        <i class="fa-solid fa-video"></i> Video theo Danh Mục
                    </a>
                </nav>

                <hr class="border-secondary my-3 opacity-25">
                <div class="small text-uppercase text-secondary fw-bold px-2 mb-2" style="font-size: 0.7rem; letter-spacing: 1px;">ĐIỀU HƯỚNG</div>
                <nav class="nav flex-column gap-1">
                    <a class="nav-link rounded" href="${pageContext.request.contextPath}/home" target="_blank">
                        <i class="fa-solid fa-arrow-up-right-from-square"></i> Xem Website (Client)
                    </a>
                    <a class="nav-link rounded text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất
                    </a>
                </nav>
            </div>

            <div class="mt-auto p-3 border-top border-secondary border-opacity-25 small text-secondary">
                <div>Sinh viên: <strong class="text-white">Đỗ Thanh Thành Tài</strong></div>
                <div>MSSV: <strong class="text-warning">24133050</strong></div>
                <div>Mã đề: <strong class="text-info">Đề số 04</strong></div>
            </div>
        </aside>

        <div class="admin-main">
            <!-- Top Admin Navbar -->
            <header class="admin-navbar">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle fw-semibold px-2 py-1">Khu Vực Quản Trị</span>
                    <span class="text-secondary small d-none d-md-inline">| Bảng Điều Khiển</span>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center fw-bold" style="width: 36px; height: 36px;">
                            ${sessionScope.user.username.substring(0, 1).toUpperCase()}
                        </div>
                        <div class="small text-end d-none d-sm-block">
                            <div class="fw-bold">${sessionScope.user.fullname != null ? sessionScope.user.fullname : sessionScope.user.username}</div>
                            <div class="text-muted" style="font-size: 0.75rem;">Administrator</div>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-danger" title="Đăng xuất">
                        <i class="fa-solid fa-power-off"></i>
                    </a>
                </div>
            </header>

            <!-- Admin Body Content -->
            <main class="admin-content">
                <sitemesh:write property='body'/>
            </main>

            <!-- Admin Footer (Câu 1) -->
            <footer class="footer-admin d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
                <div>
                    <strong>Hệ Thống Quản Trị Trực Tuyến</strong>
                </div>
                <div>
                    Thông tin sinh viên: <strong class="text-primary">Đỗ Thanh Thành Tài</strong> | MSSV: <strong class="text-danger">24133050</strong> | Mã đề: <span class="badge bg-warning text-dark">Đề số 04</span>
                </div>
            </footer>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

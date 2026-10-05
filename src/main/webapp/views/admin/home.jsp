<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Bảng Điều Khiển Quản Trị - KT_QT 24133050</title>
</head>
<body>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold text-dark m-0">
                <i class="fa-solid fa-gauge text-primary me-2"></i>Bảng Điều Khiển Quản Trị
            </h3>
            <p class="text-secondary small m-0">Hệ thống quản trị và giám sát dữ liệu trực tuyến</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/user/add" class="btn btn-primary fw-semibold shadow-sm">
            <i class="fa-solid fa-user-plus me-1"></i> Thêm Người Dùng Mới
        </a>
    </div>

    <!-- Hàng thống kê tổng quan -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-secondary small fw-bold text-uppercase">Tổng Người Dùng</div>
                        <div class="fs-2 fw-bold text-primary mt-1">${totalUsers}</div>
                    </div>
                    <div class="rounded-circle bg-primary-subtle text-primary p-3 fs-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                        <i class="fa-solid fa-users"></i>
                    </div>
                </div>
                <div class="mt-2 pt-2 border-top">
                    <a href="${pageContext.request.contextPath}/admin/users" class="small text-decoration-none fw-semibold">
                        Quản lý bảng Users & phân trang <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-secondary small fw-bold text-uppercase">Danh Mục Video</div>
                        <div class="fs-2 fw-bold text-success mt-1">${totalCategories}</div>
                    </div>
                    <div class="rounded-circle bg-success-subtle text-success p-3 fs-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                        <i class="fa-solid fa-layer-group"></i>
                    </div>
                </div>
                <div class="mt-2 pt-2 border-top">
                    <a href="${pageContext.request.contextPath}/category/videos" class="small text-decoration-none fw-semibold text-success">
                        Xem video theo danh mục <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-secondary small fw-bold text-uppercase">Tổng Số Video</div>
                        <div class="fs-2 fw-bold text-danger mt-1">${totalVideos}</div>
                    </div>
                    <div class="rounded-circle bg-danger-subtle text-danger p-3 fs-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                        <i class="fa-solid fa-film"></i>
                    </div>
                </div>
                <div class="mt-2 pt-2 border-top">
                    <a href="${pageContext.request.contextPath}/category/videos" class="small text-decoration-none fw-semibold text-danger">
                        Xem danh sách video <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

</body>
</html>

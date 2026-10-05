<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thêm Người Dùng Mới - Quản Trị</title>
</head>
<body>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold text-dark m-0">
                    <i class="fa-solid fa-user-plus text-primary me-2"></i>Thêm Người Dùng Mới
                </h3>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách
                </a>
            </div>

            <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 mb-4" role="alert">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <div>${error}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/user/add" method="post">
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="username" class="form-label fw-semibold">Tên đăng nhập (Username) <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="username" name="username" placeholder="Nhập username" required autofocus>
                        </div>
                        <div class="col-md-6">
                            <label for="password" class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="fullname" class="form-label fw-semibold">Họ và tên</label>
                            <input type="text" class="form-control" id="fullname" name="fullname" placeholder="Nguyễn Văn A">
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label fw-semibold">Địa chỉ Email</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="example@gmail.com">
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="phone" class="form-label fw-semibold">Số điện thoại</label>
                            <input type="text" class="form-control" id="phone" name="phone" placeholder="09xxxxxxxx">
                        </div>
                        <div class="col-md-6">
                            <label for="images" class="form-label fw-semibold">Tên file ảnh đại diện</label>
                            <input type="text" class="form-control" id="images" name="images" value="default-avatar.png" placeholder="default-avatar.png">
                        </div>
                    </div>

                    <div class="row g-3 mb-4 p-3 bg-light rounded-3 border">
                        <div class="col-md-6">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" id="admin" name="admin" value="true">
                                <label class="form-check-label fw-semibold text-danger" for="admin">
                                    <i class="fa-solid fa-shield-halved me-1"></i> Quyền Quản Trị (Admin)
                                </label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" id="active" name="active" value="true" checked>
                                <label class="form-check-label fw-semibold text-success" for="active">
                                    <i class="fa-solid fa-circle-check me-1"></i> Kích hoạt hoạt động (Active)
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary px-4">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary px-4 fw-semibold shadow-sm">
                            <i class="fa-solid fa-floppy-disk me-1"></i> Lưu Người Dùng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</body>
</html>

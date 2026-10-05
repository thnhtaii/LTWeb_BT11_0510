<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Chỉnh Sửa Người Dùng - Quản Trị</title>
</head>
<body>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold text-dark m-0">
                    <i class="fa-solid fa-user-pen text-warning me-2"></i>Chỉnh Sửa Người Dùng
                </h3>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách
                </a>
            </div>

            <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                <form action="${pageContext.request.contextPath}/admin/user/edit" method="post">
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="username" class="form-label fw-semibold">Tên đăng nhập (Username)</label>
                            <input type="text" class="form-control bg-light" id="username" name="username" value="${userItem.username}" readonly>
                            <div class="form-text">Khóa chính (Username) không thể thay đổi.</div>
                        </div>
                        <div class="col-md-6">
                            <label for="password" class="form-label fw-semibold">Đổi mật khẩu mới</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Để trống nếu không đổi">
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="fullname" class="form-label fw-semibold">Họ và tên</label>
                            <input type="text" class="form-control" id="fullname" name="fullname" value="${userItem.fullname}" placeholder="Họ và tên">
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label fw-semibold">Địa chỉ Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="${userItem.email}" placeholder="example@gmail.com">
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="phone" class="form-label fw-semibold">Số điện thoại</label>
                            <input type="text" class="form-control" id="phone" name="phone" value="${userItem.phone}" placeholder="Số điện thoại">
                        </div>
                        <div class="col-md-6">
                            <label for="images" class="form-label fw-semibold">Tên file ảnh đại diện</label>
                            <input type="text" class="form-control" id="images" name="images" value="${userItem.images}">
                        </div>
                    </div>

                    <div class="row g-3 mb-4 p-3 bg-light rounded-3 border">
                        <div class="col-md-6">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" id="admin" name="admin" value="true" ${userItem.admin ? 'checked' : ''}>
                                <label class="form-check-label fw-semibold text-danger" for="admin">
                                    <i class="fa-solid fa-shield-halved me-1"></i> Quyền Quản Trị (Admin)
                                </label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" id="active" name="active" value="true" ${userItem.active ? 'checked' : ''}>
                                <label class="form-check-label fw-semibold text-success" for="active">
                                    <i class="fa-solid fa-circle-check me-1"></i> Kích hoạt hoạt động (Active)
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary px-4">Hủy bỏ</a>
                        <button type="submit" class="btn btn-warning px-4 fw-semibold shadow-sm">
                            <i class="fa-solid fa-check me-1"></i> Cập Nhật Người Dùng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</body>
</html>

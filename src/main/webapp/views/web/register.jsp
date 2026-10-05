<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng Ký Tài Khoản - KT_QT 24133050</title>
</head>
<body>

    <div class="row justify-content-center my-4">
        <div class="col-md-7 col-lg-6">
            <div class="card border-0 shadow rounded-4 overflow-hidden">
                <div class="card-header bg-gradient bg-primary text-white text-center py-4">
                    <i class="fa-solid fa-user-plus fs-1 mb-2"></i>
                    <h4 class="fw-bold mb-0">ĐĂNG KÝ TÀI KHOẢN</h4>
                    <p class="small mb-0 opacity-75">Kích hoạt tài khoản bằng mã OTP qua Email</p>
                </div>

                <div class="card-body p-4 p-md-5">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2" role="alert">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            <div>${error}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-user text-secondary"></i></span>
                                <input type="text" class="form-control" id="username" name="username" value="${username}" placeholder="Nhập tên đăng nhập" required autofocus>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="password" class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-secondary"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Tối thiểu 6 ký tự" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="repassword" class="form-label fw-semibold">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-key text-secondary"></i></span>
                                    <input type="password" class="form-control" id="repassword" name="repassword" placeholder="Nhập lại mật khẩu" required>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="fullname" class="form-label fw-semibold">Họ và tên</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-id-card text-secondary"></i></span>
                                <input type="text" class="form-control" id="fullname" name="fullname" value="${fullname}" placeholder="Ví dụ: Nguyễn Văn A">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold">Email nhận mã OTP <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-envelope text-secondary"></i></span>
                                <input type="email" class="form-control" id="email" name="email" value="${email}" placeholder="example@gmail.com" required>
                            </div>
                            <div class="form-text text-muted">Mã OTP 6 chữ số sẽ được gửi tới email này để kích hoạt.</div>
                        </div>

                        <div class="mb-4">
                            <label for="phone" class="form-label fw-semibold">Số điện thoại</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-phone text-secondary"></i></span>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${phone}" placeholder="09xxxxxxxx">
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">
                            <i class="fa-solid fa-paper-plane me-2"></i> Tiếp Tục & Nhận Mã OTP
                        </button>
                    </form>

                    <div class="mt-4 text-center">
                        <span class="text-muted">Đã có tài khoản? </span>
                        <a href="${pageContext.request.contextPath}/login" class="fw-bold text-decoration-none">
                            Đăng nhập ngay
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>

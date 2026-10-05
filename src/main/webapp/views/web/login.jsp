<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng Nhập - KT_QT 24133050</title>
</head>
<body>

    <div class="row justify-content-center my-4">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow rounded-4 overflow-hidden">
                <div class="card-header bg-primary text-white text-center py-4">
                    <i class="fa-solid fa-circle-user fs-1 mb-2"></i>
                    <h4 class="fw-bold mb-0">ĐĂNG NHẬP HỆ THỐNG</h4>
                    <p class="small mb-0 opacity-75">Hệ thống xác thực tài khoản an toàn</p>
                </div>
                
                <div class="card-body p-4 p-md-5">
                    <!-- Thông báo lỗi nếu có -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2" role="alert">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            <div>${error}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Thông báo thành công -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2" role="alert">
                            <i class="fa-solid fa-circle-check"></i>
                            <div>${success}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold">Tên đăng nhập hoặc Email</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-user text-secondary"></i></span>
                                <input type="text" class="form-control" id="username" name="username" value="${username}" placeholder="Nhập username hoặc email" required autofocus>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label fw-semibold">Mật khẩu</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-secondary"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">
                            <i class="fa-solid fa-right-to-bracket me-2"></i> Đăng Nhập
                        </button>
                    </form>

                    <div class="mt-4 text-center">
                        <p class="text-muted mb-1">Chưa có tài khoản?</p>
                        <a href="${pageContext.request.contextPath}/register" class="fw-bold text-decoration-none">
                            <i class="fa-solid fa-user-plus me-1"></i> Đăng ký tài khoản mới (Xác thực OTP)
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>

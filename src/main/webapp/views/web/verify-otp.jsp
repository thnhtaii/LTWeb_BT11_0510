<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Xác Thực Mã OTP - KT_QT 24133050</title>
</head>
<body>

    <div class="row justify-content-center my-4">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow rounded-4 overflow-hidden">
                <div class="card-header bg-gradient bg-danger text-white text-center py-4">
                    <i class="fa-solid fa-shield-halved fs-1 mb-2"></i>
                    <h4 class="fw-bold mb-0">XÁC THỰC MÃ OTP</h4>
                    <p class="small mb-0 opacity-75">Kích hoạt tài khoản người dùng</p>
                </div>

                <div class="card-body p-4 p-md-5 text-center">
                    <p class="text-secondary mb-3">
                        Một mã OTP gồm 6 chữ số đã được gửi đến email:<br>
                        <strong class="text-dark fs-6">${sessionScope.pendingUser.email}</strong>
                    </p>

                    <c:if test="${not empty info}">
                        <div class="alert alert-info alert-dismissible fade show text-start small mb-3" role="alert">
                            <i class="fa-solid fa-circle-info me-1"></i> ${info}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show text-start small mb-3" role="alert">
                            <i class="fa-solid fa-triangle-exclamation me-1"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/verify-otp" method="post">
                        <div class="mb-4">
                            <label for="otp" class="form-label fw-bold">Nhập 6 chữ số OTP</label>
                            <input type="text" class="form-control text-center fs-3 fw-bold letter-spacing-lg py-2" 
                                   id="otp" name="otp" maxlength="6" placeholder="------" 
                                   style="letter-spacing: 10px;" required autofocus>
                        </div>

                        <button type="submit" class="btn btn-danger w-100 py-2 fw-bold shadow-sm mb-3">
                            <i class="fa-solid fa-check me-2"></i> Kích Hoạt Tài Khoản
                        </button>
                    </form>

                    <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top small">
                        <a href="${pageContext.request.contextPath}/verify-otp?action=resend" class="text-decoration-none fw-semibold">
                            <i class="fa-solid fa-rotate-right me-1"></i> Gửi lại mã OTP
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="text-decoration-none text-muted">
                            <i class="fa-solid fa-arrow-left me-1"></i> Đăng ký lại
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thanh Toán COD</title>
</head>
<body>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold text-primary mb-1">
                <i class="fa-solid fa-money-bill-wave me-2"></i>Thanh toán đơn hàng bằng COD
            </h3>
            <div class="text-muted">Đơn hàng sẽ được tạo với trạng thái ban đầu là “Đơn hàng mới”.</div>
        </div>
        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary">
            <i class="fa-solid fa-arrow-left me-1"></i> Quay lại giỏ hàng
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="row g-4">
        <div class="col-lg-7">
            <form action="${pageContext.request.contextPath}/checkout" method="post" class="bg-white border rounded-3 shadow-sm p-4">
                <h5 class="fw-bold mb-3">Thông tin nhận hàng</h5>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Họ tên người nhận</label>
                    <input class="form-control" name="receiverName" value="${sessionScope.user.fullname}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Số điện thoại</label>
                    <input class="form-control" name="receiverPhone" value="${sessionScope.user.phone}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Địa chỉ nhận hàng</label>
                    <textarea class="form-control" name="receiverAddress" rows="3" required></textarea>
                </div>
                <div class="mb-4">
                    <label class="form-label fw-semibold">Ghi chú</label>
                    <textarea class="form-control" name="note" rows="2"></textarea>
                </div>
                <div class="alert alert-info d-flex gap-2">
                    <i class="fa-solid fa-circle-info mt-1"></i>
                    <div>Phương thức thanh toán: <strong>COD - thanh toán khi nhận hàng</strong>.</div>
                </div>
                <button class="btn btn-success btn-lg fw-bold" type="submit">
                    <i class="fa-solid fa-check me-1"></i> Xác nhận đặt hàng COD
                </button>
            </form>
        </div>

        <div class="col-lg-5">
            <div class="bg-white border rounded-3 shadow-sm p-4">
                <h5 class="fw-bold mb-3">Sản phẩm đặt mua</h5>
                <c:forEach var="item" items="${cartItems}">
                    <div class="d-flex justify-content-between align-items-start border-bottom py-3">
                        <div>
                            <div class="fw-semibold"><c:out value="${item.title}"/></div>
                            <div class="small text-muted">${item.videoId} x ${item.quantity}</div>
                        </div>
                        <div class="fw-bold text-primary text-end">
                            <fmt:formatNumber value="${item.lineTotal}" type="number" groupingUsed="true"/> đ
                        </div>
                    </div>
                </c:forEach>
                <div class="d-flex justify-content-between fs-5 fw-bold text-primary pt-3">
                    <span>Tổng COD</span>
                    <span><fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/> đ</span>
                </div>
            </div>
        </div>
    </div>

</body>
</html>

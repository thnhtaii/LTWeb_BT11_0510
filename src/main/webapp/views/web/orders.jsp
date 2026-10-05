<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>Lịch Sử Đặt Hàng</title>
    <style>
        .status-filter {
            border-radius: 30px;
            padding: 8px 14px;
            font-weight: 600;
            text-decoration: none;
        }
        .order-thumb {
            width: 76px;
            height: 48px;
            object-fit: cover;
            border-radius: 6px;
            background: #0f172a;
        }
    </style>
</head>
<body>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold text-primary mb-1">
                <i class="fa-solid fa-clock-rotate-left me-2"></i>Lịch sử đặt hàng
            </h3>
            <div class="text-muted">Lọc đơn hàng theo trạng thái để quan sát quá trình xử lý.</div>
        </div>
        <a href="${pageContext.request.contextPath}/category/videos" class="btn btn-outline-primary">
            <i class="fa-solid fa-cart-plus me-1"></i> Đặt thêm video
        </a>
    </div>

    <c:if test="${param.message == 'checkout_success'}">
        <div class="alert alert-success">
            Đặt hàng COD thành công. Mã đơn hàng mới: <strong>#${param.orderId}</strong>.
        </div>
    </c:if>

    <div class="d-flex flex-wrap gap-2 mb-4">
        <a class="status-filter border ${empty selectedStatus ? 'bg-primary text-white' : 'bg-white text-dark'}" href="${pageContext.request.contextPath}/orders">
            Tất cả
        </a>
        <c:forEach var="entry" items="${statusLabels}">
            <a class="status-filter border ${selectedStatus == entry.key ? 'bg-primary text-white' : 'bg-white text-dark'}"
               href="${pageContext.request.contextPath}/orders?status=${entry.key}">
                ${entry.value}
            </a>
        </c:forEach>
    </div>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="bg-white border rounded-3 shadow-sm text-center py-5">
                <i class="fa-solid fa-receipt text-secondary fs-1 mb-3"></i>
                <h5 class="fw-bold">Không có đơn hàng phù hợp</h5>
                <p class="text-muted mb-0">Bạn có thể đổi bộ lọc trạng thái hoặc tạo đơn COD mới.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-flex flex-column gap-3">
                <c:forEach var="order" items="${orders}">
                    <div class="bg-white border rounded-3 shadow-sm p-4">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 border-bottom pb-3 mb-3">
                            <div>
                                <h5 class="fw-bold mb-1">Đơn hàng #${order.orderId}</h5>
                                <div class="small text-muted">
                                    Người nhận: ${order.receiverName} - ${order.receiverPhone}
                                </div>
                                <div class="small text-muted">Địa chỉ: ${order.receiverAddress}</div>
                            </div>
                            <div class="text-end">
                                <div class="badge bg-primary-subtle text-primary border border-primary-subtle fs-6 mb-2">
                                    ${order.statusLabel}
                                </div>
                                <div class="fw-bold text-success">Thanh toán: ${order.paymentMethod}</div>
                                <div class="small text-muted">
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </div>

                        <c:forEach var="item" items="${order.items}">
                            <div class="d-flex align-items-center justify-content-between py-2">
                                <div class="d-flex align-items-center gap-3">
                                    <img class="order-thumb" src="${pageContext.request.contextPath}/image?fname=${item.poster}" alt="<c:out value='${item.title}'/>">
                                    <div>
                                        <div class="fw-semibold"><c:out value="${item.title}"/></div>
                                        <div class="small text-muted">${item.videoId} x ${item.quantity}</div>
                                    </div>
                                </div>
                                <div class="fw-semibold text-end">
                                    <fmt:formatNumber value="${item.lineTotal}" type="number" groupingUsed="true"/> đ
                                </div>
                            </div>
                        </c:forEach>

                        <div class="d-flex justify-content-end border-top mt-3 pt-3">
                            <div class="fs-5 fw-bold text-primary">
                                Tổng tiền: <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> đ
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</body>
</html>

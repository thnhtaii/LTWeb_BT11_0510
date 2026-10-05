<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>Giỏ Hàng</title>
    <style>
        .cart-thumb {
            width: 110px;
            height: 70px;
            object-fit: cover;
            border-radius: 8px;
            background: #0f172a;
        }
        .qty-input {
            width: 84px;
        }
    </style>
</head>
<body>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold text-primary mb-1">
                <i class="fa-solid fa-cart-shopping me-2"></i>Giỏ hàng của bạn
            </h3>
            <div class="text-muted">Số lượng mỗi video được giới hạn từ 1 đến ${maxQuantity}.</div>
        </div>
        <a href="${pageContext.request.contextPath}/category/videos" class="btn btn-outline-primary">
            <i class="fa-solid fa-plus me-1"></i> Tiếp tục chọn video
        </a>
    </div>

    <c:if test="${param.message == 'add_success'}">
        <div class="alert alert-success">Đã thêm video vào giỏ hàng.</div>
    </c:if>
    <c:if test="${param.message == 'update_success'}">
        <div class="alert alert-success">Đã cập nhật số lượng.</div>
    </c:if>
    <c:if test="${param.message == 'remove_success'}">
        <div class="alert alert-success">Đã xóa sản phẩm khỏi giỏ hàng.</div>
    </c:if>
    <c:if test="${param.message == 'clear_success'}">
        <div class="alert alert-success">Đã xóa toàn bộ giỏ hàng.</div>
    </c:if>
    <c:if test="${param.message == 'empty_cart'}">
        <div class="alert alert-warning">Giỏ hàng đang trống, vui lòng chọn video trước khi thanh toán.</div>
    </c:if>

    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="text-center bg-white border rounded-3 py-5 shadow-sm">
                <i class="fa-solid fa-cart-shopping text-secondary fs-1 mb-3"></i>
                <h5 class="fw-bold">Chưa có sản phẩm trong giỏ hàng</h5>
                <p class="text-muted mb-4">Hãy thêm video bạn muốn đặt mua rồi quay lại thanh toán COD.</p>
                <a href="${pageContext.request.contextPath}/category/videos" class="btn btn-primary fw-semibold">
                    Xem danh sách video
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="table-responsive bg-white rounded-3 border shadow-sm">
                        <table class="table align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Video</th>
                                    <th class="text-end">Đơn giá</th>
                                    <th class="text-center">Số lượng</th>
                                    <th class="text-end">Thành tiền</th>
                                    <th class="text-center">Xóa</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${cartItems}">
                                    <tr>
                                        <td>
                                            <div class="d-flex gap-3 align-items-center">
                                                <img class="cart-thumb" src="${pageContext.request.contextPath}/image?fname=${item.poster}" alt="${item.title}">
                                                <div>
                                                    <a class="fw-bold text-decoration-none" href="${pageContext.request.contextPath}/video/detail?id=${item.videoId}">
                                                        ${item.title}
                                                    </a>
                                                    <div class="small text-muted">Mã video: ${item.videoId}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-end fw-semibold">
                                            <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> đ
                                        </td>
                                        <td class="text-center">
                                            <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-inline-flex gap-2 justify-content-center">
                                                <input type="hidden" name="videoId" value="${item.videoId}">
                                                <input class="form-control qty-input text-center" type="number" name="quantity" value="${item.quantity}" min="1" max="${maxQuantity}" required aria-label="Số lượng video">
                                                <button class="btn btn-sm btn-outline-primary" type="submit" title="Cập nhật số lượng" aria-label="Cập nhật số lượng">
                                                    <i class="fa-solid fa-rotate"></i>
                                                </button>
                                            </form>
                                        </td>
                                        <td class="text-end fw-bold text-primary">
                                            <fmt:formatNumber value="${item.lineTotal}" type="number" groupingUsed="true"/> đ
                                        </td>
                                        <td class="text-center">
                                            <a class="btn btn-sm btn-outline-danger" href="${pageContext.request.contextPath}/cart/remove?videoId=${item.videoId}" title="Xóa video khỏi giỏ" aria-label="Xóa video khỏi giỏ">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="mt-3">
                        <a class="btn btn-outline-danger" href="${pageContext.request.contextPath}/cart/clear">
                            <i class="fa-solid fa-trash-can me-1"></i> Xóa toàn bộ giỏ hàng
                        </a>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="bg-white border rounded-3 shadow-sm p-4">
                        <h5 class="fw-bold mb-3">Tổng đơn hàng</h5>
                        <div class="d-flex justify-content-between border-bottom pb-3 mb-3">
                            <span class="text-muted">Tạm tính</span>
                            <span class="fw-bold"><fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/> đ</span>
                        </div>
                        <div class="d-flex justify-content-between fs-5 fw-bold text-primary mb-4">
                            <span>Tổng cộng</span>
                            <span><fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/> đ</span>
                        </div>
                        <a class="btn btn-success w-100 fw-bold" href="${pageContext.request.contextPath}/checkout">
                            <i class="fa-solid fa-money-bill-wave me-1"></i> Thanh toán COD
                        </a>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

</body>
</html>

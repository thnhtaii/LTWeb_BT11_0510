<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>Trang Chủ - Video Portal</title>
</head>
<body>

    <c:if test="${param.cart == 'added'}">
        <div class="alert alert-success">
            Đã thêm video vào giỏ hàng. <a href="${pageContext.request.contextPath}/cart" class="alert-link">Xem giỏ hàng</a>
        </div>
    </c:if>

    <!-- Hero Banner -->
    <div class="p-5 mb-4 rounded-4 shadow-sm text-white" style="background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);">
        <div class="container-fluid py-3">
            <h1 class="display-5 fw-bold mb-3">Chào mừng đến với Cổng Video Trực Tuyến</h1>
            <p class="col-md-9 fs-5 text-light opacity-90">
                Hệ thống xem video, chia sẻ và tương tác trực tuyến xây dựng theo mô hình 3 lớp 
                (Presentation - Business - Data Access Layer) sử dụng Servlet + JDBC + JSP.
            </p>
            <div class="d-flex gap-3 mt-4">
                <a class="btn btn-warning btn-lg fw-bold text-dark px-4 shadow-sm" href="${pageContext.request.contextPath}/category/videos">
                    <i class="fa-solid fa-play me-2"></i> Khám Phá Video
                </a>
                <c:if test="${sessionScope.user == null}">
                    <a class="btn btn-outline-light btn-lg px-4" href="${pageContext.request.contextPath}/register">
                        <i class="fa-solid fa-user-plus me-2"></i> Đăng Ký Tài Khoản
                    </a>
                </c:if>
                <c:if test="${sessionScope.user != null && sessionScope.user.admin}">
                    <a class="btn btn-dark btn-lg px-4" href="${pageContext.request.contextPath}/admin/users">
                        <i class="fa-solid fa-users-gear me-2"></i> Quản Lý Người Dùng
                    </a>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Danh Sách Thể Loại (Categories) -->
    <div class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0 text-primary">
                <i class="fa-solid fa-layer-group me-2"></i> Danh Mục Video
            </h3>
            <a href="${pageContext.request.contextPath}/category/videos" class="text-decoration-none fw-semibold">
                Xem tất cả <i class="fa-solid fa-arrow-right ms-1"></i>
            </a>
        </div>
        <div class="row g-3">
            <c:forEach var="cat" items="${categories}">
                <div class="col-6 col-md-3">
                    <a href="${pageContext.request.contextPath}/category/videos?categoryId=${cat.categoryId}" class="text-decoration-none">
                        <div class="card h-100 border-0 shadow-sm rounded-3 hover-card" style="transition: transform 0.2s; background: #ffffff;">
                            <div class="card-body text-center py-4">
                                <div class="rounded-circle bg-primary-subtle text-primary mx-auto mb-3 d-flex align-items-center justify-content-center" style="width: 56px; height: 56px;">
                                    <i class="fa-solid fa-film fs-4"></i>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">${cat.categoryname}</h6>
                                <span class="badge bg-secondary-subtle text-secondary border">
                                    ${cat.videoCount} video
                                </span>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Video Nổi Bật -->
    <div class="mb-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0 text-primary">
                <i class="fa-solid fa-fire me-2 text-danger"></i> Video Nổi Bật
            </h3>
        </div>
        <div class="row g-4">
            <c:forEach var="v" items="${topVideos}">
                <div class="col-md-4">
                    <div class="card h-100 border-0 shadow-sm rounded-3 overflow-hidden">
                        <div class="position-relative">
                            <img src="${pageContext.request.contextPath}/image?fname=${v.poster}" class="card-img-top" alt="<c:out value='${v.title}'/>" style="height: 190px; object-fit: cover;">
                            <span class="position-absolute top-0 end-0 bg-dark bg-opacity-75 text-white badge m-2">
                                <i class="fa-solid fa-eye me-1"></i> ${v.views} views
                            </span>
                        </div>
                        <div class="card-body d-flex flex-direction-column justify-content-between">
                            <div>
                                <div class="badge bg-primary-subtle text-primary mb-2">${v.categoryName}</div>
                                <h6 class="card-title fw-bold text-truncate" title="<c:out value='${v.title}'/>"><c:out value="${v.title}"/></h6>
                                <p class="card-text text-muted small text-truncate-2" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    <c:out value="${v.description}"/>
                                </p>
                                <div class="fw-bold text-danger">
                                    <fmt:formatNumber value="${v.price}" type="number" groupingUsed="true"/> đ
                                </div>
                            </div>
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-2 gap-2">
                                <div class="small text-muted">
                                    <span class="me-2 text-danger"><i class="fa-solid fa-heart me-1"></i>${v.likeCount}</span>
                                    <span class="text-primary"><i class="fa-solid fa-share me-1"></i>${v.shareCount}</span>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="btn btn-sm btn-outline-primary fw-semibold">
                                        Chi tiết
                                    </a>
                                    <form action="${pageContext.request.contextPath}/cart/add" method="post">
                                        <input type="hidden" name="videoId" value="${v.videoId}">
                                        <input type="hidden" name="quantity" value="1">
                                        <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/home">
                                        <button class="btn btn-sm btn-success fw-semibold" type="submit">
                                            <i class="fa-solid fa-cart-plus"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

</body>
</html>

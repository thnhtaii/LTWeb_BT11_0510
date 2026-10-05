<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>${currentCategory.categoryname} - Video Theo Thể Loại</title>
    <style>
        .category-header-title {
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
            color: #ffffff;
            padding: 16px 24px;
            border-radius: 10px;
            margin-bottom: 24px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .video-card-exam {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            background: #ffffff;
            transition: all 0.25s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
            overflow: hidden;
        }
        .video-card-exam:hover {
            border-color: #3b82f6;
            box-shadow: 0 10px 15px -3px rgba(59, 130, 246, 0.15);
            transform: translateY(-3px);
        }
        .video-card-exam .poster-wrap {
            height: 200px;
            background-color: #0f172a;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .video-card-exam .poster-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .video-card-exam:hover .poster-wrap img {
            transform: scale(1.05);
        }
        .video-card-exam .card-body {
            padding: 18px;
            font-size: 0.95rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-grow: 1;
        }
        .video-label {
            font-weight: 700;
            color: #475569;
            margin-right: 6px;
        }
        .video-info-row {
            margin-bottom: 8px;
        }
        .stat-group {
            display: flex;
            gap: 12px;
            padding-top: 10px;
            border-top: 1px dashed #cbd5e1;
            margin-top: 10px;
        }
        .category-tab-btn {
            font-weight: 600;
            padding: 10px 18px;
            border-radius: 30px;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .category-tab-btn.active {
            background-color: #2563eb !important;
            color: #ffffff !important;
            box-shadow: 0 4px 6px rgba(37, 99, 235, 0.25);
        }
    </style>
</head>
<body>

    <!-- Danh sách tabs chọn Thể loại (Category) -->
    <c:if test="${param.cart == 'added'}">
        <div class="alert alert-success">
            Đã thêm video vào giỏ hàng. <a href="${pageContext.request.contextPath}/cart" class="alert-link">Xem giỏ hàng</a>
        </div>
    </c:if>

    <!-- Danh sách tabs chọn Thể loại (Category) -->
    <div class="mb-4">
        <div class="d-flex flex-wrap gap-2 align-items-center">
            <span class="fw-bold text-secondary me-2"><i class="fa-solid fa-filter me-1"></i>Chọn Thể Loại:</span>
            <c:forEach var="cat" items="${categories}">
                <!-- Câu 6: Đếm số lượng Video theo từng Category: Category Name (Số lượng) -->
                <a href="${pageContext.request.contextPath}/category/videos?categoryId=${cat.categoryId}" 
                   class="category-tab-btn border ${cat.categoryId == selectedCategoryId ? 'active' : 'bg-white text-dark'}">
                    <span>${cat.categoryname}</span>
                    <span class="badge ${cat.categoryId == selectedCategoryId ? 'bg-light text-primary' : 'bg-primary-subtle text-primary'} rounded-pill">
                        ${cat.videoCount}
                    </span>
                </a>
            </c:forEach>
        </div>
    </div>

    <!-- TIÊU ĐỀ THEO ĐÚNG MẪU ĐỀ THI: Category Name (20) (Câu 5 & 6) -->
    <div class="category-header-title d-flex justify-content-between align-items-center">
        <h3 class="fw-bold m-0 d-flex align-items-center gap-2">
            <i class="fa-solid fa-clapperboard text-warning"></i>
            <span>${currentCategory.categoryname} (${currentCategory.videoCount})</span>
        </h3>
        <span class="badge bg-white text-primary fs-6 fw-bold">
            Trang ${currentPage} / ${totalPages} (3 video/trang)
        </span>
    </div>

    <!-- KHUNG HIỂN THỊ 3 VIDEO TRÊN 1 TRANG (CÂU 5) -->
    <c:choose>
        <c:when test="${empty videoList}">
            <div class="alert alert-info text-center py-5 rounded-4">
                <i class="fa-solid fa-circle-exclamation fs-2 mb-2 d-block text-secondary"></i>
                <h5>Chưa có video nào trong danh mục này!</h5>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4 mb-4">
                <c:forEach var="v" items="${videoList}">
                    <div class="col-md-4">
                        <div class="video-card-exam shadow-sm">
                            <!-- [poster] -->
                            <div class="poster-wrap">
                                <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="w-100 h-100">
                                    <img src="${pageContext.request.contextPath}/image?fname=${v.poster}" alt="${v.title}">
                                </a>
                            </div>

                            <!-- Thông tin theo mẫu đề thi -->
                            <div class="card-body">
                                <div>
                                    <!-- Tiêu đề: -->
                                    <div class="video-info-row">
                                        <span class="video-label">Tiêu đề:</span>
                                        <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" 
                                           class="fw-bold text-primary text-decoration-none" title="${v.title}">
                                            ${v.title}
                                        </a>
                                    </div>

                                    <!-- Mã video: -->
                                    <div class="video-info-row">
                                        <span class="video-label">Mã video:</span>
                                        <span class="badge bg-secondary">${v.videoId}</span>
                                    </div>

                                    <!-- Category name: -->
                                    <div class="video-info-row">
                                        <span class="video-label">Category name:</span>
                                        <span class="text-dark fw-semibold">${v.categoryName}</span>
                                    </div>

                                    <!-- View: -->
                                    <div class="video-info-row">
                                        <span class="video-label">View:</span>
                                        <span class="text-success fw-bold">${v.views}</span>
                                    </div>

                                    <div class="video-info-row">
                                        <span class="video-label">Giá:</span>
                                        <span class="text-danger fw-bold">
                                            <fmt:formatNumber value="${v.price}" type="number" groupingUsed="true"/> đ
                                        </span>
                                    </div>
                                </div>

                                <!-- Share(10) & Like(10) -->
                                <div class="stat-group">
                                    <div class="text-primary fw-semibold small">
                                        <i class="fa-solid fa-share me-1"></i>Share(${v.shareCount})
                                    </div>
                                    <div class="text-danger fw-semibold small">
                                        <i class="fa-solid fa-heart me-1"></i>Like(${v.likeCount})
                                    </div>
                                </div>
                                <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-flex gap-2 mt-3">
                                    <input type="hidden" name="videoId" value="${v.videoId}">
                                    <input type="hidden" name="quantity" value="1">
                                    <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/category/videos?categoryId=${selectedCategoryId}&page=${currentPage}">
                                    <button class="btn btn-sm btn-success w-100 fw-semibold" type="submit">
                                        <i class="fa-solid fa-cart-plus me-1"></i> Thêm vào giỏ
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- PHÂN TRANG THEO MẪU: << 1 2 3 4 5 >> (Câu 5) -->
            <nav aria-label="Page navigation" class="mt-4 mb-5">
                <ul class="pagination pagination-lg justify-content-center">
                    <!-- Nút << (Trang đầu hoặc trang trước) -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/category/videos?categoryId=${selectedCategoryId}&page=${currentPage - 1}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>

                    <!-- Các số trang 1 2 3 4 5 -->
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/category/videos?categoryId=${selectedCategoryId}&page=${i}">
                                ${i}
                            </a>
                        </li>
                    </c:forEach>

                    <!-- Nút >> (Trang kế tiếp) -->
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/category/videos?categoryId=${selectedCategoryId}&page=${currentPage + 1}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>

</body>
</html>

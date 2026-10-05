<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title><c:out value="${video.title}"/> - Chi Tiết Video</title>
    <style>
        .video-detail-box {
            background-color: #ffffff;
            border: 2px solid #cbd5e1;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        .poster-container {
            width: 100%;
            max-width: 320px;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
            background-color: #0f172a;
        }
        .poster-container img {
            width: 100%;
            height: auto;
            display: block;
            object-fit: cover;
        }
        .info-label {
            font-weight: 700;
            color: #334155;
            min-width: 130px;
            display: inline-block;
        }
        .info-value {
            color: #0f172a;
            font-size: 1.05rem;
        }
        .desc-box {
            background-color: #f8fafc;
            border-left: 4px solid #3b82f6;
            padding: 16px 20px;
            border-radius: 0 8px 8px 0;
            margin-top: 24px;
            font-size: 1rem;
            line-height: 1.6;
            color: #334155;
        }
        .stat-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>

    <!-- Breadcrumb điều hướng -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-decoration-none">Trang Chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/category/videos?categoryId=${video.categoryId}" class="text-decoration-none">${video.categoryName}</a></li>
            <li class="breadcrumb-item active" aria-current="page"><c:out value="${video.title}"/></li>
        </ol>
    </nav>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <c:if test="${param.cart == 'added'}">
                <div class="alert alert-success">
                    Đã thêm video vào giỏ hàng. <a href="${pageContext.request.contextPath}/cart" class="alert-link">Xem giỏ hàng</a>
                </div>
            </c:if>
            <!-- Tiêu đề phần thi -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="fw-bold text-primary m-0">
                    <i class="fa-solid fa-circle-play me-2"></i>Chi Tiết Video
                </h4>
                <a href="${pageContext.request.contextPath}/category/videos?categoryId=${video.categoryId}" class="btn btn-sm btn-outline-secondary">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh mục
                </a>
            </div>

            <!-- Khung thông tin mẫu theo đúng định dạng trong đề thi -->
            <div class="video-detail-box">
                <div class="row g-4 align-items-start">
                    <!-- Cột 1: [poster] -->
                    <div class="col-md-5 col-lg-4 text-center">
                        <div class="poster-container mx-auto">
                            <img src="${pageContext.request.contextPath}/image?fname=${video.poster}" 
                                 alt="<c:out value='${video.title}'/>">
                        </div>
                    </div>

                    <!-- Cột 2: Thông tin chi tiết theo mẫu đề thi -->
                    <div class="col-md-7 col-lg-8">
                        <div class="d-flex flex-column gap-2">
                            <div>
                                <span class="info-label">Tiêu đề:</span>
                                <span class="info-value fw-bold text-primary fs-5"><c:out value="${video.title}"/></span>
                            </div>

                            <div>
                                <span class="info-label">Mã video:</span>
                                <span class="badge bg-dark fs-6">${video.videoId}</span>
                            </div>

                            <div>
                                <span class="info-label">Category name:</span>
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle fs-6">
                                    ${video.categoryName}
                                </span>
                            </div>

                            <div>
                                <span class="info-label">View:</span>
                                <span class="info-value text-success fw-bold">
                                    <i class="fa-solid fa-eye me-1"></i>${video.views}
                                </span>
                            </div>

                            <div>
                                <span class="info-label">Giá bán:</span>
                                <span class="info-value text-danger fw-bold">
                                    <fmt:formatNumber value="${video.price}" type="number" groupingUsed="true"/> đ
                                </span>
                            </div>

                            <div class="d-flex align-items-center gap-3 my-2 pt-2 border-top">
                                <!-- Share(số lượt share từ bảng Shares) -->
                                <div class="stat-badge bg-primary-subtle text-primary border border-primary-subtle">
                                    <i class="fa-solid fa-share-nodes"></i>
                                    <span>Share(${video.shareCount})</span>
                                </div>

                                <!-- Like(số lượt like từ bảng Favorites) -->
                                <div class="stat-badge bg-danger-subtle text-danger border border-danger-subtle">
                                    <i class="fa-solid fa-heart"></i>
                                    <span>Like(${video.likeCount})</span>
                                </div>
                            </div>

                            <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-flex flex-wrap gap-2 align-items-center pt-3">
                                <input type="hidden" name="videoId" value="${video.videoId}">
                                <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/video/detail?id=${video.videoId}">
                                <input class="form-control" style="max-width: 96px;" type="number" name="quantity" value="1" min="1" max="10" required aria-label="Số lượng video">
                                <button class="btn btn-success fw-bold" type="submit">
                                    <i class="fa-solid fa-cart-plus me-1"></i> Thêm vào giỏ
                                </button>
                                <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/cart">
                                    Xem giỏ hàng
                                </a>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- description (Phần mô tả ở bên dưới theo đúng mẫu đề thi) -->
                <div class="desc-box">
                    <div class="fw-bold text-dark mb-1">Mô tả video:</div>
                    <div class="text-secondary"><c:out value="${video.description}"/></div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>

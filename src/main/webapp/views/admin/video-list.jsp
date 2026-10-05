<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head><title>Quản lý video</title></head>
<body>
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="fa-solid fa-video text-primary me-2"></i>Quản lý video</h3>
            <span class="text-secondary">${totalVideos} video</span>
        </div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/video/add">
            <i class="fa-solid fa-plus me-1"></i> Thêm video
        </a>
    </div>
    <c:if test="${param.message == 'create_success'}">
        <div class="alert alert-success" role="status">Đã thêm video thành công.</div>
    </c:if>
    <c:if test="${param.message == 'update_success'}">
        <div class="alert alert-success" role="status">Đã cập nhật video thành công.</div>
    </c:if>
    <div class="table-responsive bg-white border-top">
        <table class="table align-middle mb-0">
            <thead class="table-light">
                <tr><th>Video</th><th>Danh mục</th><th class="text-end">Giá bán</th><th class="text-end">Lượt xem</th><th>Trạng thái</th><th class="text-end">Thao tác</th></tr>
            </thead>
            <tbody>
                <c:forEach var="video" items="${videoList}">
                    <c:url var="posterUrl" value="/image"><c:param name="fname" value="${video.poster}"/></c:url>
                    <c:url var="editUrl" value="/admin/video/edit"><c:param name="id" value="${video.videoId}"/></c:url>
                    <c:url var="detailUrl" value="/video/detail"><c:param name="id" value="${video.videoId}"/></c:url>
                    <tr>
                        <td>
                            <div class="d-flex align-items-center gap-3" style="min-width: 220px;">
                                <img src="${posterUrl}" alt="" width="96" height="60" class="rounded" style="object-fit: cover; flex-shrink: 0;">
                                <div style="max-width: 340px; overflow-wrap: anywhere;">
                                    <a class="fw-semibold text-decoration-none" href="${editUrl}"><c:out value="${video.title}"/></a>
                                    <div class="small text-secondary"><c:out value="${video.videoId}"/></div>
                                </div>
                            </div>
                        </td>
                        <td><c:out value="${video.categoryName}" default="Chưa có danh mục"/></td>
                        <td class="text-end text-nowrap"><fmt:formatNumber value="${video.price}" groupingUsed="true"/> đ</td>
                        <td class="text-end">${video.views}</td>
                        <td><span class="badge ${video.active ? 'bg-success-subtle text-success' : 'bg-secondary-subtle text-secondary'}">${video.active ? 'Đang hiển thị' : 'Đã ẩn'}</span></td>
                        <td class="text-end text-nowrap">
                            <c:if test="${video.active}">
                                <a class="btn btn-sm btn-outline-secondary" href="${detailUrl}" title="Xem video" aria-label="Xem video"><i class="fa-solid fa-eye"></i></a>
                            </c:if>
                            <a class="btn btn-sm btn-outline-primary" href="${editUrl}" title="Sửa video" aria-label="Sửa video"><i class="fa-solid fa-pen"></i></a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty videoList}"><tr><td colspan="6" class="text-center text-secondary py-5">Chưa có video.</td></tr></c:if>
            </tbody>
        </table>
    </div>
    <nav aria-label="Phân trang video" class="mt-4">
        <ul class="pagination justify-content-center flex-wrap">
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}"><a class="page-link" href="${pageContext.request.contextPath}/admin/videos?page=${currentPage - 1}" aria-label="Trang trước">&laquo;</a></li>
            <c:forEach var="page" begin="1" end="${totalPages}">
                <li class="page-item ${currentPage == page ? 'active' : ''}"><a class="page-link" href="${pageContext.request.contextPath}/admin/videos?page=${page}">${page}</a></li>
            </c:forEach>
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}"><a class="page-link" href="${pageContext.request.contextPath}/admin/videos?page=${currentPage + 1}" aria-label="Trang sau">&raquo;</a></li>
        </ul>
    </nav>
</body>
</html>

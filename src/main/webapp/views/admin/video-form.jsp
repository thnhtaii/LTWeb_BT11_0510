<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${editing ? 'Sửa video' : 'Thêm video'}</title>
    <style>
        .video-editor { max-width: 1060px; margin: 0 auto; }
        .video-poster-preview { width: 100%; aspect-ratio: 16 / 10; object-fit: contain; background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 6px; }
    </style>
</head>
<body>
    <div class="video-editor">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
            <h3 class="fw-bold mb-0"><i class="fa-solid ${editing ? 'fa-pen' : 'fa-plus'} text-primary me-2"></i>${editing ? 'Sửa video' : 'Thêm video'}</h3>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/videos"><i class="fa-solid fa-arrow-left me-1"></i> Danh sách video</a>
        </div>
        <c:if test="${not empty error}"><div class="alert alert-danger" role="alert"><c:out value="${error}"/></div></c:if>
        <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/admin/video/${editing ? 'edit' : 'add'}" class="bg-white p-4 border-top">
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="videoId" class="form-label fw-semibold">Mã video <span class="text-danger">*</span></label>
                            <input id="videoId" name="videoId" class="form-control ${editing ? 'bg-light' : ''}" value="<c:out value='${videoItem.videoId}'/>" maxlength="50" pattern="[A-Za-z0-9_-]{1,50}" required ${editing ? 'readonly' : ''}>
                        </div>
                        <div class="col-md-6">
                            <label for="categoryId" class="form-label fw-semibold">Danh mục <span class="text-danger">*</span></label>
                            <select id="categoryId" name="categoryId" class="form-select" required>
                                <option value="">Chọn danh mục</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryId}" ${videoItem.categoryId == category.categoryId ? 'selected' : ''}><c:out value="${category.categoryname}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12">
                            <label for="title" class="form-label fw-semibold">Tiêu đề <span class="text-danger">*</span></label>
                            <input id="title" name="title" class="form-control" value="<c:out value='${videoItem.title}'/>" maxlength="200" required>
                        </div>
                        <div class="col-md-6">
                            <label for="price" class="form-label fw-semibold">Giá bán (VND) <span class="text-danger">*</span></label>
                            <input id="price" name="price" class="form-control" type="number" value="<c:out value='${not empty priceInput ? priceInput : videoItem.price}'/>" min="0" max="999999999999999999" step="1" required>
                        </div>
                        <div class="col-md-6 d-flex align-items-end">
                            <div class="form-check form-switch mb-2">
                                <input id="active" name="active" type="checkbox" role="switch" class="form-check-input" value="true" ${videoItem.active ? 'checked' : ''}>
                                <label for="active" class="form-check-label">Hiển thị video</label>
                            </div>
                        </div>
                        <div class="col-12">
                            <label for="description" class="form-label fw-semibold">Mô tả</label>
                            <textarea id="description" name="description" class="form-control" rows="6" maxlength="500"><c:out value="${videoItem.description}"/></textarea>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <c:url var="posterUrl" value="/image"><c:param name="fname" value="${videoItem.poster}"/></c:url>
                    <img id="posterPreview" class="video-poster-preview mb-3" src="${posterUrl}" alt="Poster video">
                    <label for="posterFile" class="form-label fw-semibold">Poster (JPG, PNG, GIF; tối đa 5 MB)</label>
                    <input id="posterFile" name="posterFile" class="form-control mb-3" type="file" accept="image/jpeg,image/png,image/gif">
                    <label for="poster" class="form-label">Tên file poster</label>
                    <input id="poster" name="poster" class="form-control" value="<c:out value='${videoItem.poster}'/>" maxlength="50">
                </div>
            </div>
            <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/videos">Hủy</a>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk me-1"></i> ${editing ? 'Lưu thay đổi' : 'Thêm video'}</button>
            </div>
        </form>
    </div>
    <script>
        const posterFile = document.getElementById('posterFile');
        const posterPreview = document.getElementById('posterPreview');
        const originalPoster = posterPreview.src;
        let previewUrl;
        posterFile.addEventListener('change', () => {
            if (previewUrl) URL.revokeObjectURL(previewUrl);
            const file = posterFile.files[0];
            posterFile.setCustomValidity(file && file.size > 5 * 1024 * 1024 ? 'Poster tối đa 5 MB.' : '');
            previewUrl = file ? URL.createObjectURL(file) : null;
            posterPreview.src = previewUrl || originalPoster;
        });
    </script>
</body>
</html>

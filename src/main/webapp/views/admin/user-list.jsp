<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản Trị Bảng Users - Phân Trang 6 Users/Trang</title>
</head>
<body>

    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
            <h3 class="fw-bold text-dark m-0">
                <i class="fa-solid fa-users-gear text-primary me-2"></i>Quản Trị Dữ Liệu Bảng Users
            </h3>
            <p class="text-secondary small m-0">
                Chức năng CRUD (Tạo, Xem, Cập nhật, Xóa) có phân trang <strong>6 user trên 01 trang</strong>
            </p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/admin/user/add" class="btn btn-primary fw-semibold shadow-sm">
                <i class="fa-solid fa-plus me-1"></i> Thêm Người Dùng Mới
            </a>
        </div>
    </div>

    <!-- Thông báo kết quả thao tác -->
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2" role="alert">
            <i class="fa-solid fa-circle-check fs-5"></i>
            <div>${success}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Bảng danh sách Users -->
    <div class="card border-0 shadow-sm rounded-3 overflow-hidden bg-white mb-4">
        <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
            <span class="fw-bold text-secondary">
                <i class="fa-solid fa-list me-1"></i> Danh Sách Người Dùng (Tổng: <strong>${totalUsers}</strong>)
            </span>
            <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                Phân trang: 6 user/trang
            </span>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-3" style="width: 60px;">Ảnh</th>
                        <th>Tên đăng nhập (Username)</th>
                        <th>Họ và tên</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th class="text-center">Vai trò</th>
                        <th class="text-center">Trạng thái</th>
                        <th class="text-center" style="width: 170px;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty userList}">
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">
                                    Không có dữ liệu người dùng!
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${userList}">
                                <tr>
                                    <td class="ps-3">
                                        <img src="${pageContext.request.contextPath}/image?fname=${u.images}" 
                                             class="rounded-circle border" 
                                             style="width: 40px; height: 40px; object-fit: cover;" 
                                             alt="${u.username}">
                                    </td>
                                    <td>
                                        <strong class="text-primary">${u.username}</strong>
                                    </td>
                                    <td>${u.fullname != null ? u.fullname : '<span class="text-muted fst-italic">Chưa cập nhật</span>'}</td>
                                    <td>${u.email != null ? u.email : '<span class="text-muted fst-italic">Trống</span>'}</td>
                                    <td>${u.phone != null ? u.phone : '<span class="text-muted fst-italic">Trống</span>'}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${u.admin}">
                                                <span class="badge bg-danger">Admin</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">User</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${u.active}">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle">
                                                    <i class="fa-solid fa-circle-dot me-1"></i>Hoạt động
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle">
                                                    <i class="fa-solid fa-circle-xmark me-1"></i>Đã khóa
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center pe-3">
                                        <div class="btn-group btn-group-sm">
                                            <!-- Xem chi tiết -->
                                            <a href="${pageContext.request.contextPath}/admin/user/view?username=${u.username}&page=${currentPage}" 
                                               class="btn btn-outline-info" title="Xem chi tiết">
                                                <i class="fa-solid fa-eye"></i>
                                            </a>
                                            <!-- Cập nhật -->
                                            <a href="${pageContext.request.contextPath}/admin/user/edit?username=${u.username}" 
                                               class="btn btn-outline-warning" title="Chỉnh sửa">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>
                                            <!-- Xóa (Có hộp thoại xác nhận) -->
                                            <button type="button" 
                                                    class="btn btn-outline-danger" 
                                                    onclick="confirmDelete('${u.username}')"
                                                    title="Xóa người dùng">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Phân trang 6 user trên 01 trang (Câu 3) -->
        <div class="card-footer bg-white py-3 border-top d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
            <div class="text-secondary small">
                Hiển thị trang <strong>${currentPage}</strong> trên tổng số <strong>${totalPages}</strong> trang (6 user / trang)
            </div>

            <nav aria-label="Users Page navigation">
                <ul class="pagination pagination-sm m-0">
                    <!-- Nút trang trước << -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}">
                            &laquo; Trước
                        </a>
                    </li>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${i}">${i}</a>
                        </li>
                    </c:forEach>

                    <!-- Nút trang sau >> -->
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}">
                            Sau &raquo;
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>

    <!-- Modal Xem Chi Tiết User (nếu có viewUser) -->
    <c:if test="${not empty viewUser}">
        <div class="modal fade show" id="viewUserModal" tabindex="-1" style="display: block; background: rgba(0,0,0,0.5);">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content rounded-4 border-0 shadow">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold">
                            <i class="fa-solid fa-id-card me-2"></i>Chi Tiết Người Dùng
                        </h5>
                        <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage}" class="btn-close btn-close-white"></a>
                    </div>
                    <div class="modal-body p-4 text-center">
                        <img src="${pageContext.request.contextPath}/image?fname=${viewUser.images}" 
                             class="rounded-circle border shadow-sm mb-3" 
                             style="width: 90px; height: 90px; object-fit: cover;" alt="${viewUser.username}">
                        <h4 class="fw-bold text-dark mb-1">${viewUser.fullname}</h4>
                        <div class="badge bg-primary mb-3">@${viewUser.username}</div>

                        <div class="list-group text-start">
                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                <span class="text-secondary fw-semibold">Email:</span>
                                <span>${viewUser.email}</span>
                            </div>
                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                <span class="text-secondary fw-semibold">Số điện thoại:</span>
                                <span>${viewUser.phone}</span>
                            </div>
                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                <span class="text-secondary fw-semibold">Vai trò:</span>
                                <span class="badge ${viewUser.admin ? 'bg-danger' : 'bg-secondary'}">
                                    ${viewUser.admin ? 'Quản Trị Viên (Admin)' : 'Người Dùng (User)'}
                                </span>
                            </div>
                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                <span class="text-secondary fw-semibold">Trạng thái:</span>
                                <span class="badge ${viewUser.active ? 'bg-success' : 'bg-danger'}">
                                    ${viewUser.active ? 'Đang Hoạt Động' : 'Bị Khóa'}
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <a href="${pageContext.request.contextPath}/admin/user/edit?username=${viewUser.username}" class="btn btn-warning btn-sm fw-semibold">
                            <i class="fa-solid fa-pen-to-square me-1"></i> Chỉnh Sửa
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage}" class="btn btn-secondary btn-sm">
                            Đóng
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Modal Xác Nhận Xóa Người Dùng (Thay thế thông báo popup trình duyệt) -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" onclick="closeDeleteModal()" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center px-4 pb-4 pt-0">
                    <div class="mb-3 text-danger">
                        <i class="fa-solid fa-circle-exclamation" style="font-size: 3.8rem;"></i>
                    </div>
                    <h5 class="modal-title fw-bold text-dark mb-2" id="deleteModalLabel">Xác Nhận Xóa</h5>
                    <p class="text-secondary mb-3 fs-6">
                        Bạn có chắc chắn muốn xóa người dùng <strong id="deleteTargetUser" class="text-danger fw-bold"></strong> không?
                    </p>
                    <p class="small text-muted mb-0">Hành động này sẽ xóa dữ liệu và không thể hoàn tác.</p>
                </div>
                <div class="modal-footer border-0 bg-light d-flex justify-content-center gap-2 py-3 rounded-bottom-4">
                    <button type="button" class="btn btn-secondary px-4 fw-semibold" data-bs-dismiss="modal" onclick="closeDeleteModal()">
                        <i class="fa-solid fa-xmark me-1"></i> Hủy
                    </button>
                    <a id="btnConfirmDeleteAction" href="#" class="btn btn-danger px-4 fw-semibold">
                        <i class="fa-solid fa-trash-can me-1"></i> Chắc chắn xóa
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(username) {
            document.getElementById('deleteTargetUser').textContent = '[' + username + ']';
            document.getElementById('btnConfirmDeleteAction').href = '${pageContext.request.contextPath}/admin/user/delete?username=' + encodeURIComponent(username) + '&page=${currentPage}';
            var deleteModalEl = document.getElementById('deleteConfirmModal');
            if (window.bootstrap && bootstrap.Modal) {
                var deleteModal = bootstrap.Modal.getInstance(deleteModalEl) || new bootstrap.Modal(deleteModalEl);
                deleteModal.show();
            } else {
                deleteModalEl.classList.add('show');
                deleteModalEl.style.display = 'block';
                deleteModalEl.style.backgroundColor = 'rgba(0,0,0,0.5)';
            }
        }

        function closeDeleteModal() {
            var deleteModalEl = document.getElementById('deleteConfirmModal');
            if (window.bootstrap && bootstrap.Modal) {
                var deleteModal = bootstrap.Modal.getInstance(deleteModalEl);
                if (deleteModal) deleteModal.hide();
            }
            deleteModalEl.classList.remove('show');
            deleteModalEl.style.display = 'none';
        }
    </script>
</body>
</html>

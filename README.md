# DỰ ÁN BÀI THI QUÁ TRÌNH - MÔN LẬP TRÌNH WEB (ĐỀ SỐ 04)

## 1. Thông Tin Sinh Viên & Bài Thi
- **Họ và tên:** Đỗ Thanh Thành Tài
- **Mã số sinh viên (MSSV):** 24133050
- **Mã đề thi:** Đề số 04
- **Công nghệ nền tảng:** Java Servlet (Jakarta EE 10) + JDBC + JSP + JSTL + SiteMesh 3 + SQL Server

---

## 2. Quy Tắc Đặt Tên Bắt Buộc (Tuân thủ 100%)
Toàn bộ các **Class**, **Interface**, **DAO**, **Service**, **Controller** đều có hậu tố mã số sinh viên `_24133050`:

| Phân tầng kiến trúc | Danh sách các File & Class |
| :--- | :--- |
| **Entity / Models** | `User_24133050.java`<br>`Category_24133050.java`<br>`Video_24133050.java`<br>`Favorite_24133050.java`<br>`Share_24133050.java` |
| **Cấu hình & Kết nối** | `DBConnection_24133050.java`<br>`Constant_24133050.java`<br>`EmailUtil_24133050.java`<br>`SiteMeshFilter_24133050.java` |
| **Data Access Layer (DAO)** | `IUserDao_24133050.java` & `UserDaoImpl_24133050.java`<br>`ICategoryDao_24133050.java` & `CategoryDaoImpl_24133050.java`<br>`IVideoDao_24133050.java` & `VideoDaoImpl_24133050.java` |
| **Business Layer (Services)** | `IUserService_24133050.java` & `UserServiceImpl_24133050.java`<br>`ICategoryService_24133050.java` & `CategoryServiceImpl_24133050.java`<br>`IVideoService_24133050.java` & `VideoServiceImpl_24133050.java`<br>`IEmailService_24133050.java` & `EmailServiceImpl_24133050.java` |
| **Presentation Layer (Controllers)** | `HomeController_24133050.java`<br>`LoginController_24133050.java`<br>`RegisterController_24133050.java`<br>`VerifyOtpController_24133050.java`<br>`LogoutController_24133050.java`<br>`AdminHomeController_24133050.java`<br>`AdminUserController_24133050.java`<br>`VideoDetailController_24133050.java`<br>`CategoryVideoController_24133050.java`<br>`ImageController_24133050.java` |

---

## 3. Chi Tiết Thực Hiện Các Yêu Cầu Đề Thi

### Câu 1 (1.5 điểm): Cấu Trúc 3 Lớp & Sitemesh Decorators
- **Mô hình 3 lớp:** Tách biệt rõ ràng giữa Presentation (MVC) - Business (Service) - Data Access (DAO).
- **SiteMesh 3:** Sử dụng `SiteMeshFilter_24133050` điều phối 02 giao diện riêng biệt:
  - **User Decorator (`user.jsp`):**
    - **Header menu:** Chứa đầy đủ `Trang Chủ`, `Sản phẩm`, `Đăng nhập`, và `Trang quản trị` (chỉ hiển thị khi đăng nhập với tài khoản Admin).
    - **Footer:** Chứa đầy đủ thông tin: Họ tên: **Đỗ Thanh Thành Tài**, MSSV: **24133050**, Mã đề: **Đề số 04**.
  - **Admin Decorator (`admin.jsp`):**
    - Thiết kế Dashboard quản trị chuyên nghiệp, menu điều hướng nhanh, và Footer chứa đầy đủ thông tin sinh viên & mã đề.

### Câu 2 (1.5 điểm): Xác Thực OTP Qua Mail & Quản Lý Phiên (Session)
- **Đăng ký kích hoạt OTP:**
  - Kiểm tra tính hợp lệ và không trùng lặp `username`, `email`.
  - Sinh mã OTP ngẫu nhiên 6 chữ số qua `EmailUtil_24133050`.
  - Tự động in mã OTP ra **Console** giúp chấm bài thuận tiện ngay cả khi không có kết nối Internet gửi mail.
- **Xác thực OTP:**
  - Kiểm tra mã OTP và thời hạn 5 phút. Khi nhập đúng, tài khoản được kích hoạt (`Active = 1`) và lưu vào CSDL.
- **Đăng nhập & Phân quyền Session:**
  - Đăng nhập thành công với vai trò **Admin** $\rightarrow$ Tự động vào trang chủ quản trị (`/admin/home`).
  - Đăng nhập với vai trò **User** thường $\rightarrow$ Vào trang chủ (`/home`), bị chặn không thể vào vùng quản trị `/admin/*`.
  - Đăng nhập thất bại $\rightarrow$ Quay lại trang đăng nhập kèm thông báo lỗi.
- **Đăng xuất:**
  - Hủy bỏ `HttpSession` (`session.invalidate()`) và chuyển hướng về trang đăng nhập.

### Câu 3 (2.5 điểm): Quản Trị CRUD Bảng Users Có Phân Trang 6 User/Trang
- **CRUD:**
  - **Create:** Thêm người dùng mới với đầy đủ kiểm tra lỗi và tải ảnh đại diện.
  - **Read:** Hiển thị danh sách người dùng và cửa sổ Modal xem chi tiết người dùng.
  - **Update:** Chỉnh sửa thông tin họ tên, email, số điện thoại, vai trò (Admin/User), trạng thái (Active/Inactive).
  - **Delete:** Xóa người dùng kèm **Hộp thoại Modal xác nhận xóa** (không dùng popup mặc định của trình duyệt).
- **Phân trang:**
  - Sử dụng cú pháp SQL Server phân trang chuẩn: `OFFSET ? ROWS FETCH NEXT 6 ROWS ONLY`.
  - Hiển thị đúng **6 user trên 01 trang** theo yêu cầu đề thi.

### Câu 4 (1.5 điểm): Trang Chi Tiết 01 Video Đúng Mẫu Đề Thi
- Đường dẫn: `/video/detail?id=VID_M01`
- Khung thông tin chuẩn mẫu:
  - Cột 1: `[poster]` (ảnh poster tỷ lệ chuẩn 16:9).
  - Cột 2:
    - `Tiêu đề: ...`
    - `Mã video: ...`
    - `Category name: ...`
    - `View: ...` (tự động cộng 1 lượt xem khi truy cập)
    - `Share(10)` (đếm số lượt share từ bảng `Shares`)
    - `Like(10)` (đếm số lượt like từ bảng `Favorites`)
  - Phía dưới:
    - `description: ...` (mô tả nội dung video)

### Câu 5 (2.5 điểm): Hiển Thị Video Theo Từng Category Phân Trang 3 Video/Trang
- Đường dẫn: `/category/videos?categoryId=1&page=1`
- Hiển thị theo từng Category với bố cục 3 video trên 1 hàng đúng mẫu đề thi:
  - Tiêu đề nhóm: `Category Name (Số lượng)`
  - Mỗi video có đầy đủ: `[poster]`, `Tiêu đề`, `Mã video`, `Category name`, `View`, `Share(10)`, `Like(10)`.
  - Thanh điều hướng phân trang đúng định dạng: `<< 1 2 3 4 5 >>`.
  - Phân trang chuẩn xác **3 video trên 01 trang**.

### Câu 6 (0.5 điểm): Đếm Số Lượng Video Theo Từng Category
- Sử dụng truy vấn SQL tổng hợp:
  ```sql
  SELECT c.CategoryId, c.Categoryname, c.Categorycode, c.Images, c.Status,
         COUNT(v.VideoId) AS VideoCount
  FROM Category c
  LEFT JOIN Videos v ON c.CategoryId = v.CategoryId
  GROUP BY c.CategoryId, c.Categoryname, c.Categorycode, c.Images, c.Status
  ```
- Hiển thị đồng bộ ở tiêu đề nhóm và các tab danh mục:
  - `Âm Nhạc (5)`
  - `Phim Hoạt Hình (4)`
  - `Công Nghệ & Lập Trình (3)`
  - `Thể Thao (2)`

---

## 4. Hướng Dẫn Khởi Chạy Dự Án

### Cấu hình mật khẩu SQL Server
Đặt biến môi trường `APP_DB_PASSWORD`, hoặc tạo file `db.local.properties` tại thư mục gốc theo mẫu `db.local.properties.example` và điền mật khẩu SQL Server. File cấu hình riêng này được bỏ qua bởi Git để không đưa mật khẩu lên GitHub. Khi dùng file cấu hình, chạy project với thư mục làm việc là thư mục gốc.

### Cách 1: Chạy bằng Maven Jetty (Nhanh nhất)
1. Mở Terminal tại thư mục gốc của project:
   ```powershell
   mvn jetty:run
   ```
2. Mở trình duyệt truy cập:
   - Website người dùng: **`http://localhost:8085/KT_QT/home`**
   - Trang quản trị Admin: **`http://localhost:8085/KT_QT/admin/home`**

### Cách 2: Chạy trên Eclipse / Spring Tool Suite (STS)
1. Mở Eclipse / STS, import project dạng **Existing Maven Projects**.
2. Chuột phải vào project `KT_QT` $\rightarrow$ **Run As** $\rightarrow$ **Run on Server** $\rightarrow$ Chọn **Apache Tomcat v11.0**.
3. Đường dẫn truy cập: **`http://localhost:8080/KT_QT/`**

---

## 5. Tài Khoản Kiểm Thử Có Sẵn
| Vai trò | Tên đăng nhập (`username`) | Mật khẩu (`password`) | Quyền hạn |
| :--- | :--- | :--- | :--- |
| **Quản Trị Viên (Admin)** | `admin` | `123456` | Truy cập toàn bộ khu vực Admin `/admin/home` và `/admin/users` |
| **Người Dùng Thường (User)** | `user01` đến `user15` | `123456` | Xem video, phân trang danh mục, xem chi tiết video |

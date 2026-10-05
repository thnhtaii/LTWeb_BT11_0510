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
Tạo file `db.local.properties` tại thư mục gốc theo mẫu `db.local.properties.example`, điền cổng TCP, tài khoản và mật khẩu SQL Server. Có thể ghi đè từng giá trị bằng các biến môi trường `APP_DB_SERVER`, `APP_DB_PORT`, `APP_DB_NAME`, `APP_DB_USER`, `APP_DB_PASSWORD`. File cấu hình riêng này được bỏ qua bởi Git. Khi dùng file cấu hình, chạy project với thư mục làm việc là thư mục gốc.

Với SQL Express trên máy cá nhân và tài khoản Windows có quyền quản lý database `KT_QT`, chạy `pwsh -File tools/setup-local-db.ps1`. Script tự lấy cổng TCP, tạo tài khoản SQL riêng chỉ có quyền đọc/ghi dữ liệu trong `KT_QT`, bổ sung cấu trúc giỏ hàng/đơn hàng và ghi cấu hình riêng. Dữ liệu hiện có được giữ lại. Nếu cổng động thay đổi sau khi khởi động lại SQL Server, chạy lại script rồi khởi động lại Jetty.

Database cũ có thể nâng cấp bằng `database-commerce-migration.sql`. File `database.sql` dành cho khởi tạo lại dữ liệu mẫu và có xóa các bảng cũ.

### Cách 1: Chạy bằng Maven Jetty (Nhanh nhất)
1. Mở Terminal tại thư mục gốc của project:
   ```powershell
   mvn "-Dmaven.test.skip=true" jetty:run
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

## 6. Giỏ Hàng Và Đặt Mua Video (Vai Trò User)

Đăng nhập bằng `user01 / 123456` tại `http://localhost:8085/KT_QT/login`. Mỗi sản phẩm là một video, liên kết giỏ hàng và đơn hàng bằng `VideoId`; giá lấy từ `Videos.Price`.

1. Mở `/category/videos` hoặc trang chi tiết `/video/detail?id=VID_M01`, chọn số lượng rồi nhấn **Thêm vào giỏ**. Trang chủ cũng có nút thêm video.
2. Mở `/cart`: sửa số lượng, nhấn nút cập nhật, xóa từng video hoặc xóa toàn bộ giỏ. Số lượng được giới hạn 1–10 cả trên giao diện và phía server; thêm lại cùng video sẽ cộng số lượng tới tối đa 10.
3. Nhấn **Thanh toán COD**, nhập tên, số điện thoại và địa chỉ nhận hàng, xác nhận đặt hàng. Đơn mới có trạng thái `NEW`, phương thức `COD`; chi tiết đơn lưu giá và số lượng tại lúc đặt. Giỏ được xóa sau khi lưu đơn thành công.
4. Mở `/orders` để xem đơn của tài khoản đang đăng nhập và lọc theo trạng thái. Trang `/order-history` cũng mở lịch sử đơn.

### Mã trạng thái trong database

| `Orders.Status` | Hiển thị |
| :--- | :--- |
| `NEW` | Đơn hàng mới |
| `CONFIRMED` | Đã xác nhận |
| `PREPARING` | Chuẩn bị hàng |
| `SHIPPING` | Vận chuyển |
| `DELIVERING` | Giao hàng |
| `DELIVERED` | Đã giao |
| `CANCELED` | Đơn hàng hủy |
| `RETURNED` | Đơn hàng hoàn |

Trong SQL Server Management Studio, chọn database `KT_QT` và chạy truy vấn để tìm mã đơn:

```sql
SELECT OrderId, Username, Status, PaymentMethod, TotalAmount
FROM dbo.Orders
WHERE Username = 'user01'
ORDER BY OrderId DESC;
```

Đổi `OrderId` theo mã đơn vừa tìm, đổi mã trạng thái theo bảng trên:

```sql
UPDATE dbo.Orders
SET Status = 'CONFIRMED'
WHERE OrderId = 1 AND Username = 'user01';
```

Tải lại `/orders?status=CONFIRMED`: đơn sẽ xuất hiện ở bộ lọc **Đã xác nhận**, đồng thời không còn ở bộ lọc **Đơn hàng mới**. Thực hiện tương tự với các trạng thái khác.

Có thể chạy `database-order-status-demo.sql` trong database `KT_QT` để thêm 8 đơn video mẫu cho `user01`, mỗi trạng thái một đơn. Script không xóa dữ liệu hiện có và chạy lại không tạo trùng các đơn mẫu.

### Kiểm thử chức năng

Khi Jetty đang chạy và cấu hình database đã đúng:

```powershell
pwsh -File tools/verify-user-flow.ps1
```

Bộ kiểm thử gọi trực tiếp các endpoint và đối chiếu dữ liệu SQL: đăng nhập, thêm/xóa/sửa giỏ, giới hạn số lượng, tổng tiền COD, lưu chi tiết đơn, xóa giỏ sau thanh toán và lọc đủ 8 trạng thái sau khi thay đổi database. Tài khoản và đơn được tạo riêng cho kiểm thử rồi xóa khi kết thúc; không chỉnh đơn của người dùng hiện có.

## 7. Thêm Và Sửa Video (Admin)

Đăng nhập `admin / 123456`, mở menu **Quản lý video** tại `/admin/videos`. Danh sách có phân trang và hiển thị cả video đang hoạt động lẫn video đã ẩn.

- **Thêm video:** nhấn **Thêm video**, nhập mã duy nhất, tiêu đề, danh mục, giá bán, mô tả và chọn trạng thái hiển thị. Có thể tải poster JPG/PNG/GIF (tối đa 5 MB, 16 triệu điểm ảnh) hoặc chọn tên file trong `uploads`.
- **Sửa video:** nhấn biểu tượng bút, chỉnh thông tin và lưu. Mã video được giữ nguyên; lượt xem, lượt thích/chia sẻ và các đơn hàng cũ không bị thay đổi. Nếu không chọn poster mới, ảnh cũ được giữ lại.
- **Hiển thị:** video đang hoạt động xuất hiện ở danh mục và trang chi tiết phía User; tắt công tắc sẽ ẩn video khỏi các trang này. Giá đã lưu trong các đơn hàng cũ được giữ nguyên khi sửa giá video.

Các chức năng này chỉ cho phép Admin truy cập. Khi dữ liệu không hợp lệ hoặc không lưu được, form hiển thị lỗi thay vì báo thành công.

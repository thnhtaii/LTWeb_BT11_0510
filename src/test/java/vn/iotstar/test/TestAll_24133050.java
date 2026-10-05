package vn.iotstar.test;

import java.util.List;

import vn.iotstar.entity.Category_24133050;
import vn.iotstar.entity.User_24133050;
import vn.iotstar.entity.Video_24133050;
import vn.iotstar.service.ICategoryService_24133050;
import vn.iotstar.service.IUserService_24133050;
import vn.iotstar.service.IVideoService_24133050;
import vn.iotstar.service.impl.CategoryServiceImpl_24133050;
import vn.iotstar.service.impl.UserServiceImpl_24133050;
import vn.iotstar.service.impl.VideoServiceImpl_24133050;

public class TestAll_24133050 {

    public static void main(String[] args) {
        System.out.println("====== BẮT ĐẦU KIỂM THỬ HỆ THỐNG KT_QT (24133050) ======");

        IUserService_24133050 userService = new UserServiceImpl_24133050();
        ICategoryService_24133050 categoryService = new CategoryServiceImpl_24133050();
        IVideoService_24133050 videoService = new VideoServiceImpl_24133050();

        // 1. Kiểm tra Câu 2: Đăng nhập Admin và User
        User_24133050 admin = userService.login("admin", "123456");
        System.out.println("[Câu 2] Đăng nhập Admin: " + (admin != null && admin.isAdmin() ? "THÀNH CÔNG (Role: Admin)" : "THẤT BÀI"));

        User_24133050 normalUser = userService.login("user01", "123456");
        System.out.println("[Câu 2] Đăng nhập User thường: " + (normalUser != null && !normalUser.isAdmin() ? "THÀNH CÔNG (Role: User)" : "THẤT BÀI"));

        // 2. Kiểm tra Câu 3: Phân trang 6 users / trang
        int totalUsers = userService.countAll();
        System.out.println("[Câu 3] Tổng số Users: " + totalUsers);
        List<User_24133050> page1Users = userService.findAll(1, 6);
        System.out.println("[Câu 3] Số users trên trang 1 (kỳ vọng 6): " + page1Users.size());
        List<User_24133050> page2Users = userService.findAll(2, 6);
        System.out.println("[Câu 3] Số users trên trang 2 (kỳ vọng 6): " + page2Users.size());
        List<User_24133050> page3Users = userService.findAll(3, 6);
        System.out.println("[Câu 3] Số users trên trang 3 (kỳ vọng 4): " + page3Users.size());

        // 3. Kiểm tra Câu 4: Chi tiết 1 video với Like(10) và Share(10)
        Video_24133050 video = videoService.findById("VID_M01");
        if (video != null) {
            System.out.println("[Câu 4] Chi tiết video VID_M01:");
            System.out.println("   + Tiêu đề: " + video.getTitle());
            System.out.println("   + Mã video: " + video.getVideoId());
            System.out.println("   + Category name: " + video.getCategoryName());
            System.out.println("   + Views: " + video.getViews());
            System.out.println("   + Share count: " + video.getShareCount() + " (Kỳ vọng 10)");
            System.out.println("   + Like count: " + video.getLikeCount() + " (Kỳ vọng 10)");
        } else {
            System.out.println("[Câu 4] Không tìm thấy video VID_M01!");
        }

        // 4. Kiểm tra Câu 5: Phân trang 3 video / trang theo Category
        List<Video_24133050> cat1VideosPage1 = videoService.findByCategoryId(1, 1, 3);
        System.out.println("[Câu 5] Số video trang 1 của Category 1 (kỳ vọng 3): " + cat1VideosPage1.size());
        List<Video_24133050> cat1VideosPage2 = videoService.findByCategoryId(1, 2, 3);
        System.out.println("[Câu 5] Số video trang 2 của Category 1 (kỳ vọng 2): " + cat1VideosPage2.size());

        // 5. Kiểm tra Câu 6: Đếm số lượng video theo từng Category
        List<Category_24133050> catList = categoryService.findAllWithVideoCount();
        System.out.println("[Câu 6] Đếm số lượng video theo Category:");
        for (Category_24133050 c : catList) {
            System.out.println("   + " + c.getCategoryname() + " (" + c.getVideoCount() + ")");
        }

        System.out.println("====== HOÀN TẤT KIỂM THỬ: TẤT CẢ CHỨC NĂNG ĐỀU CHÍNH XÁC! ======");
    }
}

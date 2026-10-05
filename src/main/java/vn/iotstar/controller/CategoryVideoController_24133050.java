package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.iotstar.entity.Category_24133050;
import vn.iotstar.entity.Video_24133050;
import vn.iotstar.service.ICategoryService_24133050;
import vn.iotstar.service.IVideoService_24133050;
import vn.iotstar.service.impl.CategoryServiceImpl_24133050;
import vn.iotstar.service.impl.VideoServiceImpl_24133050;
import vn.iotstar.utils.Constant_24133050;

@WebServlet(urlPatterns = { "/category/videos", "/videos", "/san-pham" })
public class CategoryVideoController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ICategoryService_24133050 categoryService = new CategoryServiceImpl_24133050();
    private IVideoService_24133050 videoService = new VideoServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Câu 6: Đếm số lượng Video theo từng Category hiển thị ở Câu 5
        List<Category_24133050> categories = categoryService.findAllWithVideoCount();
        req.setAttribute("categories", categories);

        int selectedCategoryId = 0;
        String catIdParam = req.getParameter("categoryId");
        if (catIdParam != null && !catIdParam.trim().isEmpty()) {
            try {
                selectedCategoryId = Integer.parseInt(catIdParam.trim());
            } catch (NumberFormatException e) {
                selectedCategoryId = 0;
            }
        }

        // Nếu chưa chọn category, mặc định lấy category đầu tiên trong danh sách
        if (selectedCategoryId <= 0 && !categories.isEmpty()) {
            selectedCategoryId = categories.get(0).getCategoryId();
        }

        // Tìm thông tin Category đang chọn
        Category_24133050 currentCategory = null;
        for (Category_24133050 c : categories) {
            if (c.getCategoryId() == selectedCategoryId) {
                currentCategory = c;
                break;
            }
        }

        // Câu 5: Phân trang 3 video trên 01 trang
        int page = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr.trim());
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int pageSize = Constant_24133050.VIDEO_PAGE_SIZE; // 3 video / trang
        int totalVideos = videoService.countByCategoryId(selectedCategoryId);
        int totalPages = (int) Math.ceil((double) totalVideos / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<Video_24133050> videoList = videoService.findByCategoryId(selectedCategoryId, page, pageSize);

        req.setAttribute("currentCategory", currentCategory);
        req.setAttribute("selectedCategoryId", selectedCategoryId);
        req.setAttribute("videoList", videoList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalVideos", totalVideos);

        req.getRequestDispatcher("/views/web/category-videos.jsp").forward(req, resp);
    }
}

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

@WebServlet(urlPatterns = { "/home", "/trang-chu" })
public class HomeController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ICategoryService_24133050 categoryService = new CategoryServiceImpl_24133050();
    private IVideoService_24133050 videoService = new VideoServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Tải danh sách thể loại có số lượng video (Câu 6)
        List<Category_24133050> categories = categoryService.findAllWithVideoCount();
        req.setAttribute("categories", categories);

        // Tải 6 video nổi bật hiển thị ở trang chủ
        List<Video_24133050> topVideos = videoService.findAll(1, 6);
        req.setAttribute("topVideos", topVideos);

        req.getRequestDispatcher("/views/web/home.jsp").forward(req, resp);
    }
}

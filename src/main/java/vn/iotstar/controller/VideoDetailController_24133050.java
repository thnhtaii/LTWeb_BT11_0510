package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.iotstar.entity.Video_24133050;
import vn.iotstar.service.IVideoService_24133050;
import vn.iotstar.service.impl.VideoServiceImpl_24133050;

@WebServlet(urlPatterns = { "/video/detail", "/video" })
public class VideoDetailController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IVideoService_24133050 videoService = new VideoServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoId = req.getParameter("id");
        if (videoId == null || videoId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/category/videos");
            return;
        }

        // Tăng lượt xem (views) khi người dùng mở trang chi tiết video
        videoService.increaseViews(videoId.trim());

        // Lấy chi tiết video kèm tên category, số like (Favorites) và số share (Shares)
        Video_24133050 video = videoService.findById(videoId.trim());

        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/category/videos");
            return;
        }

        req.setAttribute("video", video);
        req.getRequestDispatcher("/views/web/video-detail.jsp").forward(req, resp);
    }
}

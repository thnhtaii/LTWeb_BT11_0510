package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.iotstar.entity.User_24133050;
import vn.iotstar.service.ICategoryService_24133050;
import vn.iotstar.service.IUserService_24133050;
import vn.iotstar.service.IVideoService_24133050;
import vn.iotstar.service.impl.CategoryServiceImpl_24133050;
import vn.iotstar.service.impl.UserServiceImpl_24133050;
import vn.iotstar.service.impl.VideoServiceImpl_24133050;

@WebServlet(urlPatterns = { "/admin/home", "/admin" })
public class AdminHomeController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService_24133050 userService = new UserServiceImpl_24133050();
    private ICategoryService_24133050 categoryService = new CategoryServiceImpl_24133050();
    private IVideoService_24133050 videoService = new VideoServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User_24133050 user = (User_24133050) session.getAttribute("user");
        if (!user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Tải số liệu thống kê cho trang Dashboard Admin
        int totalUsers = userService.countAll();
        int totalCategories = categoryService.findAll().size();
        int totalVideos = videoService.countAll();

        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("totalCategories", totalCategories);
        req.setAttribute("totalVideos", totalVideos);

        req.getRequestDispatcher("/views/admin/home.jsp").forward(req, resp);
    }
}

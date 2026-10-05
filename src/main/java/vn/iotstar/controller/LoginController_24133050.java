package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.iotstar.entity.User_24133050;
import vn.iotstar.service.IUserService_24133050;
import vn.iotstar.service.impl.UserServiceImpl_24133050;

@WebServlet(urlPatterns = { "/login", "/dang-nhap" })
public class LoginController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService_24133050 userService = new UserServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User_24133050 user = (User_24133050) session.getAttribute("user");
            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/home");
                return;
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
        }

        String msg = req.getParameter("message");
        if ("register_success".equals(msg)) {
            req.setAttribute("success", "Kích hoạt tài khoản thành công! Vui lòng đăng nhập.");
        } else if ("logout_success".equals(msg)) {
            req.setAttribute("success", "Bạn đã đăng xuất thành công.");
        }

        req.getRequestDispatcher("/views/web/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/web/login.jsp").forward(req, resp);
            return;
        }

        User_24133050 user = userService.login(username.trim(), password.trim());

        if (user != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);

            // Câu 2: Đăng nhập với vai trò admin thành công thì vào trang chủ của admin, ngược lại thì vào trang chủ người dùng / hoặc quay lại trang đăng nhập nếu yêu cầu chỉ cho admin đăng nhập quản trị
            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/home");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }
        } else {
            // Đăng nhập thất bại: quay lại trang đăng nhập và hiển thị thông báo lỗi
            req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác, hoặc tài khoản chưa được kích hoạt!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/web/login.jsp").forward(req, resp);
        }
    }
}

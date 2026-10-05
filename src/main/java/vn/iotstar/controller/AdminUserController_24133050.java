package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.iotstar.entity.User_24133050;
import vn.iotstar.service.IUserService_24133050;
import vn.iotstar.service.impl.UserServiceImpl_24133050;
import vn.iotstar.utils.Constant_24133050;

@WebServlet(urlPatterns = { "/admin/users", "/admin/user/add", "/admin/user/edit", "/admin/user/delete", "/admin/user/view" })
public class AdminUserController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService_24133050 userService = new UserServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) {
            return;
        }

        String path = req.getServletPath();

        switch (path) {
        case "/admin/user/add":
            req.getRequestDispatcher("/views/admin/user-add.jsp").forward(req, resp);
            break;

        case "/admin/user/edit":
            showEditForm(req, resp);
            break;

        case "/admin/user/view":
            showViewDetails(req, resp);
            break;

        case "/admin/user/delete":
            deleteUser(req, resp);
            break;

        case "/admin/users":
        default:
            listUsers(req, resp);
            break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        if (!checkAdmin(req, resp)) {
            return;
        }

        String path = req.getServletPath();

        if ("/admin/user/add".equals(path)) {
            createUser(req, resp);
        } else if ("/admin/user/edit".equals(path)) {
            updateUser(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }

    /**
     * Câu 3: Quản trị CRUD có phân trang 6 user trên 01 trang
     */
    private void listUsers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        int pageSize = Constant_24133050.USER_PAGE_SIZE; // 6 user / trang
        int totalUsers = userService.countAll();
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<User_24133050> userList = userService.findAll(page, pageSize);

        req.setAttribute("userList", userList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalUsers", totalUsers);

        // Hiển thị thông báo nếu có
        String msg = req.getParameter("message");
        if ("create_success".equals(msg)) {
            req.setAttribute("success", "Thêm người dùng mới thành công!");
        } else if ("update_success".equals(msg)) {
            req.setAttribute("success", "Cập nhật người dùng thành công!");
        } else if ("delete_success".equals(msg)) {
            req.setAttribute("success", "Xóa người dùng thành công!");
        }

        req.getRequestDispatcher("/views/admin/user-list.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        if (username != null && !username.trim().isEmpty()) {
            User_24133050 user = userService.findByUsername(username.trim());
            if (user != null) {
                req.setAttribute("userItem", user);
                req.getRequestDispatcher("/views/admin/user-edit.jsp").forward(req, resp);
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void showViewDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        if (username != null && !username.trim().isEmpty()) {
            User_24133050 user = userService.findByUsername(username.trim());
            if (user != null) {
                req.setAttribute("viewUser", user);
            }
        }
        listUsers(req, resp);
    }

    private void createUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String images = req.getParameter("images");
        boolean admin = "true".equalsIgnoreCase(req.getParameter("admin")) || "on".equalsIgnoreCase(req.getParameter("admin")) || "1".equals(req.getParameter("admin"));
        boolean active = "true".equalsIgnoreCase(req.getParameter("active")) || "on".equalsIgnoreCase(req.getParameter("active")) || "1".equals(req.getParameter("active"));

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Tên đăng nhập và mật khẩu không được để trống!");
            req.getRequestDispatcher("/views/admin/user-add.jsp").forward(req, resp);
            return;
        }

        if (userService.checkExistUsername(username.trim())) {
            req.setAttribute("error", "Tên đăng nhập '" + username + "' đã tồn tại!");
            req.getRequestDispatcher("/views/admin/user-add.jsp").forward(req, resp);
            return;
        }

        if (images == null || images.trim().isEmpty()) {
            images = "default-avatar.png";
        }

        User_24133050 newUser = new User_24133050(username.trim(), password.trim(), phone, fullname, email, admin, active, images.trim());
        userService.insert(newUser);

        resp.sendRedirect(req.getContextPath() + "/admin/users?message=create_success");
    }

    private void updateUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String images = req.getParameter("images");
        boolean admin = "true".equalsIgnoreCase(req.getParameter("admin")) || "on".equalsIgnoreCase(req.getParameter("admin")) || "1".equals(req.getParameter("admin"));
        boolean active = "true".equalsIgnoreCase(req.getParameter("active")) || "on".equalsIgnoreCase(req.getParameter("active")) || "1".equals(req.getParameter("active"));

        User_24133050 existingUser = userService.findByUsername(username);
        if (existingUser != null) {
            existingUser.setFullname(fullname);
            existingUser.setEmail(email);
            existingUser.setPhone(phone);
            existingUser.setAdmin(admin);
            existingUser.setActive(active);
            if (images != null && !images.trim().isEmpty()) {
                existingUser.setImages(images.trim());
            }
            if (password != null && !password.trim().isEmpty()) {
                existingUser.setPassword(password.trim());
            }
            userService.update(existingUser);
            resp.sendRedirect(req.getContextPath() + "/admin/users?message=update_success");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }

    private void deleteUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String page = req.getParameter("page");
        if (username != null && !username.trim().isEmpty()) {
            userService.delete(username.trim());
            String redirectUrl = req.getContextPath() + "/admin/users?message=delete_success";
            if (page != null && !page.trim().isEmpty()) {
                redirectUrl += "&page=" + page.trim();
            }
            resp.sendRedirect(redirectUrl);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }

    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        User_24133050 user = (User_24133050) session.getAttribute("user");
        if (!user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}

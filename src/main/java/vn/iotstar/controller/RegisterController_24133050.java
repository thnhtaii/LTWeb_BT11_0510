package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.iotstar.entity.User_24133050;
import vn.iotstar.service.IEmailService_24133050;
import vn.iotstar.service.IUserService_24133050;
import vn.iotstar.service.impl.EmailServiceImpl_24133050;
import vn.iotstar.service.impl.UserServiceImpl_24133050;

@WebServlet(urlPatterns = { "/register", "/dang-ky" })
public class RegisterController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService_24133050 userService = new UserServiceImpl_24133050();
    private IEmailService_24133050 emailService = new EmailServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String rePassword = req.getParameter("repassword");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        // Giữ lại dữ liệu form khi có lỗi
        req.setAttribute("username", username);
        req.setAttribute("fullname", fullname);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ các thông tin bắt buộc!");
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(rePassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        if (userService.checkExistUsername(username.trim())) {
            req.setAttribute("error", "Tên đăng nhập '" + username + "' đã được sử dụng!");
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        if (userService.checkExistEmail(email.trim())) {
            req.setAttribute("error", "Địa chỉ email '" + email + "' đã tồn tại!");
            req.getRequestDispatcher("/views/web/register.jsp").forward(req, resp);
            return;
        }

        // Tạo tài khoản tạm thời (chưa kích hoạt active = false)
        User_24133050 pendingUser = new User_24133050();
        pendingUser.setUsername(username.trim());
        pendingUser.setPassword(password.trim());
        pendingUser.setFullname(fullname != null ? fullname.trim() : "");
        pendingUser.setEmail(email.trim());
        pendingUser.setPhone(phone != null ? phone.trim() : "");
        pendingUser.setAdmin(false);
        pendingUser.setActive(false);
        pendingUser.setImages("default-avatar.png");

        // Sinh mã OTP 6 số ngẫu nhiên
        String otp = emailService.generateOtp();

        // Lưu thông tin vào Session để kiểm tra xác thực ở bước sau
        HttpSession session = req.getSession(true);
        session.setAttribute("pendingUser", pendingUser);
        session.setAttribute("otpCode", otp);
        session.setAttribute("otpTime", System.currentTimeMillis());

        // Gửi mã OTP qua email (và in ra console cho tester)
        emailService.sendOtpEmail(email.trim(), otp, "Mã kích hoạt tài khoản KT_QT (24133050)", "Đăng ký tài khoản");

        // Chuyển sang trang nhập OTP
        resp.sendRedirect(req.getContextPath() + "/verify-otp");
    }
}

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
import vn.iotstar.utils.Constant_24133050;

@WebServlet(urlPatterns = { "/verify-otp", "/kich-hoat" })
public class VerifyOtpController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService_24133050 userService = new UserServiceImpl_24133050();
    private IEmailService_24133050 emailService = new EmailServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("pendingUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        // Hỗ trợ nút gửi lại mã OTP
        String action = req.getParameter("action");
        if ("resend".equalsIgnoreCase(action)) {
            User_24133050 pending = (User_24133050) session.getAttribute("pendingUser");
            String newOtp = emailService.generateOtp();
            session.setAttribute("otpCode", newOtp);
            session.setAttribute("otpTime", System.currentTimeMillis());
            emailService.sendOtpEmail(pending.getEmail(), newOtp, "Gửi lại mã OTP kích hoạt tài khoản", "Kích hoạt tài khoản");
            req.setAttribute("info", "Mã OTP mới đã được gửi tới email: " + pending.getEmail());
        }

        req.getRequestDispatcher("/views/web/verify-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("pendingUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        String inputOtp = req.getParameter("otp");
        String sessionOtp = (String) session.getAttribute("otpCode");
        Long otpTime = (Long) session.getAttribute("otpTime");
        User_24133050 pendingUser = (User_24133050) session.getAttribute("pendingUser");

        if (inputOtp == null || inputOtp.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập mã OTP!");
            req.getRequestDispatcher("/views/web/verify-otp.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra thời hạn OTP (mặc định 5 phút)
        long currentTime = System.currentTimeMillis();
        long diffMinutes = (currentTime - (otpTime != null ? otpTime : 0)) / (1000 * 60);

        if (diffMinutes > Constant_24133050.OTP_EXPIRY_MINUTES) {
            req.setAttribute("error", "Mã OTP đã hết hiệu lực (" + Constant_24133050.OTP_EXPIRY_MINUTES + " phút). Vui lòng nhấn gửi lại mã!");
            req.getRequestDispatcher("/views/web/verify-otp.jsp").forward(req, resp);
            return;
        }

        if (sessionOtp != null && sessionOtp.trim().equals(inputOtp.trim())) {
            // Xác thực thành công: Kích hoạt tài khoản và lưu vào CSDL
            pendingUser.setActive(true);
            userService.insert(pendingUser);

            // Dọn dẹp session tạm thời
            session.removeAttribute("pendingUser");
            session.removeAttribute("otpCode");
            session.removeAttribute("otpTime");

            resp.sendRedirect(req.getContextPath() + "/login?message=register_success");
        } else {
            req.setAttribute("error", "Mã OTP không chính xác. Vui lòng kiểm tra lại!");
            req.getRequestDispatcher("/views/web/verify-otp.jsp").forward(req, resp);
        }
    }
}

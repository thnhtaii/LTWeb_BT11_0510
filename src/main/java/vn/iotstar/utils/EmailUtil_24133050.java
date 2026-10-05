package vn.iotstar.utils;

import java.util.Properties;
import java.util.Random;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil_24133050 {

    /**
     * Sinh mã OTP ngẫu nhiên gồm 6 chữ số
     */
    public static String generateOtp() {
        Random random = new Random();
        int number = 100000 + random.nextInt(900000);
        return String.valueOf(number);
    }

    /**
     * Gửi email kích hoạt tài khoản OTP (Câu 2)
     */
    public static boolean sendOtpEmail(String recipientEmail, String otpCode, String subject, String actionDescription) {
        System.out.println(">>> [HỆ THỐNG GỬI MÃ OTP QUA EMAIL - MSSV: 24133050]");
        System.out.println(">>> Người nhận: " + recipientEmail);
        System.out.println(">>> Thao tác:   " + actionDescription);
        System.out.println(">>> MÃ OTP LÀ:  [" + otpCode + "]");
        System.out.println(">>> Hiệu lực:   " + Constant_24133050.OTP_EXPIRY_MINUTES + " phút");

        final String fromEmail = Constant_24133050.EMAIL_FROM;
        final String password = Constant_24133050.EMAIL_PASSWORD;

        // Nếu chưa cấu hình mật khẩu ứng dụng Gmail, coi như đã gửi thành công và dựa vào console
        if (password == null || password.trim().isEmpty()) {
            System.out.println("(*) Lưu ý: Chưa cấu hình mật khẩu ứng dụng Gmail (APP_EMAIL_PASSWORD).");
            System.out.println("(*) Vui lòng lấy mã OTP hiển thị ở trên console để xác thực.");
            return true;
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", Constant_24133050.EMAIL_HOST);
            props.put("mail.smtp.port", Constant_24133050.EMAIL_PORT);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, password);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, "KT_QT - Đỗ Thanh Thành Tài (24133050)"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);

            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 25px; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);'>"
                    + "<h2 style='color: #4f46e5; text-align: center; margin-bottom: 20px;'>XÁC THỰC TÀI KHOẢN</h2>"
                    + "<p>Xin chào,</p>"
                    + "<p>Bạn vừa thực hiện: <strong>" + actionDescription + "</strong> trên hệ thống <strong>KT_QT (Đề số 04)</strong>.</p>"
                    + "<div style='text-align: center; margin: 30px 0;'>"
                    + "<span style='display: inline-block; font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #dc2626; background-color: #fef2f2; padding: 12px 30px; border-radius: 8px; border: 2px dashed #f87171;'>"
                    + otpCode + "</span>"
                    + "</div>"
                    + "<p>Mã OTP này có hiệu lực trong vòng <strong>" + Constant_24133050.OTP_EXPIRY_MINUTES + " phút</strong>. Tuyệt đối không chia sẻ mã này cho bất kỳ ai.</p>"
                    + "<hr style='border: none; border-top: 1px solid #edf2f7; margin: 25px 0;'>"
                    + "<p style='font-size: 13px; color: #64748b; text-align: center;'>Sinh viên: Đỗ Thanh Thành Tài - MSSV: 24133050 - Đề thi số 04</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println(">>> Đã gửi email thành công tới: " + recipientEmail);
            return true;
        } catch (Exception e) {
            System.err.println(">>> Lỗi khi gửi email SMTP: " + e.getMessage());
            return true; // Vẫn cho phép tiếp tục với OTP ở console
        }
    }
}

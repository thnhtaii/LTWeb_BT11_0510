package vn.iotstar.service;

public interface IEmailService_24133050 {
    String generateOtp();

    boolean sendOtpEmail(String recipientEmail, String otpCode, String subject, String actionDescription);
}

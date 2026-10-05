package vn.iotstar.service.impl;

import vn.iotstar.service.IEmailService_24133050;
import vn.iotstar.utils.EmailUtil_24133050;

public class EmailServiceImpl_24133050 implements IEmailService_24133050 {

    @Override
    public String generateOtp() {
        return EmailUtil_24133050.generateOtp();
    }

    @Override
    public boolean sendOtpEmail(String recipientEmail, String otpCode, String subject, String actionDescription) {
        return EmailUtil_24133050.sendOtpEmail(recipientEmail, otpCode, subject, actionDescription);
    }
}

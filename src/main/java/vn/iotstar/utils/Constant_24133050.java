package vn.iotstar.utils;

import java.io.File;

public class Constant_24133050 {

    // Thư mục lưu trữ hình ảnh tải lên của project KT_QT
    public static final String UPLOAD_DIR = "c:\\Users\\dotai\\Documents\\workspace-spring-tools-for-eclipse-5.3.0.RELEASE\\KT_QT\\uploads";
    public static final String DIR = UPLOAD_DIR;

    // Cấu hình phân trang theo yêu cầu đề thi
    public static final int USER_PAGE_SIZE = 6;   // Câu 3: phân trang 6 user trên 01 trang
    public static final int VIDEO_PAGE_SIZE = 3;  // Câu 5: phân trang 3 video trên 01 trang
    public static final int OTP_EXPIRY_MINUTES = 5;

    // Cấu hình gửi mail SMTP
    public static final String EMAIL_HOST = "smtp.gmail.com";
    public static final String EMAIL_PORT = "587";
    public static final String EMAIL_FROM = System.getProperty("APP_EMAIL_FROM", "dotai22092006@gmail.com");
    public static final String EMAIL_PASSWORD = System.getProperty("APP_EMAIL_PASSWORD", "");

    // Thông tin sinh viên & đề thi (hiển thị Footer - Câu 1)
    public static final String STUDENT_NAME = "Đỗ Thanh Thành Tài";
    public static final String STUDENT_ID = "24133050";
    public static final String EXAM_CODE = "Đề số 04";

    static {
        File dir = new File(UPLOAD_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }
}

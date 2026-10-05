package vn.iotstar.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.iotstar.utils.Constant_24133050;

@WebServlet(urlPatterns = { "/image", "/images" })
public class ImageController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fileName = req.getParameter("fname");
        if (fileName == null || fileName.trim().isEmpty()) {
            fileName = "default.png";
        }

        File file = new File(Constant_24133050.UPLOAD_DIR, fileName);

        if (file.exists() && file.isFile()) {
            if (fileName.toLowerCase().endsWith(".jpg") || fileName.toLowerCase().endsWith(".jpeg")) {
                resp.setContentType("image/jpeg");
            } else if (fileName.toLowerCase().endsWith(".png")) {
                resp.setContentType("image/png");
            } else if (fileName.toLowerCase().endsWith(".gif")) {
                resp.setContentType("image/gif");
            } else {
                resp.setContentType("application/octet-stream");
            }

            try (FileInputStream fis = new FileInputStream(file);
                 OutputStream os = resp.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
            }
        } else {
            // Nếu file ảnh chưa có trên ổ đĩa, trả về ảnh SVG placeholder đẹp mắt
            resp.setContentType("image/svg+xml;charset=UTF-8");
            String title = fileName.replace(".jpg", "").replace(".png", "");
            String svg = "<svg xmlns='http://www.w3.org/2000/svg' width='400' height='260' viewBox='0 0 400 260'>"
                       + "<defs>"
                       + "<linearGradient id='grad' x1='0%' y1='0%' x2='100%' y2='100%'>"
                       + "<stop offset='0%' style='stop-color:#3b82f6;stop-opacity:1' />"
                       + "<stop offset='100%' style='stop-color:#1d4ed8;stop-opacity:1' />"
                       + "</linearGradient>"
                       + "</defs>"
                       + "<rect width='100%' height='100%' fill='url(#grad)' rx='8'/>"
                       + "<circle cx='200' cy='110' r='36' fill='rgba(255,255,255,0.2)'/>"
                       + "<polygon points='190,95 220,110 190,125' fill='#ffffff'/>"
                       + "<text x='200' y='180' font-family='Arial, sans-serif' font-size='16' font-weight='bold' fill='#ffffff' text-anchor='middle'>" + title + "</text>"
                       + "<text x='200' y='210' font-family='Arial, sans-serif' font-size='12' fill='rgba(255,255,255,0.8)' text-anchor='middle'>KT_QT - 24133050</text>"
                       + "</svg>";
            resp.getWriter().write(svg);
        }
    }
}

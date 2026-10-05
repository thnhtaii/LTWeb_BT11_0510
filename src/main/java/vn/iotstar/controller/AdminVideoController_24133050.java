package vn.iotstar.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category_24133050;
import vn.iotstar.entity.User_24133050;
import vn.iotstar.entity.Video_24133050;
import vn.iotstar.service.ICategoryService_24133050;
import vn.iotstar.service.IVideoService_24133050;
import vn.iotstar.service.impl.CategoryServiceImpl_24133050;
import vn.iotstar.service.impl.VideoServiceImpl_24133050;
import vn.iotstar.utils.Constant_24133050;

@WebServlet(urlPatterns = { "/admin/videos", "/admin/video/add", "/admin/video/edit" })
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class AdminVideoController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int PAGE_SIZE = 6;
    private final IVideoService_24133050 videoService = new VideoServiceImpl_24133050();
    private final ICategoryService_24133050 categoryService = new CategoryServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) {
            return;
        }
        if ("/admin/videos".equals(req.getServletPath())) {
            int totalVideos = videoService.countForAdmin();
            int totalPages = Math.max(1, (int) Math.ceil((double) totalVideos / PAGE_SIZE));
            int page = Math.min(totalPages, positiveInteger(req.getParameter("page"), 1));
            req.setAttribute("videoList", videoService.findAllForAdmin(page, PAGE_SIZE));
            req.setAttribute("totalVideos", totalVideos);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("currentPage", page);
            req.getRequestDispatcher("/views/admin/video-list.jsp").forward(req, resp);
            return;
        }
        boolean editing = "/admin/video/edit".equals(req.getServletPath());
        Video_24133050 video = editing ? videoService.findById(text(req, "id")) : new Video_24133050();
        if (video == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        if (!editing) {
            video.setActive(true);
            video.setPrice(new BigDecimal("50000"));
        }
        showForm(req, resp, video, editing);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if (!checkAdmin(req, resp)) {
            return;
        }
        boolean editing = "/admin/video/edit".equals(req.getServletPath());
        if (!editing && !"/admin/video/add".equals(req.getServletPath())) {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }
        Video_24133050 video = new Video_24133050();
        Path uploadedPoster = null;
        try {
            video.setVideoId(text(req, "videoId"));
            video.setTitle(text(req, "title"));
            video.setDescription(text(req, "description"));
            video.setPoster(text(req, "poster"));
            video.setCategoryId(positiveInteger(req.getParameter("categoryId"), 0));
            video.setActive("true".equals(req.getParameter("active")));
            req.setAttribute("priceInput", req.getParameter("price"));
            Video_24133050 existing = videoService.findById(video.getVideoId());
            if (editing && existing == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            if (!editing && existing != null) {
                throw new IllegalArgumentException("Mã video đã tồn tại.");
            }
            validate(video, req.getParameter("price"));

            Part posterPart = req.getContentType() != null
                    && req.getContentType().toLowerCase(Locale.ROOT).startsWith("multipart/form-data")
                    ? req.getPart("posterFile") : null;
            if (posterPart != null && posterPart.getSize() > 0) {
                uploadedPoster = savePoster(posterPart);
                video.setPoster(uploadedPoster.getFileName().toString());
            } else {
                validateExistingPoster(video, existing);
            }
            if (editing) {
                videoService.update(video);
            } else {
                videoService.insert(video);
            }
            uploadedPoster = null;
            resp.sendRedirect(req.getContextPath() + "/admin/videos?message="
                    + (editing ? "update_success" : "create_success"));
        } catch (IllegalArgumentException ex) {
            discardUpload(uploadedPoster);
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            req.setAttribute("error", ex.getMessage());
            showForm(req, resp, video, editing);
        } catch (IllegalStateException ex) {
            discardUpload(uploadedPoster);
            log("Cannot save admin video", ex);
            resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            req.setAttribute("error", "Không thể lưu video. Kiểm tra dữ liệu, kết nối SQL Server hoặc dung lượng poster (tối đa 5 MB).");
            showForm(req, resp, video, editing);
        } catch (IOException | ServletException ex) {
            discardUpload(uploadedPoster);
            throw ex;
        }
    }

    private void validate(Video_24133050 video, String rawPrice) {
        if (!video.getVideoId().matches("[A-Za-z0-9_-]{1,50}")) {
            throw new IllegalArgumentException("Mã video gồm 1–50 chữ cái, chữ số, dấu gạch dưới hoặc gạch ngang.");
        }
        if (video.getTitle().isEmpty() || video.getTitle().length() > 200) {
            throw new IllegalArgumentException("Tiêu đề không được để trống và tối đa 200 ký tự.");
        }
        if (video.getDescription().length() > 500) {
            throw new IllegalArgumentException("Mô tả tối đa 500 ký tự.");
        }
        if (video.getCategoryId() == 0 || categoryService.findById(video.getCategoryId()) == null) {
            throw new IllegalArgumentException("Vui lòng chọn danh mục hợp lệ.");
        }
        try {
            BigDecimal price = new BigDecimal(rawPrice == null ? "" : rawPrice.trim()).setScale(0, RoundingMode.UNNECESSARY);
            if (price.signum() < 0 || price.compareTo(new BigDecimal("999999999999999999")) > 0) {
                throw new ArithmeticException();
            }
            video.setPrice(price);
        } catch (NumberFormatException | ArithmeticException ex) {
            throw new IllegalArgumentException("Giá bán phải là số nguyên không âm và tối đa 18 chữ số.");
        }
    }

    private void validateExistingPoster(Video_24133050 video, Video_24133050 existing) {
        String poster = video.getPoster();
        if (poster.isEmpty()) {
            video.setPoster(existing != null ? existing.getPoster() : "default.png");
            return;
        }
        if (poster.length() > 50 || poster.contains("/") || poster.contains("\\") || poster.equals(".") || poster.equals("..")) {
            throw new IllegalArgumentException("Tên file poster không hợp lệ.");
        }
        if (!"default.png".equals(poster) && !(existing != null && poster.equals(existing.getPoster()))
                && !Files.isRegularFile(Path.of(Constant_24133050.UPLOAD_DIR).resolve(poster))) {
            throw new IllegalArgumentException("File poster chưa tồn tại. Vui lòng chọn ảnh để tải lên.");
        }
    }

    private Path savePoster(Part part) throws IOException {
        String extension;
        try (var source = part.getInputStream(); ImageInputStream input = ImageIO.createImageInputStream(source)) {
            Iterator<ImageReader> readers = ImageIO.getImageReaders(input);
            if (!readers.hasNext()) {
                throw new IllegalArgumentException("Poster phải là ảnh JPG, PNG hoặc GIF hợp lệ.");
            }
            ImageReader reader = readers.next();
            try {
                reader.setInput(input);
                extension = reader.getFormatName().toLowerCase(Locale.ROOT);
                if ("jpeg".equals(extension)) {
                    extension = "jpg";
                }
                if (!List.of("jpg", "png", "gif").contains(extension)
                        || (long) reader.getWidth(0) * reader.getHeight(0) > 16000000) {
                    throw new IllegalArgumentException("Poster phải là ảnh JPG, PNG hoặc GIF, tối đa 16 triệu điểm ảnh.");
                }
                reader.read(0);
            } finally {
                reader.dispose();
            }
        }
        catch (javax.imageio.IIOException ex) {
            throw new IllegalArgumentException("Không thể đọc poster. Vui lòng chọn ảnh hợp lệ.", ex);
        }
        Path directory = Path.of(Constant_24133050.UPLOAD_DIR);
        Files.createDirectories(directory);
        Path file = directory.resolve(UUID.randomUUID().toString().replace("-", "") + "." + extension);
        try (var input = part.getInputStream()) {
            Files.write(file, input.readAllBytes(), StandardOpenOption.CREATE_NEW);
        }
        return file;
    }

    private void discardUpload(Path file) throws IOException {
        if (file != null) {
            Files.deleteIfExists(file);
        }
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, Video_24133050 video, boolean editing)
            throws ServletException, IOException {
        List<Category_24133050> categories = categoryService.findAll();
        req.setAttribute("categories", categories);
        req.setAttribute("videoItem", video);
        req.setAttribute("editing", editing);
        req.getRequestDispatcher("/views/admin/video-form.jsp").forward(req, resp);
    }

    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        if (!((User_24133050) session.getAttribute("user")).isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        return true;
    }

    private String text(HttpServletRequest req, String name) {
        try {
            String value = req.getParameter(name);
            return value == null ? "" : value.trim();
        } catch (IllegalStateException ex) {
            throw new IllegalArgumentException("Không thể đọc dữ liệu tải lên. Poster tối đa 5 MB.", ex);
        }
    }

    private int positiveInteger(String rawValue, int fallback) {
        try {
            int value = Integer.parseInt(rawValue);
            return value > 0 ? value : fallback;
        } catch (NumberFormatException ex) {
            return fallback;
        }
    }
}

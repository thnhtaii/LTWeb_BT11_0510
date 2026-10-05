package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.Video_24133050;

public interface IVideoService_24133050 {
    // Câu 4: Xem chi tiết 01 video
    Video_24133050 findById(String videoId);

    void increaseViews(String videoId);

    // Câu 5: Hiển thị tất cả video theo từng category có phân trang 3 video/trang
    List<Video_24133050> findByCategoryId(int categoryId, int page, int pageSize);

    int countByCategoryId(int categoryId);

    List<Video_24133050> findAll(int page, int pageSize);

    int countAll();

    List<Video_24133050> findAllForAdmin(int page, int pageSize);

    int countForAdmin();

    int countLikes(String videoId);

    int countShares(String videoId);

    void insert(Video_24133050 video);

    void update(Video_24133050 video);

    void delete(String videoId);
}

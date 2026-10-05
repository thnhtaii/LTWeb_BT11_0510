package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.Category_24133050;

public interface ICategoryDao_24133050 {
    List<Category_24133050> findAll();

    // Câu 6: Đếm số lượng video theo từng Category hiển thị ở Câu 5
    List<Category_24133050> findAllWithVideoCount();

    Category_24133050 findById(int categoryId);

    void insert(Category_24133050 category);

    void update(Category_24133050 category);

    void delete(int categoryId);
}

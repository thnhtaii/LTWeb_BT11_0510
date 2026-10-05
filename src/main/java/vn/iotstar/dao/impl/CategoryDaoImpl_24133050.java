package vn.iotstar.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import vn.iotstar.connection.DBConnection_24133050;
import vn.iotstar.dao.ICategoryDao_24133050;
import vn.iotstar.entity.Category_24133050;

public class CategoryDaoImpl_24133050 extends DBConnection_24133050 implements ICategoryDao_24133050 {

    @Override
    public List<Category_24133050> findAll() {
        List<Category_24133050> list = new ArrayList<>();
        String sql = "SELECT * FROM Category ORDER BY CategoryId ASC";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapCategory(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Category_24133050> findAllWithVideoCount() {
        List<Category_24133050> list = new ArrayList<>();
        // Câu 6: Đếm số lượng Video theo từng Category
        String sql = "SELECT c.CategoryId, c.Categoryname, c.Categorycode, c.Images, c.Status, "
                   + "       COUNT(v.VideoId) AS VideoCount "
                   + "FROM Category c "
                   + "LEFT JOIN Videos v ON c.CategoryId = v.CategoryId "
                   + "GROUP BY c.CategoryId, c.Categoryname, c.Categorycode, c.Images, c.Status "
                   + "ORDER BY c.CategoryId ASC";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category_24133050 cat = mapCategory(rs);
                cat.setVideoCount(rs.getInt("VideoCount"));
                list.add(cat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Category_24133050 findById(int categoryId) {
        String sql = "SELECT * FROM Category WHERE CategoryId = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCategory(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void insert(Category_24133050 category) {
        String sql = "INSERT INTO Category (Categoryname, Categorycode, Images, Status) VALUES (?, ?, ?, ?)";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryname());
            ps.setString(2, category.getCategorycode());
            ps.setString(3, category.getImages());
            ps.setBoolean(4, category.isStatus());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(Category_24133050 category) {
        String sql = "UPDATE Category SET Categoryname = ?, Categorycode = ?, Images = ?, Status = ? WHERE CategoryId = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryname());
            ps.setString(2, category.getCategorycode());
            ps.setString(3, category.getImages());
            ps.setBoolean(4, category.isStatus());
            ps.setInt(5, category.getCategoryId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int categoryId) {
        String sql = "DELETE FROM Category WHERE CategoryId = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Category_24133050 mapCategory(ResultSet rs) throws Exception {
        Category_24133050 cat = new Category_24133050();
        cat.setCategoryId(rs.getInt("CategoryId"));
        cat.setCategoryname(rs.getString("Categoryname"));
        cat.setCategorycode(rs.getString("Categorycode"));
        cat.setImages(rs.getString("Images"));
        cat.setStatus(rs.getBoolean("Status"));
        return cat;
    }
}

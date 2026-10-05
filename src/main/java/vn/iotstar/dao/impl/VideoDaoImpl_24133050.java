package vn.iotstar.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import vn.iotstar.connection.DBConnection_24133050;
import vn.iotstar.dao.IVideoDao_24133050;
import vn.iotstar.entity.Video_24133050;

public class VideoDaoImpl_24133050 extends DBConnection_24133050 implements IVideoDao_24133050 {

    private static final String BASE_SELECT = 
        "SELECT v.VideoId, v.Title, v.Poster, v.Views, v.Description, v.Active, v.CategoryId, v.Price, " +
        "       c.Categoryname, " +
        "       (SELECT COUNT(*) FROM Favorites f WHERE f.VideoId = v.VideoId) AS LikeCount, " +
        "       (SELECT COUNT(*) FROM Shares s WHERE s.VideoId = v.VideoId) AS ShareCount " +
        "FROM Videos v " +
        "LEFT JOIN Category c ON v.CategoryId = c.CategoryId ";

    @Override
    public Video_24133050 findById(String videoId) {
        String sql = BASE_SELECT + "WHERE v.VideoId = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, videoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapVideo(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void increaseViews(String videoId) {
        String sql = "UPDATE Videos SET Views = Views + 1 WHERE VideoId = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, videoId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Video_24133050> findByCategoryId(int categoryId, int page, int pageSize) {
        List<Video_24133050> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        // Phân trang 3 video trên 1 trang theo categoryId (Câu 5)
        String sql = BASE_SELECT + "WHERE v.CategoryId = ? AND v.Active = 1 " +
                     "ORDER BY v.VideoId ASC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapVideo(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countByCategoryId(int categoryId) {
        String sql = "SELECT COUNT(*) FROM Videos WHERE CategoryId = ? AND Active = 1";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Video_24133050> findAll(int page, int pageSize) {
        List<Video_24133050> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = BASE_SELECT + "WHERE v.Active = 1 " +
                     "ORDER BY v.VideoId ASC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapVideo(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM Videos WHERE Active = 1";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int countLikes(String videoId) {
        String sql = "SELECT COUNT(*) FROM Favorites WHERE VideoId = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, videoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int countShares(String videoId) {
        String sql = "SELECT COUNT(*) FROM Shares WHERE VideoId = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, videoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public void insert(Video_24133050 video) {
        String sql = "INSERT INTO Videos (VideoId, Title, Poster, Views, Description, Active, CategoryId, Price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, video.getVideoId());
            ps.setString(2, video.getTitle());
            ps.setString(3, video.getPoster());
            ps.setInt(4, video.getViews());
            ps.setString(5, video.getDescription());
            ps.setBoolean(6, video.isActive());
            if (video.getCategoryId() > 0) {
                ps.setInt(7, video.getCategoryId());
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
            ps.setBigDecimal(8, video.getPrice());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(Video_24133050 video) {
        String sql = "UPDATE Videos SET Title = ?, Poster = ?, Description = ?, Active = ?, CategoryId = ?, Price = ? WHERE VideoId = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, video.getTitle());
            ps.setString(2, video.getPoster());
            ps.setString(3, video.getDescription());
            ps.setBoolean(4, video.isActive());
            if (video.getCategoryId() > 0) {
                ps.setInt(5, video.getCategoryId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            ps.setBigDecimal(6, video.getPrice());
            ps.setString(7, video.getVideoId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(String videoId) {
        String sql = "DELETE FROM Videos WHERE VideoId = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, videoId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Video_24133050 mapVideo(ResultSet rs) throws Exception {
        Video_24133050 v = new Video_24133050();
        v.setVideoId(rs.getString("VideoId"));
        v.setTitle(rs.getString("Title"));
        v.setPoster(rs.getString("Poster"));
        v.setViews(rs.getInt("Views"));
        v.setDescription(rs.getString("Description"));
        v.setActive(rs.getBoolean("Active"));
        v.setCategoryId(rs.getInt("CategoryId"));
        v.setPrice(rs.getBigDecimal("Price"));
        v.setCategoryName(rs.getString("Categoryname"));
        v.setLikeCount(rs.getInt("LikeCount"));
        v.setShareCount(rs.getInt("ShareCount"));
        return v;
    }
}

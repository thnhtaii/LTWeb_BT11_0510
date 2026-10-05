package vn.iotstar.dao.impl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import vn.iotstar.connection.DBConnection_24133050;
import vn.iotstar.dao.ICartDao_24133050;
import vn.iotstar.entity.CartItem_24133050;

public class CartDaoImpl_24133050 extends DBConnection_24133050 implements ICartDao_24133050 {

    private static final String CART_SELECT = "SELECT c.CartId, c.Username, c.VideoId, c.Quantity, "
            + "v.Title, v.Poster, v.Price "
            + "FROM Carts c INNER JOIN Videos v ON c.VideoId = v.VideoId "
            + "WHERE c.Username = ? ORDER BY c.CartId DESC";

    @Override
    public List<CartItem_24133050> findByUsername(String username) {
        List<CartItem_24133050> list = new ArrayList<>();
        try (Connection con = super.getConnection();
                PreparedStatement ps = con.prepareStatement(CART_SELECT)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapCartItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void addItem(String username, String videoId, int quantity) {
        int safeQuantity = clampQuantity(quantity);
        String sql = "IF EXISTS (SELECT 1 FROM Carts WHERE Username = ? AND VideoId = ?) "
                + "BEGIN UPDATE Carts SET Quantity = CASE WHEN Quantity + ? > ? THEN ? ELSE Quantity + ? END "
                + "WHERE Username = ? AND VideoId = ? END "
                + "ELSE BEGIN INSERT INTO Carts (Username, VideoId, Quantity) VALUES (?, ?, ?) END";
        try (Connection con = super.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, videoId);
            ps.setInt(3, safeQuantity);
            ps.setInt(4, MAX_QUANTITY);
            ps.setInt(5, MAX_QUANTITY);
            ps.setInt(6, safeQuantity);
            ps.setString(7, username);
            ps.setString(8, videoId);
            ps.setString(9, username);
            ps.setString(10, videoId);
            ps.setInt(11, safeQuantity);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateQuantity(String username, String videoId, int quantity) {
        int safeQuantity = clampQuantity(quantity);
        String sql = "UPDATE Carts SET Quantity = ? WHERE Username = ? AND VideoId = ?";
        try (Connection con = super.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, safeQuantity);
            ps.setString(2, username);
            ps.setString(3, videoId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void removeItem(String username, String videoId) {
        String sql = "DELETE FROM Carts WHERE Username = ? AND VideoId = ?";
        try (Connection con = super.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, videoId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void clearCart(String username) {
        String sql = "DELETE FROM Carts WHERE Username = ?";
        try (Connection con = super.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public int countItems(String username) {
        String sql = "SELECT COALESCE(SUM(Quantity), 0) FROM Carts WHERE Username = ?";
        try (Connection con = super.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
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
    public BigDecimal calculateTotal(String username) {
        String sql = "SELECT COALESCE(SUM(c.Quantity * v.Price), 0) "
                + "FROM Carts c INNER JOIN Videos v ON c.VideoId = v.VideoId WHERE c.Username = ?";
        try (Connection con = super.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    private int clampQuantity(int quantity) {
        return Math.max(1, Math.min(MAX_QUANTITY, quantity));
    }

    private CartItem_24133050 mapCartItem(ResultSet rs) throws Exception {
        CartItem_24133050 item = new CartItem_24133050();
        item.setCartId(rs.getInt("CartId"));
        item.setUsername(rs.getString("Username"));
        item.setVideoId(rs.getString("VideoId"));
        item.setQuantity(rs.getInt("Quantity"));
        item.setTitle(rs.getString("Title"));
        item.setPoster(rs.getString("Poster"));
        item.setPrice(rs.getBigDecimal("Price"));
        return item;
    }
}

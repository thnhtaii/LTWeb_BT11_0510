package vn.iotstar.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import vn.iotstar.connection.DBConnection_24133050;
import vn.iotstar.dao.IOrderDao_24133050;
import vn.iotstar.entity.CartItem_24133050;
import vn.iotstar.entity.OrderItem_24133050;
import vn.iotstar.entity.OrderStatus_24133050;
import vn.iotstar.entity.Order_24133050;

public class OrderDaoImpl_24133050 extends DBConnection_24133050 implements IOrderDao_24133050 {

    @Override
    public int createOrderFromCart(Order_24133050 order, List<CartItem_24133050> cartItems) {
        if (cartItems == null || cartItems.isEmpty()) {
            return 0;
        }

        String insertOrder = "INSERT INTO Orders (Username, ReceiverName, ReceiverPhone, ReceiverAddress, Note, PaymentMethod, Status, TotalAmount) "
                + "VALUES (?, ?, ?, ?, ?, 'COD', 'NEW', ?)";
        String insertItem = "INSERT INTO OrderItems (OrderId, VideoId, Title, Poster, Price, Quantity) VALUES (?, ?, ?, ?, ?, ?)";
        String clearCart = "DELETE FROM Carts WHERE Username = ?";

        try (Connection con = super.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement orderPs = con.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS)) {
                orderPs.setString(1, order.getUsername());
                orderPs.setString(2, order.getReceiverName());
                orderPs.setString(3, order.getReceiverPhone());
                orderPs.setString(4, order.getReceiverAddress());
                orderPs.setString(5, order.getNote());
                orderPs.setBigDecimal(6, order.getTotalAmount());
                orderPs.executeUpdate();

                int orderId = 0;
                try (ResultSet keys = orderPs.getGeneratedKeys()) {
                    if (keys.next()) {
                        orderId = keys.getInt(1);
                    }
                }

                try (PreparedStatement itemPs = con.prepareStatement(insertItem)) {
                    for (CartItem_24133050 cartItem : cartItems) {
                        itemPs.setInt(1, orderId);
                        itemPs.setString(2, cartItem.getVideoId());
                        itemPs.setString(3, cartItem.getTitle());
                        itemPs.setString(4, cartItem.getPoster());
                        itemPs.setBigDecimal(5, cartItem.getPrice());
                        itemPs.setInt(6, cartItem.getQuantity());
                        itemPs.addBatch();
                    }
                    itemPs.executeBatch();
                }

                try (PreparedStatement clearPs = con.prepareStatement(clearCart)) {
                    clearPs.setString(1, order.getUsername());
                    clearPs.executeUpdate();
                }

                con.commit();
                return orderId;
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Order_24133050> findByUsername(String username, String status) {
        List<Order_24133050> orders = new ArrayList<>();
        boolean filterStatus = OrderStatus_24133050.isValid(status);
        String sql = "SELECT OrderId, Username, ReceiverName, ReceiverPhone, ReceiverAddress, Note, PaymentMethod, Status, TotalAmount, CreatedAt "
                + "FROM Orders WHERE Username = ? "
                + (filterStatus ? "AND Status = ? " : "")
                + "ORDER BY CreatedAt DESC, OrderId DESC";
        try (Connection con = super.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            if (filterStatus) {
                ps.setString(2, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order_24133050 order = mapOrder(rs);
                    order.setItems(findItemsByOrderId(con, order.getOrderId()));
                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    @Override
    public Order_24133050 findByIdForUser(int orderId, String username) {
        String sql = "SELECT OrderId, Username, ReceiverName, ReceiverPhone, ReceiverAddress, Note, PaymentMethod, Status, TotalAmount, CreatedAt "
                + "FROM Orders WHERE OrderId = ? AND Username = ?";
        try (Connection con = super.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setString(2, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order_24133050 order = mapOrder(rs);
                    order.setItems(findItemsByOrderId(con, order.getOrderId()));
                    return order;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private List<OrderItem_24133050> findItemsByOrderId(Connection con, int orderId) throws Exception {
        List<OrderItem_24133050> items = new ArrayList<>();
        String sql = "SELECT OrderItemId, OrderId, VideoId, Title, Poster, Price, Quantity FROM OrderItems WHERE OrderId = ? ORDER BY OrderItemId ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem_24133050 item = new OrderItem_24133050();
                    item.setOrderItemId(rs.getInt("OrderItemId"));
                    item.setOrderId(rs.getInt("OrderId"));
                    item.setVideoId(rs.getString("VideoId"));
                    item.setTitle(rs.getString("Title"));
                    item.setPoster(rs.getString("Poster"));
                    item.setPrice(rs.getBigDecimal("Price"));
                    item.setQuantity(rs.getInt("Quantity"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    private Order_24133050 mapOrder(ResultSet rs) throws Exception {
        Order_24133050 order = new Order_24133050();
        order.setOrderId(rs.getInt("OrderId"));
        order.setUsername(rs.getString("Username"));
        order.setReceiverName(rs.getString("ReceiverName"));
        order.setReceiverPhone(rs.getString("ReceiverPhone"));
        order.setReceiverAddress(rs.getString("ReceiverAddress"));
        order.setNote(rs.getString("Note"));
        order.setPaymentMethod(rs.getString("PaymentMethod"));
        order.setStatus(rs.getString("Status"));
        order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
        order.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return order;
    }
}

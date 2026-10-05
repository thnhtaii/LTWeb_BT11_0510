package vn.iotstar.dao;

import java.util.List;

import vn.iotstar.entity.CartItem_24133050;
import vn.iotstar.entity.Order_24133050;

public interface IOrderDao_24133050 {
    int createOrderFromCart(Order_24133050 order, List<CartItem_24133050> cartItems);

    List<Order_24133050> findByUsername(String username, String status);

    Order_24133050 findByIdForUser(int orderId, String username);
}

package vn.iotstar.service;

import java.math.BigDecimal;
import java.util.List;

import vn.iotstar.entity.CartItem_24133050;

public interface ICartService_24133050 {
    List<CartItem_24133050> findByUsername(String username);

    void addItem(String username, String videoId, int quantity);

    void updateQuantity(String username, String videoId, int quantity);

    void removeItem(String username, String videoId);

    void clearCart(String username);

    int countItems(String username);

    BigDecimal calculateTotal(String username);
}

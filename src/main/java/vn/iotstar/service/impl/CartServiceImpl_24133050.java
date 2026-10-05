package vn.iotstar.service.impl;

import java.math.BigDecimal;
import java.util.List;

import vn.iotstar.dao.ICartDao_24133050;
import vn.iotstar.dao.impl.CartDaoImpl_24133050;
import vn.iotstar.entity.CartItem_24133050;
import vn.iotstar.service.ICartService_24133050;

public class CartServiceImpl_24133050 implements ICartService_24133050 {

    private ICartDao_24133050 cartDao = new CartDaoImpl_24133050();

    @Override
    public List<CartItem_24133050> findByUsername(String username) {
        return cartDao.findByUsername(username);
    }

    @Override
    public void addItem(String username, String videoId, int quantity) {
        cartDao.addItem(username, videoId, quantity);
    }

    @Override
    public void updateQuantity(String username, String videoId, int quantity) {
        cartDao.updateQuantity(username, videoId, quantity);
    }

    @Override
    public void removeItem(String username, String videoId) {
        cartDao.removeItem(username, videoId);
    }

    @Override
    public void clearCart(String username) {
        cartDao.clearCart(username);
    }

    @Override
    public int countItems(String username) {
        return cartDao.countItems(username);
    }

    @Override
    public BigDecimal calculateTotal(String username) {
        return cartDao.calculateTotal(username);
    }
}

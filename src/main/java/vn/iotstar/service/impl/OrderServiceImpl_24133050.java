package vn.iotstar.service.impl;

import java.util.List;

import vn.iotstar.dao.IOrderDao_24133050;
import vn.iotstar.dao.impl.OrderDaoImpl_24133050;
import vn.iotstar.entity.CartItem_24133050;
import vn.iotstar.entity.Order_24133050;
import vn.iotstar.service.IOrderService_24133050;

public class OrderServiceImpl_24133050 implements IOrderService_24133050 {

    private IOrderDao_24133050 orderDao = new OrderDaoImpl_24133050();

    @Override
    public int createOrderFromCart(Order_24133050 order, List<CartItem_24133050> cartItems) {
        return orderDao.createOrderFromCart(order, cartItems);
    }

    @Override
    public List<Order_24133050> findByUsername(String username, String status) {
        return orderDao.findByUsername(username, status);
    }

    @Override
    public Order_24133050 findByIdForUser(int orderId, String username) {
        return orderDao.findByIdForUser(orderId, username);
    }
}

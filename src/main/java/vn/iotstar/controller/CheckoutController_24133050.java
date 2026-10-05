package vn.iotstar.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.CartItem_24133050;
import vn.iotstar.entity.Order_24133050;
import vn.iotstar.entity.User_24133050;
import vn.iotstar.service.ICartService_24133050;
import vn.iotstar.service.IOrderService_24133050;
import vn.iotstar.service.impl.CartServiceImpl_24133050;
import vn.iotstar.service.impl.OrderServiceImpl_24133050;

@WebServlet(urlPatterns = { "/checkout" })
public class CheckoutController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ICartService_24133050 cartService = new CartServiceImpl_24133050();
    private IOrderService_24133050 orderService = new OrderServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User_24133050 user = requireLogin(req, resp);
        if (user == null) {
            return;
        }
        List<CartItem_24133050> cartItems = cartService.findByUsername(user.getUsername());
        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?message=empty_cart");
            return;
        }
        req.setAttribute("cartItems", cartItems);
        req.setAttribute("cartTotal", cartService.calculateTotal(user.getUsername()));
        req.getRequestDispatcher("/views/web/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User_24133050 user = requireLogin(req, resp);
        if (user == null) {
            return;
        }

        List<CartItem_24133050> cartItems = cartService.findByUsername(user.getUsername());
        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?message=empty_cart");
            return;
        }

        String receiverName = trimOrDefault(req.getParameter("receiverName"),
                user.getFullname() != null ? user.getFullname() : user.getUsername());
        String receiverPhone = trimOrDefault(req.getParameter("receiverPhone"), user.getPhone());
        String receiverAddress = trimOrDefault(req.getParameter("receiverAddress"), "");
        if (receiverName.isEmpty() || receiverPhone.isEmpty() || receiverAddress.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ họ tên, số điện thoại và địa chỉ nhận hàng.");
            req.setAttribute("cartItems", cartItems);
            req.setAttribute("cartTotal", cartService.calculateTotal(user.getUsername()));
            req.getRequestDispatcher("/views/web/checkout.jsp").forward(req, resp);
            return;
        }

        BigDecimal total = cartService.calculateTotal(user.getUsername());
        Order_24133050 order = new Order_24133050();
        order.setUsername(user.getUsername());
        order.setReceiverName(receiverName);
        order.setReceiverPhone(receiverPhone);
        order.setReceiverAddress(receiverAddress);
        order.setNote(trimOrDefault(req.getParameter("note"), ""));
        order.setPaymentMethod("COD");
        order.setStatus("NEW");
        order.setTotalAmount(total);

        int orderId = orderService.createOrderFromCart(order, cartItems);
        if (orderId > 0) {
            resp.sendRedirect(req.getContextPath() + "/orders?message=checkout_success&orderId=" + orderId);
        } else {
            req.setAttribute("error", "Không thể tạo đơn hàng. Vui lòng thử lại.");
            req.setAttribute("cartItems", cartItems);
            req.setAttribute("cartTotal", total);
            req.getRequestDispatcher("/views/web/checkout.jsp").forward(req, resp);
        }
    }

    private User_24133050 requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return (User_24133050) session.getAttribute("user");
    }

    private String trimOrDefault(String value, String fallback) {
        String safeValue = value != null ? value.trim() : "";
        if (!safeValue.isEmpty()) {
            return safeValue;
        }
        return fallback != null ? fallback.trim() : "";
    }
}

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
import vn.iotstar.dao.ICartDao_24133050;
import vn.iotstar.entity.CartItem_24133050;
import vn.iotstar.entity.User_24133050;
import vn.iotstar.service.ICartService_24133050;
import vn.iotstar.service.impl.CartServiceImpl_24133050;

@WebServlet(urlPatterns = { "/cart", "/cart/add", "/cart/update", "/cart/remove", "/cart/clear" })
public class CartController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ICartService_24133050 cartService = new CartServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User_24133050 user = requireLogin(req, resp);
        if (user == null) {
            return;
        }

        String action = req.getServletPath();
        if ("/cart/remove".equals(action)) {
            cartService.removeItem(user.getUsername(), req.getParameter("videoId"));
            resp.sendRedirect(req.getContextPath() + "/cart?message=remove_success");
            return;
        }
        if ("/cart/clear".equals(action)) {
            cartService.clearCart(user.getUsername());
            resp.sendRedirect(req.getContextPath() + "/cart?message=clear_success");
            return;
        }

        showCart(req, resp, user);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User_24133050 user = requireLogin(req, resp);
        if (user == null) {
            return;
        }

        String action = req.getServletPath();
        String videoId = req.getParameter("videoId");
        int quantity = parseQuantity(req.getParameter("quantity"));

        if (videoId == null || videoId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?message=invalid_item");
            return;
        }

        if ("/cart/add".equals(action)) {
            cartService.addItem(user.getUsername(), videoId, quantity);
            String returnUrl = req.getParameter("returnUrl");
            if (returnUrl != null && returnUrl.startsWith(req.getContextPath())) {
                resp.sendRedirect(returnUrl + (returnUrl.contains("?") ? "&" : "?") + "cart=added");
            } else {
                resp.sendRedirect(req.getContextPath() + "/cart?message=add_success");
            }
            return;
        }

        if ("/cart/update".equals(action)) {
            cartService.updateQuantity(user.getUsername(), videoId, quantity);
            resp.sendRedirect(req.getContextPath() + "/cart?message=update_success");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void showCart(HttpServletRequest req, HttpServletResponse resp, User_24133050 user)
            throws ServletException, IOException {
        List<CartItem_24133050> cartItems = cartService.findByUsername(user.getUsername());
        BigDecimal total = cartService.calculateTotal(user.getUsername());
        req.setAttribute("cartItems", cartItems);
        req.setAttribute("cartTotal", total);
        req.setAttribute("maxQuantity", ICartDao_24133050.MAX_QUANTITY);
        req.getRequestDispatcher("/views/web/cart.jsp").forward(req, resp);
    }

    private User_24133050 requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return (User_24133050) session.getAttribute("user");
    }

    private int parseQuantity(String rawQuantity) {
        try {
            int quantity = Integer.parseInt(rawQuantity);
            return Math.max(1, Math.min(ICartDao_24133050.MAX_QUANTITY, quantity));
        } catch (Exception e) {
            return 1;
        }
    }
}

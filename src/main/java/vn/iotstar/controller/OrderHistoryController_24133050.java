package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.OrderStatus_24133050;
import vn.iotstar.entity.Order_24133050;
import vn.iotstar.entity.User_24133050;
import vn.iotstar.service.IOrderService_24133050;
import vn.iotstar.service.impl.OrderServiceImpl_24133050;

@WebServlet(urlPatterns = { "/orders", "/order-history" })
public class OrderHistoryController_24133050 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IOrderService_24133050 orderService = new OrderServiceImpl_24133050();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User_24133050 user = requireLogin(req, resp);
        if (user == null) {
            return;
        }

        String status = req.getParameter("status");
        if (!OrderStatus_24133050.isValid(status)) {
            status = null;
        }

        List<Order_24133050> orders = orderService.findByUsername(user.getUsername(), status);
        req.setAttribute("orders", orders);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("statusLabels", OrderStatus_24133050.STATUS_LABELS);
        req.getRequestDispatcher("/views/web/orders.jsp").forward(req, resp);
    }

    private User_24133050 requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return (User_24133050) session.getAttribute("user");
    }
}

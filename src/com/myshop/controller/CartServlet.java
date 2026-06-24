package com.myshop.controller;
import com.myshop.entity.*;
import com.myshop.service.*;
import com.myshop.util.JsonUtil;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

public class CartServlet extends HttpServlet {
    private CartService cartService = new CartService();
    private OrderService orderService = new OrderService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect("/user/login.jsp"); return; }

        List<CartItem> items = cartService.getCart(user.getId());
        double total = cartService.getTotal(items, true);
        int selectedCount = cartService.getSelectedCount(items);

        req.setAttribute("cartItems", items);
        req.setAttribute("total", total);
        req.setAttribute("selectedCount", selectedCount);
        req.setAttribute("cartCount", items.size());
        req.getRequestDispatcher("/cart/index.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) { resp.getWriter().write(JsonUtil.error(401, "Please login")); return; }

        String action = req.getParameter("action");
        resp.setContentType("application/json;charset=UTF-8");

        switch (action) {
            case "add":
                int goodsId = Integer.parseInt(req.getParameter("goodsId"));
                int num = req.getParameter("num") != null ? Integer.parseInt(req.getParameter("num")) : 1;
                boolean ok = cartService.add(user.getId(), goodsId, num);
                resp.getWriter().write(ok ? JsonUtil.success() : JsonUtil.error("Add failed"));
                break;
            case "update":
                int id = Integer.parseInt(req.getParameter("id"));
                int newNum = Integer.parseInt(req.getParameter("num"));
                cartService.updateNum(id, newNum);
                resp.getWriter().write(JsonUtil.success());
                break;
            case "check":
                id = Integer.parseInt(req.getParameter("id"));
                int checked = Integer.parseInt(req.getParameter("checked"));
                cartService.toggleChecked(id, checked);
                resp.getWriter().write(JsonUtil.success());
                break;
            case "checkAll":
                checked = Integer.parseInt(req.getParameter("checked"));
                if (checked == 1) cartService.selectAll(user.getId());
                else cartService.deselectAll(user.getId());
                resp.getWriter().write(JsonUtil.success());
                break;
            case "delete":
                id = Integer.parseInt(req.getParameter("id"));
                cartService.remove(id);
                resp.getWriter().write(JsonUtil.success());
                break;
            case "deleteChecked":
                cartService.removeChecked(user.getId());
                resp.getWriter().write(JsonUtil.success());
                break;
            case "checkout":
                List<CartItem> items = cartService.getCart(user.getId());
                List<CartItem> checkedItems = new ArrayList<>();
                for (CartItem ci : items) if (ci.getChecked() == 1) checkedItems.add(ci);
                int orderId = orderService.createOrder(user.getId(), checkedItems);
                resp.getWriter().write(orderId > 0 ? JsonUtil.success() : JsonUtil.error("Checkout failed"));
                break;
            default:
                resp.getWriter().write(JsonUtil.error("Unknown action"));
        }
    }
}

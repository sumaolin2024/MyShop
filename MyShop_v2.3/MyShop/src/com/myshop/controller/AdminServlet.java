package com.myshop.controller;
import com.myshop.entity.*;
import com.myshop.service.*;
import com.myshop.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

public class AdminServlet extends HttpServlet {
    private GoodsService goodsService = new GoodsService();
    private UserService userService = new UserService();
    private CategoryService categoryService = new CategoryService();
    private OrderService orderService = new OrderService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();

        if ("/dashboard".equals(path) || path == null) {
            req.setAttribute("userCount", userService.count());
            req.setAttribute("goodsCount", goodsService.count());
            req.setAttribute("orderCount", orderService.count());
            req.setAttribute("categoryCount", categoryService.getAll().size());
            req.getRequestDispatcher("/admin/index.jsp").forward(req, resp);
        } else if ("/users".equals(path)) {
            req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
        } else if ("/categories".equals(path)) {
            req.setAttribute("categories", categoryService.getAll());
            req.getRequestDispatcher("/admin/categories.jsp").forward(req, resp);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        resp.setContentType("application/json;charset=UTF-8");

        if ("/login".equals(path)) {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            // Check admin login
            com.myshop.dao.AdminDao adminDao = new com.myshop.dao.AdminDao();
            Admin admin = adminDao.findByUsername(username);
            if (admin != null && BCryptUtil.checkPassword(password, admin.getPassword())) {
                req.getSession().setAttribute("admin", admin);
                resp.getWriter().write(JsonUtil.success());
            } else {
                resp.getWriter().write(JsonUtil.error("Wrong credentials"));
            }
        }
    }
}

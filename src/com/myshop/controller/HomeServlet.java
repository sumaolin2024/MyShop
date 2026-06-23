package com.myshop.controller;
import com.myshop.entity.*;
import com.myshop.service.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet({"/index", ""})
public class HomeServlet extends HttpServlet {
    private CategoryService categoryService = new CategoryService();
    private GoodsService goodsService = new GoodsService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<Category, List<Category>> categoryTree = categoryService.getCategoryTree();
        List<Goods> hotGoods = goodsService.getHot(8);
        List<Goods> newGoods = goodsService.getNew(8);

        req.setAttribute("categoryTree", categoryTree);
        req.setAttribute("hotGoods", hotGoods);
        req.setAttribute("newGoods", newGoods);

        // cart count for header
        Object user = req.getSession().getAttribute("user");
        if (user != null) {
            User u = (User) user;
            CartService cs = new CartService();
            req.setAttribute("cartCount", cs.count(u.getId()));
        }

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}

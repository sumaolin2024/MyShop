package com.myshop.controller;
import com.myshop.entity.*;
import com.myshop.service.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/category/*")
public class CategoryServlet extends HttpServlet {
    private CategoryService categoryService = new CategoryService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<Category, List<Category>> tree = categoryService.getCategoryTree();
        req.setAttribute("categoryTree", tree);
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write(com.myshop.util.JsonUtil.toJson(tree));
    }
}

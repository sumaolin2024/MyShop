package com.myshop.controller;
import com.myshop.entity.*;
import com.myshop.service.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class HomeServlet extends HttpServlet {
    private CategoryService categoryService = new CategoryService();
    private GoodsService goodsService = new GoodsService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<Category, List<Category>> categoryTree = null;
        List<Goods> hotGoods = null;
        List<Goods> newGoods = null;

        try {
            categoryTree = categoryService.getCategoryTree();
        } catch (Exception e) {
            System.err.println("DB connection failed, using demo data: " + e.getMessage());
        }

        try {
            hotGoods = goodsService.getHot(8);
        } catch (Exception e) {
            hotGoods = null;
        }

        try {
            newGoods = goodsService.getNew(8);
        } catch (Exception e) {
            newGoods = null;
        }

        if (categoryTree == null || categoryTree.isEmpty()) {
            categoryTree = getDemoCategories();
        }
        if (hotGoods == null || hotGoods.isEmpty()) {
            hotGoods = getDemoHotGoods();
        }
        if (newGoods == null || newGoods.isEmpty()) {
            newGoods = getDemoNewGoods();
        }

        req.setAttribute("categoryTree", categoryTree);
        req.setAttribute("hotGoods", hotGoods);
        req.setAttribute("newGoods", newGoods);

        Object user = req.getSession().getAttribute("user");
        if (user != null) {
            CartService cs = new CartService();
            try { req.setAttribute("cartCount", cs.count(((User)user).getId())); }
            catch (Exception e) { req.setAttribute("cartCount", 0); }
        }

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    private Map<Category, List<Category>> getDemoCategories() {
        Map<Category, List<Category>> tree = new LinkedHashMap<>();

        Category c1 = new Category(1, "????", "", 0);
        tree.put(c1, Arrays.asList(
            new Category(22, "??", "static/image/category/phone/phone.png", 1),
            new Category(23, "???", "static/image/category/phone/computer.png", 1),
            new Category(25, "??", "static/image/category/phone/flat.png", 1)
        ));

        Category c2 = new Category(2, "????", "", 0);
        tree.put(c2, Arrays.asList(
            new Category(2, "???", "static/image/category/clothes/jackets.png", 2),
            new Category(3, "????", "static/image/category/clothes/overcoat.jpg", 2),
            new Category(4, "???", "static/image/category/clothes/dress.png", 2)
        ));

        Category c5 = new Category(5, "????", "", 0);
        tree.put(c5, Arrays.asList(
            new Category(6, "????", "static/image/category/foods/biscuit.jpg", 5),
            new Category(7, "????", "static/image/category/foods/tomato.jpg", 5),
            new Category(8, "????", "static/image/category/foods/drinks.jpg", 5)
        ));

        Category c11 = new Category(11, "????", "", 0);
        tree.put(c11, Arrays.asList(
            new Category(12, "????", "static/image/category/jewelry/ornaments.jpg", 11),
            new Category(13, "????", "static/image/category/jewelry/watch.jpg", 11)
        ));

        Category c15 = new Category(15, "????", "", 0);
        tree.put(c15, Arrays.asList(
            new Category(16, "????", "static/image/category/store/towel.png", 15),
            new Category(17, "????", "static/image/category/store/paper.png", 15)
        ));

        Category c27 = new Category(27, "????", "", 0);
        tree.put(c27, Arrays.asList(
            new Category(28, "???", "static/image/category/motion/shoes.jpg", 27),
            new Category(29, "????", "static/image/category/motion/ball.png", 27)
        ));

        return tree;
    }

    private List<Goods> getDemoHotGoods() {
        List<Goods> list = new ArrayList<>();
        Goods g1 = new Goods(); g1.setId(1); g1.setName("???"); g1.setPrice(10.00); g1.setPicture("static/image/goods/grapefruit.png"); g1.setSales(122); g1.setStock(10); g1.setIsHot(1); g1.setSpec("?? 300g"); list.add(g1);
        Goods g2 = new Goods(); g2.setId(2); g2.setName("??"); g2.setPrice(10.00); g2.setPicture("static/image/goods/grape.png"); g2.setSales(115); g2.setStock(20); g2.setIsHot(1); g2.setSpec("??? 4.5?"); list.add(g2);
        Goods g3 = new Goods(); g3.setId(3); g3.setName("???"); g3.setPrice(3.00); g3.setPicture("static/image/goods/tomatoes.png"); g3.setSales(102); g3.setStock(20); g3.setIsHot(1); g3.setSpec("5??"); list.add(g3);
        Goods g4 = new Goods(); g4.setId(4); g4.setName("??"); g4.setPrice(6.00); g4.setPicture("static/image/goods/lettuce.png"); g4.setSales(89); g4.setStock(20); g4.setIsHot(1); g4.setSpec("1??"); list.add(g4);
        Goods g5 = new Goods(); g5.setId(6); g5.setName("??"); g5.setPrice(8.00); g5.setPicture("static/image/goods/orange.png"); g5.setSales(160); g5.setStock(50); g5.setIsHot(1); g5.setSpec("1??"); list.add(g5);
        Goods g6 = new Goods(); g6.setId(10); g6.setName("???"); g6.setPrice(26.80); g6.setPicture("static/image/goods/apple.jpeg"); g6.setSales(180); g6.setStock(19); g6.setIsHot(1); g6.setSpec("680g/3?"); list.add(g6);
        Goods g7 = new Goods(); g7.setId(7); g7.setName("??"); g7.setPrice(8.00); g7.setPicture("static/image/goods/mushroom.jpg"); g7.setSales(200); g7.setStock(500); g7.setIsHot(1); g7.setSpec("1??"); list.add(g7);
        return list;
    }

    private List<Goods> getDemoNewGoods() {
        List<Goods> list = new ArrayList<>();
        Goods g1 = new Goods(); g1.setId(8); g1.setName("????"); g1.setPrice(2.00); g1.setPicture("static/image/goods/banana.jpeg"); g1.setSales(95); g1.setIsNew(1); g1.setSpec("250g/2?"); list.add(g1);
        Goods g2 = new Goods(); g2.setId(9); g2.setName("????"); g2.setPrice(6.90); g2.setPicture("static/image/goods/pear.jpeg"); g2.setSales(88); g2.setIsNew(1); g2.setSpec("?600g"); list.add(g2);
        Goods g3 = new Goods(); g3.setId(10); g3.setName("???"); g3.setPrice(26.80); g3.setPicture("static/image/goods/apple.jpeg"); g3.setSales(180); g3.setIsNew(1); g3.setSpec("680g/3?"); list.add(g3);
        return list;
    }
}

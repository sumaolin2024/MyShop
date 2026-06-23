package com.myshop.controller;
import com.myshop.entity.*;
import com.myshop.service.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/goods/*")
public class GoodsServlet extends HttpServlet {
    private GoodsService goodsService = new GoodsService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();

        if ("/detail".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Goods goods = goodsService.getById(id);
            if (goods == null) { resp.sendError(404); return; }
            List<GoodsAlbum> albums = goodsService.getAlbums(id);
            List<Goods> related = goodsService.getRelated(id, goods.getCategoryId(), 4);

            req.setAttribute("goods", goods);
            req.setAttribute("albums", albums);
            req.setAttribute("related", related);
            req.getRequestDispatcher("/goods/detail.jsp").forward(req, resp);
        } else {
            // list page
            int categoryId = req.getParameter("categoryId") != null ? Integer.parseInt(req.getParameter("categoryId")) : 0;
            int page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
            String keyword = req.getParameter("keyword");
            String sort = req.getParameter("sort");
            if (sort == null) sort = "default";

            PageInfo<Goods> pageInfo = goodsService.getPage(categoryId, keyword, sort, page, 12);

            req.setAttribute("pageInfo", pageInfo);
            req.setAttribute("categoryId", categoryId);
            req.setAttribute("keyword", keyword);
            req.setAttribute("sort", sort);
            req.getRequestDispatcher("/goods/list.jsp").forward(req, resp);
        }
    }
}

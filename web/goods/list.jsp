<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.myshop.entity.*" %>
<%
    PageInfo<Goods> pageInfo = (PageInfo<Goods>) request.getAttribute("pageInfo");
    if (pageInfo == null) pageInfo = new PageInfo<>();
    int categoryId = request.getAttribute("categoryId") != null ? (Integer) request.getAttribute("categoryId") : 0;
    String keyword = (String) request.getAttribute("keyword");
    String sort = (String) request.getAttribute("sort");
    if (keyword == null) keyword = "";
    if (sort == null) sort = "default";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop — MyShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css">
    <style>
        .shop-layout { display: flex; gap: 32px; margin-top: calc(var(--hdr-h) + 20px); padding-bottom: 60px; }
        .shop-sidebar { width: 220px; flex-shrink: 0; }
        .shop-main { flex: 1; }
        .filter-block { margin-bottom: 24px; }
        .filter-block h4 { font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 12px; color: var(--c-black); }
        .filter-block a { display: block; font-size: 13px; color: var(--c-gray); padding: 4px 0; transition: color var(--trans); }
        .filter-block a:hover, .filter-block a.active { color: var(--c-black); font-weight: 500; }
        .shop-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .shop-sort { display: flex; gap: 16px; }
        .shop-sort a { font-size: 13px; color: var(--c-gray); padding-bottom: 4px; border-bottom: 2px solid transparent; transition: var(--trans); }
        .shop-sort a.active, .shop-sort a:hover { color: var(--c-black); border-color: var(--c-black); }
        .shop-count { font-size: 12px; color: var(--c-gray); }
        .empty-state { text-align: center; padding: 80px 20px; }
        .empty-state h3 { font-size: 20px; margin-bottom: 8px; }
        .empty-state p { color: var(--c-gray); }
        @media (max-width: 768px) {
            .shop-layout { flex-direction: column; }
            .shop-sidebar { width: 100%; display: flex; gap: 16px; overflow-x: auto; }
            .filter-block { flex-shrink: 0; }
        }
    </style>
</head>
<body>
<%@ include file="/includes/header.jsp" %>

<div class="container">
    <nav class="breadcrumb">
        <a href="<%= request.getContextPath() %>/">Home</a> /
        <span>Shop</span>
        <% if (keyword != null && !keyword.isEmpty()) { %>
            / <span>Search: "<%= keyword %>"</span>
        <% } %>
    </nav>

    <div class="shop-layout">
        <aside class="shop-sidebar">
            <div class="filter-block">
                <h4>Categories</h4>
                <a href="?<%= keyword.isEmpty() ? "" : "keyword=" + keyword + "&" %><%= sort.equals("default") ? "" : "sort=" + sort %>" class="<%= categoryId == 0 ? "active" : "" %>">All Products</a>
                <a href="?categoryId=1<%= keyword.isEmpty() ? "" : "&keyword=" + keyword %><%= sort.equals("default") ? "" : "&sort=" + sort %>" class="<%= categoryId == 1 ? "active" : "" %>">Fashion</a>
                <a href="?categoryId=5<%= keyword.isEmpty() ? "" : "&keyword=" + keyword %><%= sort.equals("default") ? "" : "&sort=" + sort %>" class="<%= categoryId == 5 ? "active" : "" %>">Food & Drinks</a>
                <a href="?categoryId=11<%= keyword.isEmpty() ? "" : "&keyword=" + keyword %><%= sort.equals("default") ? "" : "&sort=" + sort %>" class="<%= categoryId == 11 ? "active" : "" %>">Jewelry</a>
                <a href="?categoryId=15<%= keyword.isEmpty() ? "" : "&keyword=" + keyword %><%= sort.equals("default") ? "" : "&sort=" + sort %>" class="<%= categoryId == 15 ? "active" : "" %>">Daily Goods</a>
                <a href="?categoryId=21<%= keyword.isEmpty() ? "" : "&keyword=" + keyword %><%= sort.equals("default") ? "" : "&sort=" + sort %>" class="<%= categoryId == 21 ? "active" : "" %>">Digital</a>
                <a href="?categoryId=27<%= keyword.isEmpty() ? "" : "&keyword=" + keyword %><%= sort.equals("default") ? "" : "&sort=" + sort %>" class="<%= categoryId == 27 ? "active" : "" %>">Sports</a>
            </div>
            <div class="filter-block">
                <h4>Search</h4>
                <form method="get" action="" style="display:flex;gap:8px;">
                    <input type="hidden" name="categoryId" value="<%= categoryId %>">
                    <input type="hidden" name="sort" value="<%= sort %>">
                    <input type="text" name="keyword" value="<%= keyword %>" placeholder="Search..." class="form-input" style="padding:8px 10px;font-size:12px;">
                    <button type="submit" class="btn btn-sm btn-primary">Go</button>
                </form>
            </div>
        </aside>

        <main class="shop-main">
            <div class="shop-toolbar">
                <div class="shop-sort">
                    <a href="?categoryId=<%= categoryId %><%= keyword.isEmpty() ? "" : "&keyword=" + keyword %>&sort=default" class="<%= "default".equals(sort) ? "active" : "" %>">Default</a>
                    <a href="?categoryId=<%= categoryId %><%= keyword.isEmpty() ? "" : "&keyword=" + keyword %>&sort=price_asc" class="<%= "price_asc".equals(sort) ? "active" : "" %>">Price ↑</a>
                    <a href="?categoryId=<%= categoryId %><%= keyword.isEmpty() ? "" : "&keyword=" + keyword %>&sort=price_desc" class="<%= "price_desc".equals(sort) ? "active" : "" %>">Price ↓</a>
                    <a href="?categoryId=<%= categoryId %><%= keyword.isEmpty() ? "" : "&keyword=" + keyword %>&sort=sales" class="<%= "sales".equals(sort) ? "active" : "" %>">Sales</a>
                    <a href="?categoryId=<%= categoryId %><%= keyword.isEmpty() ? "" : "&keyword=" + keyword %>&sort=newest" class="<%= "newest".equals(sort) ? "active" : "" %>">Newest</a>
                </div>
                <span class="shop-count"><%= pageInfo.getTotalCount() %> products</span>
            </div>

            <% if (pageInfo.getList() == null || pageInfo.getList().isEmpty()) { %>
                <div class="empty-state">
                    <h3>No products found</h3>
                    <p>Try adjusting your search or filter criteria</p>
                </div>
            <% } else { %>
                <div class="product-grid">
                    <% for (Goods g : pageInfo.getList()) { %>
                    <div class="product-card" onclick="location.href='<%= request.getContextPath() %>/goods/detail?id=<%= g.getId() %>'">
                        <div class="product-card-image">
                            <% if (g.getIsNew() == 1) { %><span class="tag-new">NEW</span><% } %>
                            <img src="<%= request.getContextPath() %>/<%= g.getPicture() %>" alt="<%= g.getName() %>">
                            <div class="product-card-actions" onclick="event.stopPropagation()">
                                <button onclick="addToCart(<%= g.getId() %>, 1)" title="Add to Cart">+</button>
                            </div>
                        </div>
                        <div class="product-card-name"><%= g.getName() %></div>
                        <div class="product-card-price">¥<%= String.format("%.2f", g.getPrice()) %></div>
                        <div class="product-card-meta">Sold <%= g.getSales() %> &middot; <%= g.getSpec() %></div>
                    </div>
                    <% } %>
                </div>

                <!-- Pagination -->
                <% if (pageInfo.getTotalPages() > 1) { %>
                <div class="pagination">
                    <% if (pageInfo.getHasPrev()) { %>
                        <a href="?categoryId=<%= categoryId %>&keyword=<%= keyword %>&sort=<%= sort %>&page=<%= pageInfo.getCurrentPage() - 1 %>">&laquo;</a>
                    <% } else { %>
                        <span class="disabled">&laquo;</span>
                    <% } %>
                    <% for (int p = 1; p <= pageInfo.getTotalPages(); p++) { %>
                        <% if (p == pageInfo.getCurrentPage()) { %>
                            <span class="current"><%= p %></span>
                        <% } else { %>
                            <a href="?categoryId=<%= categoryId %>&keyword=<%= keyword %>&sort=<%= sort %>&page=<%= p %>"><%= p %></a>
                        <% } %>
                    <% } %>
                    <% if (pageInfo.getHasNext()) { %>
                        <a href="?categoryId=<%= categoryId %>&keyword=<%= keyword %>&sort=<%= sort %>&page=<%= pageInfo.getCurrentPage() + 1 %>">&raquo;</a>
                    <% } else { %>
                        <span class="disabled">&raquo;</span>
                    <% } %>
                </div>
                <% } %>
            <% } %>
        </main>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
<script src="<%= request.getContextPath() %>/js/global.js"></script>
</body>
</html>

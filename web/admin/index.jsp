<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    com.myshop.entity.Admin admin = (com.myshop.entity.Admin) session.getAttribute("admin");
    Integer userCount = (Integer) request.getAttribute("userCount");
    Integer goodsCount = (Integer) request.getAttribute("goodsCount");
    Integer orderCount = (Integer) request.getAttribute("orderCount");
    Integer categoryCount = (Integer) request.getAttribute("categoryCount");
    if (userCount == null) userCount = 0; if (goodsCount == null) goodsCount = 0;
    if (orderCount == null) orderCount = 0; if (categoryCount == null) categoryCount = 0;
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — MyShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css">
    <style>
        .admin-layout { display: flex; min-height: 100vh; }
        .admin-sidebar { width: 220px; background: var(--c-bg-dark); color: #999; padding: 32px 20px; position: fixed; top: 0; bottom: 0; left: 0; }
        .admin-sidebar h2 { color: var(--c-white); font-size: 18px; font-weight: 700; letter-spacing: 1px; margin-bottom: 40px; }
        .admin-sidebar h2 span { color: var(--c-red); }
        .admin-sidebar a { display: block; color: #999; font-size: 13px; padding: 10px 12px; border-radius: var(--radius); margin-bottom: 4px; transition: var(--trans); }
        .admin-sidebar a:hover, .admin-sidebar a.active { background: #333; color: var(--c-white); }
        .admin-main { margin-left: 220px; flex: 1; padding: 32px 40px; background: var(--c-bg); }
        .admin-main h1 { font-size: 24px; font-weight: 500; margin-bottom: 32px; }
        .stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 40px; }
        .stat-card { background: var(--c-white); padding: 28px 24px; border-radius: var(--radius); }
        .stat-card h3 { font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; color: var(--c-gray); margin-bottom: 8px; }
        .stat-card .stat-value { font-size: 32px; font-weight: 600; color: var(--c-black); }
        .admin-section { background: var(--c-white); padding: 28px; border-radius: var(--radius); }
        .admin-section h3 { font-size: 16px; font-weight: 500; margin-bottom: 16px; }
        @media (max-width: 768px) {
            .admin-sidebar { display: none; }
            .admin-main { margin-left: 0; padding: 20px; }
            .stat-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>
<div class="admin-layout">
    <aside class="admin-sidebar">
        <h2>MY<span>SHOP</span></h2>
        <a href="#" class="active">Dashboard</a>
        <a href="#">Products</a>
        <a href="#">Categories</a>
        <a href="#">Users</a>
        <a href="#">Orders</a>
        <a href="<%= request.getContextPath() %>/">← Back to Store</a>
        <a href="<%= request.getContextPath() %>/user/logout" style="color:var(--c-red);margin-top:20px;">Sign Out</a>
    </aside>
    <main class="admin-main">
        <h1>Dashboard</h1>
        <div class="stat-grid">
            <div class="stat-card">
                <h3>Users</h3>
                <div class="stat-value"><%= userCount %></div>
            </div>
            <div class="stat-card">
                <h3>Products</h3>
                <div class="stat-value"><%= goodsCount %></div>
            </div>
            <div class="stat-card">
                <h3>Categories</h3>
                <div class="stat-value"><%= categoryCount %></div>
            </div>
            <div class="stat-card">
                <h3>Orders</h3>
                <div class="stat-value"><%= orderCount %></div>
            </div>
        </div>
        <div class="admin-section">
            <h3>Quick Overview</h3>
            <p class="text-gray">Welcome to the MyShop admin panel. Use the sidebar to manage products, categories, users, and orders.</p>
            <div style="display:flex;gap:12px;margin-top:20px;">
                <a href="<%= request.getContextPath() %>/goods/list.jsp" class="btn btn-primary btn-sm">Manage Products</a>
                <a href="<%= request.getContextPath() %>/" class="btn btn-outline btn-sm">View Store</a>
            </div>
        </div>
    </main>
</div>
</body>
</html>

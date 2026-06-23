<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.myshop.entity.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    Integer cartCount = (Integer) request.getAttribute("cartCount");
    if (cartCount == null) cartCount = 0;
    String currentPath = request.getRequestURI();
%>
<header class="site-header" id="siteHeader">
    <div class="header-inner">
        <a href="<%= request.getContextPath() %>/" class="header-logo">MY<span>SHOP</span></a>
        <nav class="nav-main" id="navMain">
            <a href="<%= request.getContextPath() %>/">Home</a>
            <a href="<%= request.getContextPath() %>/goods/list.jsp">Shop</a>
            <a href="<%= request.getContextPath() %>/goods/list.jsp?sort=sales">Best Sellers</a>
            <a href="<%= request.getContextPath() %>/goods/list.jsp?sort=newest">New Arrivals</a>
        </nav>
        <div class="header-actions">
            <% if (sessionUser != null) { %>
                <a href="<%= request.getContextPath() %>/user/profile.jsp" class="icon-btn" title="My Account">👤</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/user/login.jsp" class="icon-btn" title="Login">👤</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/cart/index.jsp" class="icon-btn cart-icon" title="Cart">🛒
                <span class="cart-badge <%= cartCount > 0 ? "show" : "" %>" id="cartBadge"><%= cartCount > 0 ? cartCount : "" %></span>
            </a>
            <div class="hamburger" id="hamburger" onclick="toggleMenu()">
                <span></span><span></span><span></span>
            </div>
        </div>
    </div>
    <nav class="mobile-nav" id="mobileNav">
        <a href="<%= request.getContextPath() %>/">Home</a>
        <a href="<%= request.getContextPath() %>/goods/list.jsp">Shop</a>
        <a href="<%= request.getContextPath() %>/goods/list.jsp?sort=sales">Best Sellers</a>
        <a href="<%= request.getContextPath() %>/goods/list.jsp?sort=newest">New Arrivals</a>
        <% if (sessionUser != null) { %>
            <a href="<%= request.getContextPath() %>/user/profile.jsp">My Account</a>
            <a href="<%= request.getContextPath() %>/user/logout">Sign Out</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/user/login.jsp">Sign In</a>
            <a href="<%= request.getContextPath() %>/user/register.jsp">Register</a>
        <% } %>
    </nav>
</header>

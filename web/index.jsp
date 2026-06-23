<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.myshop.entity.*" %>
<%
    if (request.getAttribute("categoryTree") == null) {
        request.getRequestDispatcher("/index").forward(request, response);
        return;
    }
    Map<Category, List<Category>> categoryTree = (Map<Category, List<Category>>) request.getAttribute("categoryTree");
    List<Goods> hotGoods = (List<Goods>) request.getAttribute("hotGoods");
    List<Goods> newGoods = (List<Goods>) request.getAttribute("newGoods");
    if (categoryTree == null) categoryTree = new LinkedHashMap<>();
    if (hotGoods == null) hotGoods = new ArrayList<>();
    if (newGoods == null) newGoods = new ArrayList<>();

    List<Category> topCategories = new ArrayList<>();
    for (Map.Entry<Category, List<Category>> entry : categoryTree.entrySet()) {
        if (entry.getKey().getPid() == 0) topCategories.add(entry.getKey());
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MyShop — Modern E-Commerce</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css">
</head>
<body>
<%@ include file="/includes/header.jsp" %>

<!-- Hero Banner -->
<section class="hero" id="hero">
    <div class="hero-slider" id="heroSlider">
        <div class="hero-slide">
            <div class="hero-content">
                <h2>Summer Collection 2026</h2>
                <p>Discover refined essentials designed for the modern lifestyle. Minimalist aesthetics, maximum comfort.</p>
                <a href="<%= request.getContextPath() %>/goods/list.jsp?categoryId=1" class="hero-cta">Explore Collection</a>
            </div>
        </div>
        <div class="hero-slide">
            <div class="hero-content">
                <h2>Fresh Harvest</h2>
                <p>Farm-to-table quality. Handpicked seasonal fruits and vegetables delivered to your doorstep.</p>
                <a href="<%= request.getContextPath() %>/goods/list.jsp?categoryId=5" class="hero-cta">Shop Fresh</a>
            </div>
        </div>
        <div class="hero-slide">
            <div class="hero-content">
                <h2>Digital Life</h2>
                <p>Premium gadgets and accessories that elevate how you work and play.</p>
                <a href="<%= request.getContextPath() %>/goods/list.jsp?categoryId=21" class="hero-cta">View All</a>
            </div>
        </div>
    </div>
    <div class="hero-dots" id="heroDots">
        <span class="hero-dot active" data-index="0"></span>
        <span class="hero-dot" data-index="1"></span>
        <span class="hero-dot" data-index="2"></span>
    </div>
    <div class="hero-arrows">
        <button class="hero-arrow" onclick="heroPrev()">&#10094;</button>
        <button class="hero-arrow" onclick="heroNext()">&#10095;</button>
    </div>
</section>

<!-- Category Grid -->
<section class="section">
    <div class="container">
        <div class="section-header">
            <h2>Shop by Category</h2>
            <p>Find what you need, discover what you love</p>
        </div>
        <div class="category-grid">
            <% for (Category cat : topCategories) {
                String bgImg = "";
                for (Map.Entry<Category, List<Category>> e : categoryTree.entrySet()) {
                    if (e.getKey().getId() == cat.getId() && !e.getValue().isEmpty()) {
                        bgImg = e.getValue().get(0).getPicture();
                        break;
                    }
                }
            %>
            <a href="<%= request.getContextPath() %>/goods/list.jsp?categoryId=<%= cat.getId() %>" class="category-card">
                <img src="<%= request.getContextPath() %>/<%= bgImg %>" alt="<%= cat.getName() %>" onerror="this.style.display='none'">
                <div class="category-card-overlay">
                    <h3><%= cat.getName() %></h3>
                    <span>Shop Now →</span>
                </div>
            </a>
            <% } %>
        </div>
    </div>
</section>

<!-- Hot Products -->
<section class="section" style="background: var(--c-bg);">
    <div class="container">
        <div class="section-header">
            <h2>Best Sellers</h2>
            <p>Our most popular products, loved by customers</p>
        </div>
        <div class="product-grid">
            <% for (Goods g : hotGoods) { %>
            <div class="product-card" onclick="location.href='<%= request.getContextPath() %>/goods/detail?id=<%= g.getId() %>'">
                <div class="product-card-image">
                    <% if (g.getIsNew() == 1) { %><span class="tag-new">NEW</span><% } %>
                    <img src="<%= request.getContextPath() %>/<%= g.getPicture() %>" alt="<%= g.getName() %>" onerror="this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%22300%22 height=%22300%22><rect fill=%22%23f5f5f5%22 width=%22300%22 height=%22300%22/><text x=%22150%22 y=%22150%22 text-anchor=%22middle%22 fill=%22%23ccc%22 font-size=%2214%22>No Image</text></svg>'">
                    <div class="product-card-actions" onclick="event.stopPropagation()">
                        <button onclick="addToCart(<%= g.getId() %>, 1)" title="Add to Cart">+</button>
                    </div>
                </div>
                <div class="product-card-name"><%= g.getName() %></div>
                <div class="product-card-price">¥<%= String.format("%.2f", g.getPrice()) %></div>
                <div class="product-card-meta">Sold <%= g.getSales() %> &middot; Stock <%= g.getStock() %></div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<!-- New Arrivals -->
<section class="section">
    <div class="container">
        <div class="section-header">
            <h2>New Arrivals</h2>
            <p>Fresh picks, just landed</p>
        </div>
        <div class="new-scroll">
            <% for (Goods g : newGoods) { %>
            <div class="product-card" onclick="location.href='<%= request.getContextPath() %>/goods/detail?id=<%= g.getId() %>'">
                <div class="product-card-image">
                    <span class="tag-new">NEW</span>
                    <img src="<%= request.getContextPath() %>/<%= g.getPicture() %>" alt="<%= g.getName() %>">
                    <div class="product-card-actions" onclick="event.stopPropagation()">
                        <button onclick="addToCart(<%= g.getId() %>, 1)" title="Add to Cart">+</button>
                    </div>
                </div>
                <div class="product-card-name"><%= g.getName() %></div>
                <div class="product-card-price">¥<%= String.format("%.2f", g.getPrice()) %></div>
                <div class="product-card-meta"><%= g.getSpec() %></div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<%@ include file="/includes/footer.jsp" %>

<script>
// Hero slider
var heroCurrent = 0;
var heroTotal = 3;
var heroTimer;

function heroGo(index) {
    heroCurrent = index;
    document.getElementById('heroSlider').style.transform = 'translateX(-' + (heroCurrent * 100) + '%)';
    document.querySelectorAll('.hero-dot').forEach(function(d, i) { d.classList.toggle('active', i === heroCurrent); });
}
function heroNext() { heroGo((heroCurrent + 1) % heroTotal); }
function heroPrev() { heroGo((heroCurrent - 1 + heroTotal) % heroTotal); }

document.querySelectorAll('.hero-dot').forEach(function(d) {
    d.addEventListener('click', function() { heroGo(parseInt(this.dataset.index)); });
});

heroTimer = setInterval(heroNext, 5000);

// Touch swipe support
var touchStartX = 0;
document.getElementById('hero').addEventListener('touchstart', function(e) { touchStartX = e.touches[0].clientX; });
document.getElementById('hero').addEventListener('touchend', function(e) {
    var diff = touchStartX - e.changedTouches[0].clientX;
    if (Math.abs(diff) > 50) { diff > 0 ? heroNext() : heroPrev(); }
});
</script>
<script src="<%= request.getContextPath() %>/js/global.js"></script>
</body>
</html>


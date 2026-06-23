<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.myshop.entity.*" %>
<%
    Goods goods = (Goods) request.getAttribute("goods");
    List<GoodsAlbum> albums = (List<GoodsAlbum>) request.getAttribute("albums");
    List<Goods> related = (List<Goods>) request.getAttribute("related");
    if (goods == null) goods = new Goods();
    if (albums == null) albums = new ArrayList<>();
    if (related == null) related = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= goods.getName() %> — MyShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css">
    <style>
        .detail-layout { display: flex; gap: 60px; margin-top: calc(var(--hdr-h) + 30px); padding-bottom: 80px; }
        .detail-gallery { flex: 1; max-width: 520px; }
        .detail-main-img { width: 100%; aspect-ratio: 1; overflow: hidden; border-radius: var(--radius); margin-bottom: 12px; position: relative; cursor: zoom-in; }
        .detail-main-img img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.1s ease; }
        .detail-thumbs { display: flex; gap: 8px; }
        .detail-thumb { width: 72px; height: 72px; border-radius: var(--radius); overflow: hidden; cursor: pointer; border: 2px solid transparent; transition: var(--trans); }
        .detail-thumb.active, .detail-thumb:hover { border-color: var(--c-black); }
        .detail-thumb img { width: 100%; height: 100%; object-fit: cover; }
        .detail-info { flex: 1; }
        .detail-name { font-size: 24px; font-weight: 500; margin-bottom: 8px; }
        .detail-price { font-size: 28px; font-weight: 600; color: var(--c-red); margin-bottom: 20px; }
        .detail-price .original { font-size: 16px; color: #999; text-decoration: line-through; font-weight: 400; margin-left: 12px; }
        .detail-meta { font-size: 13px; color: var(--c-gray); margin-bottom: 24px; line-height: 2; }
        .detail-spec { margin-bottom: 24px; }
        .detail-spec h4 { font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .detail-spec p { font-size: 14px; color: var(--c-gray); }
        .qty-selector { display: flex; align-items: center; gap: 0; margin-bottom: 24px; }
        .qty-btn { width: 40px; height: 40px; border: 1px solid var(--c-border); background: var(--c-white); font-size: 16px; display: flex; align-items: center; justify-content: center; transition: var(--trans); }
        .qty-btn:hover { background: var(--c-bg); }
        .qty-input { width: 60px; height: 40px; border: 1px solid var(--c-border); border-left: none; border-right: none; text-align: center; font-size: 14px; outline: none; }
        .detail-actions { display: flex; gap: 12px; margin-bottom: 32px; }
        .detail-section { margin-top: 60px; }
        .detail-section h3 { font-size: 18px; font-weight: 500; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 2px solid var(--c-black); }
        .detail-description img { max-width: 100%; height: auto; margin: 16px 0; }
        #zoom-lens { display: none; position: absolute; border: 2px solid var(--c-black); background-repeat: no-repeat; z-index: 10; pointer-events: none; border-radius: var(--radius); }
        @media (max-width: 768px) { .detail-layout { flex-direction: column; gap: 32px; } .detail-gallery { max-width: 100%; } }
    </style>
</head>
<body>
<%@ include file="/includes/header.jsp" %>

<div class="container">
    <nav class="breadcrumb">
        <a href="<%= request.getContextPath() %>/">Home</a> /
        <a href="<%= request.getContextPath() %>/goods/list.jsp">Shop</a> /
        <span><%= goods.getName() %></span>
    </nav>

    <div class="detail-layout">
        <div class="detail-gallery">
            <div class="detail-main-img" id="mainImg">
                <img id="mainImage" src="<%= request.getContextPath() %>/<%= goods.getPicture() %>" alt="<%= goods.getName() %>">
                <div id="zoomLens"></div>
            </div>
            <div class="detail-thumbs">
                <div class="detail-thumb active" onclick="switchImage('<%= goods.getPicture() %>', this)">
                    <img src="<%= request.getContextPath() %>/<%= goods.getPicture() %>" alt="thumb">
                </div>
                <% for (GoodsAlbum album : albums) { %>
                <div class="detail-thumb" onclick="switchImage('<%= album.getPicture() %>', this)">
                    <img src="<%= request.getContextPath() %>/<%= album.getPicture() %>" alt="thumb">
                </div>
                <% } %>
            </div>
        </div>

        <div class="detail-info">
            <h1 class="detail-name"><%= goods.getName() %></h1>
            <div class="detail-price">¥<%= String.format("%.2f", goods.getPrice()) %></div>
            <div class="detail-meta">
                <div>Spec: <%= goods.getSpec() %></div>
                <div>Sales: <%= goods.getSales() %> sold</div>
                <div>Stock: <%= goods.getStock() %> available</div>
            </div>
            <div class="detail-spec">
                <h4>Product Details</h4>
                <p><%= goods.getDescription() != null ? goods.getDescription().replaceAll("<[^>]+>", " ") : "" %></p>
            </div>
            <div class="qty-selector">
                <button class="qty-btn" onclick="changeQty(-1)">−</button>
                <input type="text" class="qty-input" id="qtyInput" value="1" onchange="validateQty()">
                <button class="qty-btn" onclick="changeQty(1)">+</button>
            </div>
            <div class="detail-actions">
                <button class="btn btn-primary btn-lg" onclick="addToCart(<%= goods.getId() %>, getQty())">Add to Cart</button>
                <button class="btn btn-outline btn-lg" onclick="addToCart(<%= goods.getId() %>, getQty()); location.href='<%= request.getContextPath() %>/cart/index.jsp'">Buy Now</button>
            </div>
        </div>
    </div>

    <!-- Product Description -->
    <% if (goods.getDescription() != null && goods.getDescription().contains("<img")) { %>
    <div class="detail-section">
        <h3>Product Details</h3>
        <div class="detail-description">
            <%= goods.getDescription() %>
        </div>
    </div>
    <% } %>

    <!-- Related Products -->
    <% if (!related.isEmpty()) { %>
    <div class="detail-section">
        <h3>You May Also Like</h3>
        <div class="product-grid">
            <% for (Goods r : related) { %>
            <div class="product-card" onclick="location.href='<%= request.getContextPath() %>/goods/detail?id=<%= r.getId() %>'">
                <div class="product-card-image">
                    <img src="<%= request.getContextPath() %>/<%= r.getPicture() %>" alt="<%= r.getName() %>">
                    <div class="product-card-actions" onclick="event.stopPropagation()">
                        <button onclick="addToCart(<%= r.getId() %>, 1)" title="Add to Cart">+</button>
                    </div>
                </div>
                <div class="product-card-name"><%= r.getName() %></div>
                <div class="product-card-price">¥<%= String.format("%.2f", r.getPrice()) %></div>
                <div class="product-card-meta">Sold <%= r.getSales() %></div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>

<script>
function switchImage(src, thumb) {
    document.getElementById('mainImage').src = '<%= request.getContextPath() %>/' + src;
    document.querySelectorAll('.detail-thumb').forEach(function(t) { t.classList.remove('active'); });
    thumb.classList.add('active');
}
function getQty() { return parseInt(document.getElementById('qtyInput').value) || 1; }
function changeQty(delta) {
    var input = document.getElementById('qtyInput');
    var v = parseInt(input.value) || 1;
    v = Math.max(1, Math.min(<%= goods.getStock() %>, v + delta));
    input.value = v;
}
function validateQty() {
    var input = document.getElementById('qtyInput');
    var v = parseInt(input.value) || 1;
    input.value = Math.max(1, Math.min(<%= goods.getStock() %>, v));
}

// Image zoom
(function() {
    var main = document.getElementById('mainImg');
    var img = document.getElementById('mainImage');
    var lens = document.getElementById('zoomLens');
    if (!lens) { lens = document.createElement('div'); lens.id = 'zoomLens'; main.appendChild(lens); }

    main.addEventListener('mousemove', function(e) {
        var rect = main.getBoundingClientRect();
        var x = e.clientX - rect.left, y = e.clientY - rect.top;
        var lensW = rect.width * 0.4, lensH = rect.height * 0.4;
        lens.style.display = 'block';
        lens.style.width = lensW + 'px'; lens.style.height = lensH + 'px';
        lens.style.left = Math.min(Math.max(x - lensW/2, 0), rect.width - lensW) + 'px';
        lens.style.top = Math.min(Math.max(y - lensH/2, 0), rect.height - lensH) + 'px';
        lens.style.backgroundImage = 'url(' + img.src + ')';
        lens.style.backgroundSize = (rect.width * 2.5) + 'px ' + (rect.height * 2.5) + 'px';
        var bgX = -(x * 2.5 - lensW/2);
        var bgY = -(y * 2.5 - lensH/2);
        lens.style.backgroundPosition = bgX + 'px ' + bgY + 'px';
    });
    main.addEventListener('mouseleave', function() { lens.style.display = 'none'; });
})();
</script>
<script src="<%= request.getContextPath() %>/js/global.js"></script>
</body>
</html>

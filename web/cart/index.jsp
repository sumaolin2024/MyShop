<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.myshop.entity.*" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Double total = (Double) request.getAttribute("total");
    Integer selectedCount = (Integer) request.getAttribute("selectedCount");
    if (cartItems == null) cartItems = new ArrayList<>();
    if (total == null) total = 0.0;
    if (selectedCount == null) selectedCount = 0;
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart — MyShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css">
    <style>
        .cart-page { margin-top: calc(var(--hdr-h) + 30px); padding-bottom: 80px; }
        .cart-page h2 { font-size: 24px; font-weight: 500; margin-bottom: 32px; }
        .cart-table { width: 100%; border-collapse: collapse; }
        .cart-table th { font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; color: var(--c-gray); padding: 16px 12px; border-bottom: 2px solid var(--c-black); text-align: left; }
        .cart-table td { padding: 20px 12px; border-bottom: 1px solid var(--c-border); vertical-align: middle; }
        .cart-product { display: flex; align-items: center; gap: 16px; }
        .cart-product-img { width: 80px; height: 80px; border-radius: var(--radius); overflow: hidden; flex-shrink: 0; }
        .cart-product-img img { width: 100%; height: 100%; object-fit: cover; }
        .cart-product-name { font-size: 14px; font-weight: 500; }
        .cart-checkbox { width: 18px; height: 18px; cursor: pointer; accent-color: var(--c-black); }
        .cart-actions-bar { display: flex; justify-content: space-between; align-items: center; margin-top: 24px; padding: 20px 0; }
        .cart-total { text-align: right; }
        .cart-total-label { font-size: 12px; color: var(--c-gray); }
        .cart-total-price { font-size: 24px; font-weight: 600; color: var(--c-red); }
        .cart-empty { text-align: center; padding: 80px 20px; }
        .cart-empty h3 { font-size: 20px; margin-bottom: 12px; }
        .cart-empty p { color: var(--c-gray); margin-bottom: 24px; }
        @media (max-width: 768px) {
            .cart-table thead { display: none; }
            .cart-table tr { display: block; padding: 16px 0; border-bottom: 1px solid var(--c-border); }
            .cart-table td { display: block; padding: 4px 0; border: none; }
            .cart-table td:before { content: attr(data-label); font-size: 11px; color: var(--c-gray); display: block; }
            .cart-actions-bar { flex-direction: column; gap: 16px; align-items: flex-end; }
        }
    </style>
</head>
<body>
<%@ include file="/includes/header.jsp" %>

<div class="container cart-page">
    <h2>Shopping Cart</h2>

    <% if (sessionUser == null) { %>
        <div class="cart-empty">
            <h3>Please sign in</h3>
            <p>You need to login to view your shopping cart</p>
            <a href="<%= request.getContextPath() %>/user/login.jsp" class="btn btn-primary">Sign In</a>
        </div>
    <% } else if (cartItems.isEmpty()) { %>
        <div class="cart-empty">
            <h3>Your cart is empty</h3>
            <p>Start shopping and add items to your cart</p>
            <a href="<%= request.getContextPath() %>/goods/list.jsp" class="btn btn-primary">Browse Products</a>
        </div>
    <% } else { %>
        <table class="cart-table">
            <thead>
                <tr>
                    <th style="width:36px;"><input type="checkbox" class="cart-checkbox" id="checkAll" <%= selectedCount == cartItems.size() ? "checked" : "" %> onchange="checkAll(this.checked)"></th>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                    <th style="width:40px;"></th>
                </tr>
            </thead>
            <tbody id="cartBody">
                <% for (CartItem item : cartItems) { %>
                <tr id="cartRow_<%= item.getId() %>">
                    <td data-label="Select">
                        <input type="checkbox" class="cart-checkbox item-check" <%= item.getChecked() == 1 ? "checked" : "" %> onchange="toggleCheck(<%= item.getId() %>, this.checked)">
                    </td>
                    <td data-label="Product">
                        <div class="cart-product">
                            <div class="cart-product-img">
                                <img src="<%= request.getContextPath() %>/<%= item.getGoodsPicture() %>" alt="<%= item.getGoodsName() %>">
                            </div>
                            <a href="<%= request.getContextPath() %>/goods/detail?id=<%= item.getGoodsId() %>" class="cart-product-name"><%= item.getGoodsName() %></a>
                        </div>
                    </td>
                    <td data-label="Price">¥<%= String.format("%.2f", item.getGoodsPrice()) %></td>
                    <td data-label="Quantity">
                        <div class="qty-selector">
                            <button class="qty-btn" onclick="updateQty(<%= item.getId() %>, -1)">−</button>
                            <input type="text" class="qty-input" id="qty_<%= item.getId() %>" value="<%= item.getGoodsNum() %>" style="width:40px;height:34px;" onchange="setQty(<%= item.getId() %>, this.value)">
                            <button class="qty-btn" onclick="updateQty(<%= item.getId() %>, 1)">+</button>
                        </div>
                    </td>
                    <td data-label="Subtotal" class="subtotal" id="subtotal_<%= item.getId() %>">¥<%= String.format("%.2f", item.getSubtotal()) %></td>
                    <td><button style="color:var(--c-gray);font-size:16px;" onclick="removeItem(<%= item.getId() %>)" title="Remove">&times;</button></td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <div class="cart-actions-bar">
            <div>
                <button class="btn btn-outline btn-sm" onclick="deleteChecked()">Delete Selected</button>
            </div>
            <div class="cart-total">
                <div class="cart-total-label">Total (<span id="selectedLabel"><%= selectedCount %></span> items)</div>
                <div class="cart-total-price" id="totalPrice">¥<%= String.format("%.2f", total) %></div>
                <button class="btn btn-primary btn-lg mt-20" onclick="checkout()">Checkout</button>
            </div>
        </div>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>

<script>
function csrf() { return 'action='; }

function toggleCheck(id, checked) {
    ajax('POST', '<%= request.getContextPath() %>/cart/update', {action:'check', id:id, checked:checked?1:0}, function(res) {
        if (res && res.code === 200) refreshCart();
    });
}
function checkAll(checked) {
    ajax('POST', '<%= request.getContextPath() %>/cart/checkAll', {action:'checkAll', checked:checked?1:0}, function(res) {
        if (res && res.code === 200) location.reload();
    });
}
function updateQty(id, delta) {
    var input = document.getElementById('qty_' + id);
    var v = parseInt(input.value) + delta;
    if (v < 1) v = 1;
    if (v > 99) v = 99;
    input.value = v;
    ajax('POST', '<%= request.getContextPath() %>/cart/update', {action:'update', id:id, num:v}, function(res) {
        if (res && res.code === 200) location.reload();
    });
}
function setQty(id, val) {
    var v = parseInt(val) || 1;
    if (v < 1) v = 1;
    document.getElementById('qty_' + id).value = v;
    ajax('POST', '<%= request.getContextPath() %>/cart/update', {action:'update', id:id, num:v}, function(res) {
        if (res && res.code === 200) location.reload();
    });
}
function removeItem(id) {
    if (confirm('Remove this item?')) {
        ajax('POST', '<%= request.getContextPath() %>/cart/delete', {action:'delete', id:id}, function(res) {
            if (res && res.code === 200) location.reload();
        });
    }
}
function deleteChecked() {
    if (confirm('Delete all selected items?')) {
        ajax('POST', '<%= request.getContextPath() %>/cart/deleteChecked', {action:'deleteChecked'}, function(res) {
            if (res && res.code === 200) location.reload();
        });
    }
}
function checkout() {
    var selected = document.querySelectorAll('.item-check:checked').length;
    if (selected === 0) { alert('Please select items to checkout'); return; }
    if (confirm('Place order for ' + selected + ' items?')) {
        ajax('POST', '<%= request.getContextPath() %>/cart/checkout', {action:'checkout'}, function(res) {
            if (res && res.code === 200) {
                showToast('Order placed successfully!', 'success');
                setTimeout(function() { location.reload(); }, 1000);
            } else {
                showToast('Checkout failed. Please try again.', 'error');
            }
        });
    }
}
function refreshCart() { location.reload(); }
</script>
<script src="<%= request.getContextPath() %>/js/global.js"></script>
</body>
</html>

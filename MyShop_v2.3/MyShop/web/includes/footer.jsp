<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="site-footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col">
                <h4>MYSHOP</h4>
                <p>A modern e-commerce platform built with care. We deliver quality products with exceptional service.</p>
            </div>
            <div class="footer-col">
                <h4>Shop</h4>
                <a href="<%= request.getContextPath() %>/goods/list.jsp?categoryId=21">Mobile & Digital</a>
                <a href="<%= request.getContextPath() %>/goods/list.jsp?categoryId=1">Fashion</a>
                <a href="<%= request.getContextPath() %>/goods/list.jsp?categoryId=5">Food & Drinks</a>
                <a href="<%= request.getContextPath() %>/goods/list.jsp?categoryId=11">Jewelry</a>
            </div>
            <div class="footer-col">
                <h4>About</h4>
                <a href="#">Our Story</a>
                <a href="#">Careers</a>
                <a href="#">Press</a>
                <a href="#">Sustainability</a>
            </div>
            <div class="footer-col">
                <h4>Support</h4>
                <a href="#">Help Center</a>
                <a href="#">Shipping Info</a>
                <a href="#">Returns</a>
                <a href="#">Contact Us</a>
            </div>
            <div class="footer-col">
                <h4>Legal</h4>
                <a href="#">Terms of Service</a>
                <a href="#">Privacy Policy</a>
                <a href="#">Cookie Policy</a>
            </div>
        </div>
        <div class="footer-bottom">
            &copy; 2026 MyShop. All rights reserved.
        </div>
    </div>
</footer>

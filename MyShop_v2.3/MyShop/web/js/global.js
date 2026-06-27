/* global.js - Shared functionality across all pages */

// Scroll header effect
window.addEventListener('scroll', function() {
    document.getElementById('siteHeader').classList.toggle('scrolled', window.scrollY > 10);
});

// Mobile menu toggle
function toggleMenu() {
    document.getElementById('hamburger').classList.toggle('active');
    document.getElementById('mobileNav').classList.toggle('active');
}

// Toast notifications
function showToast(msg, type) {
    var t = document.getElementById('toast') || (function() {
        var el = document.createElement('div'); el.id = 'toast'; el.className = 'toast';
        document.body.appendChild(el); return el;
    })();
    t.className = 'toast ' + (type || 'success'); t.textContent = msg; t.style.display = 'block';
    setTimeout(function() { t.style.display = 'none'; }, 2500);
}

// AJAX helper
function ajax(method, url, data, callback) {
    var xhr = new XMLHttpRequest();
    xhr.open(method, url, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    if (method === 'POST') xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            try { callback(JSON.parse(xhr.responseText)); }
            catch(e) { callback(null); }
        }
    };
    xhr.send(data ? new URLSearchParams(data).toString() : null);
}

// Add to cart
function addToCart(goodsId, num) {
    ajax('POST', '<%= request.getContextPath() %>/cart/add', {action:'add', goodsId:goodsId, num:num||1}, function(res) {
        if (res && res.code === 200) {
            showToast('Added to cart', 'success');
            updateCartBadge();
        } else {
            showToast('Please login first', 'error');
        }
    });
}

function updateCartBadge() {
    var badge = document.getElementById('cartBadge');
    if (!badge) return;
    var count = parseInt(badge.textContent || '0') + 1;
    badge.textContent = count;
    badge.classList.add('show');
}

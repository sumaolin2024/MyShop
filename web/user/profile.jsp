<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.myshop.entity.*" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null) { response.sendRedirect(request.getContextPath() + "/user/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Account — MyShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css">
    <style>
        .profile-page { margin-top: calc(var(--hdr-h) + 40px); padding-bottom: 80px; }
        .profile-layout { display: flex; gap: 40px; }
        .profile-sidebar { width: 200px; flex-shrink: 0; }
        .profile-sidebar a { display: block; font-size: 13px; padding: 10px 0; color: var(--c-gray); border-bottom: 1px solid var(--c-border); transition: var(--trans); }
        .profile-sidebar a:hover, .profile-sidebar a.active { color: var(--c-black); font-weight: 500; }
        .profile-main { flex: 1; }
        .profile-card { background: var(--c-bg); padding: 32px; border-radius: var(--radius); margin-bottom: 24px; }
        .profile-card h3 { font-size: 18px; font-weight: 500; margin-bottom: 20px; }
        .profile-info { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; font-size: 14px; }
        .profile-info dt { color: var(--c-gray); font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px; }
        .profile-info dd { margin-bottom: 12px; }
        .order-list { display: flex; flex-direction: column; gap: 16px; }
        .order-item { background: var(--c-bg); padding: 20px 24px; border-radius: var(--radius); display: flex; justify-content: space-between; align-items: center; }
        .order-item-meta { font-size: 13px; color: var(--c-gray); }
        .order-status { font-size: 12px; font-weight: 600; padding: 4px 12px; border-radius: 12px; }
        .order-status.unpaid { background: #fff3cd; color: #856404; }
        .order-status.paid { background: #d4edda; color: #155724; }
        .order-status.shipped { background: #cce5ff; color: #004085; }
        .order-status.done { background: #d1ecf1; color: #0c5460; }
        .order-status.cancelled { background: #f8d7da; color: #721c24; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        @media (max-width: 768px) { .profile-layout { flex-direction: column; } .profile-sidebar { width: 100%; display: flex; gap: 12px; overflow-x: auto; } .profile-sidebar a { border-bottom: none; white-space: nowrap; } }
    </style>
</head>
<body>
<%@ include file="/includes/header.jsp" %>

<div class="container profile-page">
    <h2>My Account</h2>
    <div class="profile-layout mt-20">
        <aside class="profile-sidebar">
            <a href="#" class="active" onclick="showTab('overview',this)">Overview</a>
            <a href="#" onclick="showTab('orders',this)">My Orders</a>
            <a href="#" onclick="showTab('password',this)">Change Password</a>
            <a href="<%= request.getContextPath() %>/user/logout" style="color:var(--c-red);">Sign Out</a>
        </aside>
        <main class="profile-main">
            <div class="tab-content active" id="tab-overview">
                <div class="profile-card">
                    <h3>Profile</h3>
                    <dl class="profile-info">
                        <dt>Username</dt>
                        <dd><strong><%= sessionUser.getUsername() %></strong></dd>
                        <dt>Member Since</dt>
                        <dd>2026</dd>
                        <dt>Avatar</dt>
                        <dd><%= sessionUser.getAvatar() != null && !sessionUser.getAvatar().isEmpty() ? sessionUser.getAvatar() : "Not set" %></dd>
                    </dl>
                </div>
                <div class="profile-card">
                    <h3>Quick Links</h3>
                    <div style="display:flex;gap:12px;flex-wrap:wrap;">
                        <a href="<%= request.getContextPath() %>/cart/index.jsp" class="btn btn-outline">View Cart</a>
                        <a href="<%= request.getContextPath() %>/goods/list.jsp" class="btn btn-outline">Browse Products</a>
                    </div>
                </div>
            </div>
            <div class="tab-content" id="tab-orders">
                <div class="profile-card">
                    <h3>My Orders</h3>
                    <p class="text-gray" style="text-align:center;padding:40px 0;">You haven't placed any orders yet.</p>
                    <a href="<%= request.getContextPath() %>/goods/list.jsp" class="btn btn-primary" style="display:block;width:fit-content;margin:0 auto;">Start Shopping</a>
                </div>
            </div>
            <div class="tab-content" id="tab-password">
                <div class="profile-card">
                    <h3>Change Password</h3>
                    <form onsubmit="return changePassword()">
                        <div class="form-group"><label class="form-label">Current Password</label><input type="password" id="oldPwd" class="form-input" required></div>
                        <div class="form-group"><label class="form-label">New Password</label><input type="password" id="newPwd" class="form-input" required minlength="6"></div>
                        <button type="submit" class="btn btn-primary">Update Password</button>
                    </form>
                    <div id="pwdMsg" style="margin-top:12px;font-size:13px;"></div>
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<script>
function showTab(tab, el) {
    document.querySelectorAll('.tab-content').forEach(function(t) { t.classList.remove('active'); });
    document.getElementById('tab-' + tab).classList.add('active');
    document.querySelectorAll('.profile-sidebar a').forEach(function(a) { a.classList.remove('active'); });
    el.classList.add('active');
}
function changePassword() {
    var old = document.getElementById('oldPwd').value;
    var pwd = document.getElementById('newPwd').value;
    if (pwd.length < 6) { document.getElementById('pwdMsg').textContent = 'New password must be at least 6 characters'; document.getElementById('pwdMsg').style.color = 'var(--c-red)'; return false; }
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '<%= request.getContextPath() %>/user/changePassword', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            try { var r = JSON.parse(xhr.responseText);
                var msg = document.getElementById('pwdMsg');
                if (r.code === 200) { msg.textContent = 'Password updated successfully'; msg.style.color = '#28a745'; }
                else { msg.textContent = r.msg || 'Failed to update password'; msg.style.color = 'var(--c-red)'; }
            } catch(e) {}
        }
    };
    xhr.send('oldPassword=' + encodeURIComponent(old) + '&newPassword=' + encodeURIComponent(pwd));
    return false;
}
</script>
</body>
</html>

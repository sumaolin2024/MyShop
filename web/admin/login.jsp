<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login — MyShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css">
    <style>
        .login-page { min-height:100vh; display:flex; align-items:center; justify-content:center; background:var(--c-bg); }
        .login-card { width:100%; max-width:380px; padding:48px 40px; background:var(--c-white); border-radius:var(--radius); }
        .login-card h1 { font-size:22px; font-weight:500; margin-bottom:8px; }
        .login-card p { color:var(--c-gray); font-size:13px; margin-bottom:32px; }
    </style>
</head>
<body>
<div class="login-page">
    <div class="login-card">
        <h1>Admin Panel</h1><p>Sign in to manage MyShop</p>
        <div id="loginError" style="color:var(--c-red);font-size:13px;margin-bottom:16px;display:none;"></div>
        <form onsubmit="return doLogin()">
            <div class="form-group">
                <label class="form-label">Username</label>
                <input type="text" id="username" class="form-input" placeholder="Admin username" required>
            </div>
            <div class="form-group">
                <label class="form-label">Password</label>
                <input type="password" id="password" class="form-input" placeholder="Admin password" required>
            </div>
            <button type="submit" class="btn btn-primary btn-lg" style="width:100%;">Sign In</button>
        </form>
    </div>
</div>
<script>
function doLogin() {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '<%= request.getContextPath() %>/admin/login', true);
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            try { var r = JSON.parse(xhr.responseText);
                if (r.code === 200) window.location.href = '<%= request.getContextPath() %>/admin/dashboard';
                else { document.getElementById('loginError').textContent = r.msg || 'Login failed'; document.getElementById('loginError').style.display = 'block'; }
            } catch(e) {}
        }
    };
    xhr.send('username=' + encodeURIComponent(document.getElementById('username').value) + '&password=' + encodeURIComponent(document.getElementById('password').value));
    return false;
}
</script>
</body>
</html>

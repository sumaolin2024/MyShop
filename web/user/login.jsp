<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — MyShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css">
    <style>
        .login-page { min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .login-card { width: 100%; max-width: 400px; padding: 48px 40px; }
        .login-card h1 { font-size: 28px; font-weight: 500; margin-bottom: 8px; letter-spacing: 1px; }
        .login-card p { color: var(--c-gray); font-size: 14px; margin-bottom: 32px; }
        .login-error { color: var(--c-red); font-size: 13px; margin-bottom: 16px; display: none; text-align: center; }
        .login-footer { text-align: center; margin-top: 24px; font-size: 13px; color: var(--c-gray); }
        .login-footer a { color: var(--c-black); font-weight: 500; text-decoration: underline; }
    </style>
</head>
<body>
<div class="login-page">
    <div class="login-card">
        <h1>Welcome back</h1>
        <p>Sign in to your MyShop account</p>
        <div class="login-error" id="loginError">Invalid username or password</div>
        <form id="loginForm" onsubmit="return doLogin()">
            <div class="form-group">
                <label class="form-label">Username</label>
                <input type="text" name="username" id="username" class="form-input" placeholder="Enter your username" required>
            </div>
            <div class="form-group">
                <label class="form-label">Password</label>
                <input type="password" name="password" id="password" class="form-input" placeholder="Enter your password" required>
            </div>
            <button type="submit" class="btn btn-primary btn-lg" style="width:100%;margin-top:8px;">Sign In</button>
        </form>
        <div class="login-footer">
            Don't have an account? <a href="<%= request.getContextPath() %>/user/register.jsp">Create one</a>
        </div>
    </div>
</div>

<script>
function doLogin() {
    var username = document.getElementById('username').value;
    var password = document.getElementById('password').value;
    var params = 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password);
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '<%= request.getContextPath() %>/user/login', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            try {
                var res = JSON.parse(xhr.responseText);
                if (res.code === 200) {
                    window.location.href = '<%= request.getContextPath() %>/';
                } else {
                    document.getElementById('loginError').style.display = 'block';
                }
            } catch(e) {
                document.getElementById('loginError').style.display = 'block';
            }
        }
    };
    xhr.send(params);
    return false;
}
</script>
</body>
</html>

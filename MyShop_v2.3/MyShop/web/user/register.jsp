<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — MyShop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css">
    <style>
        .reg-page { min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .reg-card { width: 100%; max-width: 400px; padding: 48px 40px; }
        .reg-card h1 { font-size: 28px; font-weight: 500; margin-bottom: 8px; letter-spacing: 1px; }
        .reg-card p { color: var(--c-gray); font-size: 14px; margin-bottom: 32px; }
        .reg-error { color: var(--c-red); font-size: 13px; margin-bottom: 16px; display: none; text-align: center; }
        .reg-success { color: #28a745; font-size: 13px; margin-bottom: 16px; display: none; text-align: center; }
        .pwd-strength { height: 3px; border-radius: 2px; margin-top: 6px; transition: var(--trans); }
        .reg-footer { text-align: center; margin-top: 24px; font-size: 13px; color: var(--c-gray); }
        .reg-footer a { color: var(--c-black); font-weight: 500; text-decoration: underline; }
    </style>
</head>
<body>
<div class="reg-page">
    <div class="reg-card">
        <h1>Create account</h1>
        <p>Join MyShop and start shopping</p>
        <div class="reg-error" id="regError"></div>
        <div class="reg-success" id="regSuccess"></div>
        <form id="regForm" onsubmit="return doRegister()">
            <div class="form-group">
                <label class="form-label">Username</label>
                <input type="text" name="username" id="username" class="form-input" placeholder="Choose a username" required onblur="checkUsername()">
                <span id="usernameHint" style="font-size:11px;color:var(--c-gray);"></span>
            </div>
            <div class="form-group">
                <label class="form-label">Password</label>
                <input type="password" name="password" id="password" class="form-input" placeholder="At least 6 characters" required oninput="checkStrength()">
                <div class="pwd-strength" id="pwdStrength" style="background:#eee;"></div>
            </div>
            <button type="submit" class="btn btn-primary btn-lg" style="width:100%;margin-top:8px;" id="regBtn">Create Account</button>
        </form>
        <div class="reg-footer">
            Already have an account? <a href="<%= request.getContextPath() %>/user/login.jsp">Sign in</a>
        </div>
    </div>
</div>

<script>
function checkStrength() {
    var pwd = document.getElementById('password').value;
    var strength = 0;
    if (pwd.length >= 6) strength++;
    if (pwd.length >= 10) strength++;
    if (/[A-Z]/.test(pwd) || /[!@#$%^&*]/.test(pwd)) strength++;
    var bar = document.getElementById('pwdStrength');
    var colors = ['#ddd','var(--c-red)','#ffc107','#28a745'];
    bar.style.width = (strength * 33) + '%';
    bar.style.background = colors[Math.min(strength, 3)];
}
var usernameOk = false;
function checkUsername() {
    var u = document.getElementById('username').value;
    if (u.length < 2) { document.getElementById('usernameHint').textContent = ''; return; }
    ajax('GET', '<%= request.getContextPath() %>/user/checkUsername?username=' + encodeURIComponent(u), null, function(res) {
        var hint = document.getElementById('usernameHint');
        if (res && res.exists) { hint.textContent = 'This username is taken'; hint.style.color = 'var(--c-red)'; usernameOk = false; }
        else { hint.textContent = 'Username is available'; hint.style.color = '#28a745'; usernameOk = true; }
    });
}
function doRegister() {
    var username = document.getElementById('username').value;
    var password = document.getElementById('password').value;
    if (password.length < 6) { document.getElementById('regError').textContent = 'Password must be at least 6 characters'; document.getElementById('regError').style.display = 'block'; return false; }
    var params = 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password);
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '<%= request.getContextPath() %>/user/register', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            try { var res = JSON.parse(xhr.responseText);
                if (res.code === 200) {
                    document.getElementById('regSuccess').textContent = 'Account created! Redirecting...';
                    document.getElementById('regSuccess').style.display = 'block';
                    setTimeout(function() { window.location.href = '<%= request.getContextPath() %>/user/login.jsp'; }, 1500);
                } else {
                    document.getElementById('regError').textContent = res.msg || 'Registration failed';
                    document.getElementById('regError').style.display = 'block';
                }
            } catch(e) { document.getElementById('regError').textContent = 'Server error'; document.getElementById('regError').style.display = 'block'; }
        }
    };
    xhr.send(params);
    return false;
}
function ajax(method, url, data, cb) {
    var x = new XMLHttpRequest();
    x.open(method, url, true);
    x.onreadystatechange = function() { if (x.readyState === 4) { try { cb(JSON.parse(x.responseText)); } catch(e) { cb(null); } } };
    x.send(data ? new URLSearchParams(data).toString() : null);
}
</script>
</body>
</html>

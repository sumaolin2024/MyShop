package com.myshop.controller;
import com.myshop.entity.*;
import com.myshop.service.*;
import com.myshop.util.JsonUtil;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

public class UserServlet extends HttpServlet {
    private UserService userService = new UserService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/logout".equals(path)) {
            req.getSession().invalidate();
            resp.sendRedirect("/index.jsp");
        } else if ("/checkUsername".equals(path)) {
            String username = req.getParameter("username");
            resp.setContentType("application/json;charset=UTF-8");
            boolean exists = userService.usernameExists(username);
            resp.getWriter().write(exists ? "{\"exists\":true}" : "{\"exists\":false}");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getPathInfo();
        resp.setContentType("application/json;charset=UTF-8");

        if ("/login".equals(path)) {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            User user = userService.login(username, password);
            if (user != null) {
                req.getSession().setAttribute("user", user);
                resp.getWriter().write(JsonUtil.success());
            } else {
                resp.getWriter().write(JsonUtil.error("Wrong username or password"));
            }
        } else if ("/register".equals(path)) {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            int result = userService.register(username, password);
            if (result > 0) {
                resp.getWriter().write(JsonUtil.success());
            } else if (result == -2) {
                resp.getWriter().write(JsonUtil.error("Username already exists"));
            } else {
                resp.getWriter().write(JsonUtil.error("Registration failed"));
            }
        } else if ("/changePassword".equals(path)) {
            User user = (User) req.getSession().getAttribute("user");
            if (user == null) { resp.getWriter().write(JsonUtil.error(401, "Please login")); return; }
            String oldPwd = req.getParameter("oldPassword");
            String newPwd = req.getParameter("newPassword");
            boolean ok = userService.changePassword(user.getId(), oldPwd, newPwd);
            resp.getWriter().write(ok ? JsonUtil.success() : JsonUtil.error("Old password is incorrect"));
        }
    }
}

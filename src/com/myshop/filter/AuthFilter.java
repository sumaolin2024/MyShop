package com.myshop.filter;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {
    public void init(FilterConfig cfg) {}
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        String path = request.getRequestURI();

        if (path.startsWith("/admin/")) {
            Object admin = request.getSession().getAttribute("admin");
            if (admin == null) { response.sendRedirect("/user/login.jsp"); return; }
        } else {
            Object user = request.getSession().getAttribute("user");
            if (user == null) { response.sendRedirect("/user/login.jsp"); return; }
        }
        chain.doFilter(req, resp);
    }
    public void destroy() {}
}

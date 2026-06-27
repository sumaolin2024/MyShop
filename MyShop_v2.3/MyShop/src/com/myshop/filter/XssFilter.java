package com.myshop.filter;
import com.myshop.util.XssUtil;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.io.IOException;

public class XssFilter implements Filter {
    public void init(FilterConfig cfg) {}
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        chain.doFilter(new XssRequestWrapper((HttpServletRequest) req), resp);
    }
    public void destroy() {}

    private static class XssRequestWrapper extends HttpServletRequestWrapper {
        public XssRequestWrapper(HttpServletRequest request) { super(request); }
        public String getParameter(String name) {
            String value = super.getParameter(name);
            return XssUtil.escape(value);
        }
        public String[] getParameterValues(String name) {
            String[] values = super.getParameterValues(name);
            if (values == null) return null;
            String[] escaped = new String[values.length];
            for (int i = 0; i < values.length; i++) escaped[i] = XssUtil.escape(values[i]);
            return escaped;
        }
    }
}

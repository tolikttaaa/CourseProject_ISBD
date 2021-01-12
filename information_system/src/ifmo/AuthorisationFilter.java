package ifmo;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.ServletException;
import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@WebFilter("/AuthorisationFilter")
public class AuthorisationFilter implements Filter {
    private FilterConfig filterConfig;

    @Override
    public void destroy() {
        filterConfig = null;
    }

    @Override
    public void init(FilterConfig fConfig) throws ServletException {
        filterConfig = fConfig;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain filterChain) throws ServletException, IOException {
        if (filterConfig.getInitParameter("active").equalsIgnoreCase("true")) {
            HttpServletRequest req = (HttpServletRequest) request;

            String[] list = req.getRequestURI().split("/");
            String page = null;
            if (list[list.length - 1].indexOf(".jsp") > 0) {
                page = list[list.length - 1];
            }

            ServletContext ctx = filterConfig.getServletContext();

            if (page != null && page.equalsIgnoreCase("logout.jsp")) {
                RequestDispatcher dispatcher = ctx.getRequestDispatcher("/index.jsp");
                ctx.removeAttribute("curUserRole");
                dispatcher.forward(request, response);

                return;
            }

            if (page != null
                && (!page.equalsIgnoreCase("index.jsp")
                    && !page.equalsIgnoreCase("login.jsp")
                    && !page.equalsIgnoreCase("register_person.jsp"))
                && ctx.getAttribute("curUserRole") == null) {
                RequestDispatcher dispatcher = ctx.getRequestDispatcher("/login.jsp");
                dispatcher.forward(request, response);

                return;
            }
        }

        filterChain.doFilter(request, response);
    }
}
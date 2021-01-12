package ifmo;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/StartChampionship")
public class StartChampionship extends HttpServlet {
    private ServletConfig config;

    @Override
    public void init(ServletConfig config) throws ServletException {
        this.config = config;
    }

    @Override
    public void destroy() {
    }

    @Override
    public ServletConfig getServletConfig() {
        return config;
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (config.getServletContext().getAttribute("curUserRole").equals("user")) {
                response.sendRedirect("index.jsp");
            }
            if (config.getServletContext().getAttribute("curUserRole").equals("admin")) {


                Connection con = DatabaseConnection.getConnection();

                PreparedStatement st = con
                        .prepareStatement("SELECT start_championship(?);");

                st.setInt(1, Integer.parseInt(request.getParameter("start_championship_id")));

                st.executeQuery();

                st.close();
                con.close();
            }

            request.getRequestDispatcher("/championships.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("championships.jsp");
        }
    }
}

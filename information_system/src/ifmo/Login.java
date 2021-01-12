package ifmo;


import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/Login")
public class Login extends HttpServlet {
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement st = con.prepareStatement(
                    "SELECT last_name, role FROM people " +
                            "JOIN email ON people.person_id = email.person_id " +
                            "WHERE email.email = ?");
            st.setString(1, request.getParameter("login"));

            ResultSet rs = st.executeQuery();
            rs.next();

            String curUserLastName = rs.getString("last_name");

            if (curUserLastName.equals(request.getParameter("password"))) {
                HttpSession session = request.getSession(true);

                String role;
                if (rs.getString("role") == null) {
                    role = "user";
                } else if (rs.getString("role").equals("admin")) {
                    role = "admin";
                } else {
                    role = "user";
                }

                System.err.println(role);
                config.getServletContext().setAttribute("curUserRole", role);

                response.sendRedirect("index.jsp");
            } else {
                response.sendRedirect("login.jsp");
            }
            st.close();
            con.close();
        } catch (Exception e) {
            response.sendRedirect("login.jsp");
            e.printStackTrace();
        }
    }
}

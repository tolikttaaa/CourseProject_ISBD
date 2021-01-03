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
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/PersonalInfo")
public class InformationAboutPerson extends HttpServlet {
    private List<Person> list = null;
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
        list = new ArrayList<Person>();
        config.getServletContext().setAttribute("list", list);

        try {

            Connection con = DatabaseConnection.getConnection();

            PreparedStatement st = con.prepareStatement(
                    "SELECT first_name, last_name, birth_date FROM people " +
                            "WHERE last_name = ?");
            st.setString(1, request.getParameter("search_last_name"));
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                String curUserFirstName = rs.getString("first_name");
                String curUserLastName = rs.getString("last_name");
                String curUserBirthDate = rs.getString("birth_date");

                Person p = new Person(curUserFirstName, curUserLastName, curUserBirthDate);
                list.add(p);
            }
            response.sendRedirect("info_response.jsp");
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}

package ifmo;


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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement st = con.prepareStatement(
                    "SELECT last_name FROM people " +
                            "JOIN email ON people.person_id = email.person_id " +
                            "WHERE email.email = ?");
            st.setString(1, request.getParameter("login"));

            ResultSet rs = st.executeQuery();
            rs.next();

            String curUserLastName = rs.getString("last_name");
            if (curUserLastName.equals(request.getParameter("password"))) {
                HttpSession session = request.getSession(true);
                session.setAttribute("currentSessionUser", request.getParameter("login"));

                response.sendRedirect("index.jsp");
            } else {
                request.getParameter("");
                response.sendRedirect("login.jsp");
            }
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

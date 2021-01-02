package ifmo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;

@WebServlet("/StartChampionship")
public class StartChampionship extends HttpServlet {
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        try {

            Connection con = DatabaseConnection.getConnection();

            PreparedStatement st = con
                    .prepareStatement("SELECT start_championship(?);");

            st.setString(1, request.getParameter("start_championship_id"));

            st.executeQuery();

            st.close();
            con.close();

            request.getRequestDispatcher("/championships.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

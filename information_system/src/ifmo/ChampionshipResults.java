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

@WebServlet("/GetResults")
public class ChampionshipResults extends HttpServlet {
    private List<Championship> championships = null;
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
        championships = new ArrayList<Championship>();
        config.getServletContext().setAttribute("championships", championships);

        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement st = con.prepareStatement(
                    "SELECT place, final_score, name, special_award FROM score " +
                            "JOIN team ON score.team_id = team.team_id WHERE championship_id = ?");

            st.setInt(1, Integer.valueOf(request.getParameter("result_championship_id")));

            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                String curPlace = rs.getString("place");
                String curScore = rs.getString("final_score");
                String curName = rs.getString("name");
                String curAward = rs.getString("special_award");

                Championship championship = new Championship(curPlace, curScore, curName, curAward);
                championships.add(championship);
            }

            st.close();
            con.close();

            response.sendRedirect("results_response.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("results.jsp");
        }

    }
}


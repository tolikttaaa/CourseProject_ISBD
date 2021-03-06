package ifmo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/InsertData")
public class InsertData extends HttpServlet {
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException
    {
        try {

            // Initialize the database
            Connection con = DatabaseConnection.getConnection();

            // Create a SQL query to insert data into demo table
            // demo table consists of two columns, so two '?' is used
            PreparedStatement st = con
                    .prepareStatement("SELECT insert_person(?,?,?,?,?,?);");

            st.setString(1, request.getParameter("first_name"));
            st.setString(2, request.getParameter("last_name"));
            st.setDate(3, Date.valueOf(request.getParameter("birth_date")));
            st.setString(4, request.getParameter("phone_number"));
            st.setString(5, request.getParameter("email"));
            st.setString(6, request.getParameter("admin_role"));

            st.executeQuery();

            st.close();
            con.close();

            request.getRequestDispatcher("/login.jsp").forward(request, response);

        }
        catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register_person.jsp");
        }
    }
}
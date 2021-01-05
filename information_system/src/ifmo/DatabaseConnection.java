package ifmo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// This class can be used to initialize the database connection
public class DatabaseConnection {
    protected static Connection getConnection()
            throws SQLException, ClassNotFoundException
    {
        // Initialize all the information regarding
        // Database Connection
        String dbDriver = "org.postgresql.Driver";
        String dbURL = "jdbc:postgresql://pg:5432/";
        // Database name to access
        String dbName = "studs";
        String dbUsername = "s******";
        String dbPassword = "******";

        Class.forName(dbDriver);
        Connection con = DriverManager.getConnection(dbURL + dbName,
                dbUsername,
                dbPassword);
        return con;
    }
}
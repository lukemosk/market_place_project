package cs336;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public abstract class ApplicationDB {
	
	public static Connection getConnection(){
		String connectionUrl = "jdbc:mysql://localhost:3306/cs336project";
		Connection connection = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		try {
			connection = DriverManager.getConnection(connectionUrl, "root", "Somecles#10");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return connection;
	}
	
	public static void closeConnection(Connection connection){
		try {
			connection.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}

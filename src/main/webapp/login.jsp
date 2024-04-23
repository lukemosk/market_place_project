<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login Result</title>
</head>
<body>
<% // <-- this (<%)  is our opening scriptlet tag, so we can actually code in java within the HTML of our JSP file.

	// Retrieve username and password from the request parameters
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	
	// Declare JDBC objects
	Connection conn = null;
	PreparedStatement pst = null;
	ResultSet rs = null;
	
	// Sample login credentials u:'admin' p:'1234' which lead to a 'Welcome' page.
	try { 
		// Load MySQL JDBC driver so we can use database connections.
		Class.forName("com.mysql.jdbc.Driver"); 
		// Establish connection with the database, ***replace 'yourpassword' with your personal SQL password***
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_system", "root", "root");
		// Here we prepare a SQL query to find the user with the given username/password.
		pst = conn.prepareStatement("SELECT * FROM users WHERE username=? AND password=?");
		// Set first parameter (username) then the second parameter (password) in the SQL query.
        pst.setString(1, username);
        pst.setString(2, password);
        // Execute the query, then the results are stored in rs.
        rs = pst.executeQuery();
        
        // Checking if any row is returned
        if(rs.next()) {
        	// This will set username as an attribute in the session to maintain the user state.
        	session.setAttribute("User", username);
        	// Welcome message if the login works
        	out.println("<h1>Welcome, " + username + "!</h1>");
        	// logout link
        	out.println("<a href=logout.jsp>Logout</a>");
        } else {
        	// if the login fails we say something was wrong and prompt the user with a try again link
        	out.println("<h1>Login Failed: Incorrect username or password.</h1>");
            out.println("<a href='login.html'>Try again</a>");
        }

	} catch(Exception e) {
		   // Handle exceptions by printing an error message to the user
		out.println("Database connection problem: " + e.getMessage());
		   
	} finally {
	    // Attempt to close ResultSet, PreparedStatement, and Connection to release database resources
		if(rs != null) try {rs.close(); } catch(SQLException e) {}
		if(pst != null) try {rs.close(); } catch(SQLException e) {}
		if(conn != null) try {rs.close(); } catch(SQLException e) {}
	}
%>
</body>	
</html>
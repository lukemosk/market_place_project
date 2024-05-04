<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="cs336.Queries"%>
<%@ page import="cs336.ApplicationDB"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login Result</title>
</head>
<body>
	<h2>Register</h2>
	<form action="register.jsp" method="POST">
		Username: <input type="text" name="username" required><br>
		Password: <input type="password" name="password" required><br>
		<input type="submit" value="Register">
	</form>
	<p>Back to Login</p>
	<form action="login.jsp" method="POST">
		<button>Login</button>
	</form>
	<br><br>
	<%
	// If they are logged in, send them to home page
	if(session.getAttribute("user") != null) {
		response.sendRedirect("home.jsp");
	}
	
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	
	if(username == null || password == null)
		return;

	try {
		Connection conn = ApplicationDB.getConnection();
		
		if (conn == null){
			out.println("<h1>Login Failed: SQL Error.</h1>");
			return;
		}
		
		String query = Queries.createLoginUser(username, password);
		
		try {
			conn.prepareStatement(query).executeUpdate();
			session.setAttribute("user", username);
			session.setAttribute("type", "default");
			response.sendRedirect("home.jsp");
		} catch (SQLIntegrityConstraintViolationException e) {
			out.println("<h2>Registration Failed: A user with that name already exists!</h2>");
			out.println("<h2>Please try again</h2>");
		}
		
		conn.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>
</body>
</html>

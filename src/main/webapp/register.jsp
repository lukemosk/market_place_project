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
	<%
	String username = request.getParameter("username");
	String password = request.getParameter("password");

	try {
		Connection conn = ApplicationDB.getConnection();
		
		String checkUserQuery = Queries.getLoginUser(username);
		ResultSet rs = conn.prepareStatement(checkUserQuery).executeQuery();
		
		if(rs.next()) {
			out.println("<h1>Registration Failed: A user with that name already exists!</h1>");
			out.println("<a href='register.html'>Try again</a>");
		} else {
			String[] queries = Queries.createLoginUser(username, password);
			conn.prepareStatement(queries[0]).executeUpdate();
			conn.prepareStatement(queries[1]).executeUpdate();
			conn.prepareStatement(queries[2]).executeUpdate();
			
			session.setAttribute("user", username);
			out.println("<h1>Welcome, " + username + "! You have successfully registered.</h1>");
			out.println("<a href=home.html>Home</a>");
			out.println("<a href=logout.jsp>Logout</a>");
		}

		conn.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>
</body>
</html>

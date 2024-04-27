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
		PreparedStatement pst = conn.prepareStatement(Queries.getLoginUser(username, password));
		ResultSet rs = pst.executeQuery();

		if (rs.next()) {
			session.setAttribute("user", username);
			out.println("<h1>Welcome, " + username + "!</h1>");
			out.println("<a href=home.html>Home</a>");
			out.println("<a href=logout.jsp>Logout</a>");
		} else {
			out.println("<h1>Login Failed: Incorrect username or password.</h1>");
			out.println("<a href='login.html'>Try again</a>");
		}

		conn.close();
		pst.close();
		rs.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>
</body>
</html>

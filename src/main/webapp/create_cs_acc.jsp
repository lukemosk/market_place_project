<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="cs336.Queries"%>
<%@ page import="cs336.ApplicationDB"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Create CS Account</title>
</head>
<body>
	<%
	if(session.getAttribute("user") == null) {
		response.sendRedirect("login.jsp");
	} else {
		String type = (String) session.getAttribute("type");
		if (!type.equals("admin")) {
			out.println("<h1>You do not have permission for this.</h1>");
			out.println("<a href='home.jsp'>Home</a>");
			return;
		}
	}
	%>
	<h2>Register a CS User</h2>
	<form action="create_cs_acc.jsp" method="POST">
		Username: <input type="text" name="username" required><br>
		Password: <input type="password" name="password" required><br>
		<input type="submit" value="Create CS Account">
	</form>
	<p>Back to Panel</p>
	<form action="admin_panel.jsp" method="POST">
		<button>Go Back</button>
	</form>
	
	<%
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	
	if(username == null || password == null)
		return;

	try {
		Connection conn = ApplicationDB.getConnection();
		String createCSUserQuery = Queries.createCSUser(username, password);
		
		try {
			conn.prepareStatement(createCSUserQuery).executeUpdate();
			out.println("<h2>Successfully created CS User!</h2>");
		} catch (SQLIntegrityConstraintViolationException e) {
			out.println("<h2>Registration for CS User Failed: A (maybe regular) user with that name already exists!</h2>");
			out.println("<h2>Please try again</h2>");
		}
		conn.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>
</body>
</html>

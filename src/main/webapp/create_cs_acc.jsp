<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="cs336.Queries"%>
<%@ page import="cs336.ApplicationDB"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Create CS Account Result</title>
</head>
<body>
	<%
	String username = request.getParameter("username");
	String password = request.getParameter("password");

	try {	
		if(session.getAttribute("user") == null) {
			out.println("<h1>You must be logged in to do this.</h1>");
			out.println("<a href='login.html'>Login</a>");
			return;
		}
		
		Connection conn = ApplicationDB.getConnection();
		
		String userTypeQuery = Queries.getUserType((String) session.getAttribute("user"));
		ResultSet rs = conn.prepareStatement(userTypeQuery).executeQuery();
		
		if(rs.next()) {
			String userType = rs.getString(1);
			if(!userType.equals("admin")) {
				out.println("<h1>You do not have permission for this.</h1>");
				out.println("<a href='home.html'>Home</a>");
				rs.close();
				return;
			}
		} else {
			rs.close();
			return;
		}
		
		rs.close();
		rs = null;
		
		String checkUserQuery = Queries.getLoginUser(username);
		rs = conn.prepareStatement(checkUserQuery).executeQuery();
		
		if(rs.next()) {
			out.println("<h1>CS Registration Failed: A user with that name already exists!</h1>");
			out.println("<a href='create_cs_acc.html'>Try again</a>");
		} else {
			String[] queries = Queries.createCSUser(username, password);
			conn.prepareStatement(queries[0]).executeUpdate();
			conn.prepareStatement(queries[1]).executeUpdate();
			conn.prepareStatement(queries[2]).executeUpdate();
			
			out.println("<h1>You have successfully registered this CS user.</h1>");
			out.println("<a href=admin_panel.html>Back</a>");
		}

		conn.close();
		rs.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>
</body>
</html>

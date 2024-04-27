<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Logout</title>
</head>
<body> 
	<% 
	if(session.getAttribute("user") == null) {
		out.println("<h1>You are not logged in!</h1><br>");
		out.println("<a href='login.html'>Login</a>");
	} else {
		session.invalidate(); 
		out.println("<h1>You have been logged out</h1><br>");
		out.println("<a href='login.html'>Login Again</a>");
	}
	%> 
</body>
</html>
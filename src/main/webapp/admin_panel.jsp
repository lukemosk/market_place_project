<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel</title>
    <style>
        .button {
            background-color: #4CAF50;
            border: none;
            color: white;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
        }
    </style>
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
    <h1>Please select an action:</h1>
    <a href="create_cs_acc.jsp" class="button">Create a CS Account</a>
    <a href="sales_report.jsp" class="button">Generate a Sales Report</a>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="cs336.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
    <title>Home Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 50px;
        }
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
		out.println("<h1>Welcome, " + session.getAttribute("user") + "!</h1>");
	}
	%>
    <p>What would you like to do today?</p>
    <a href="browseAuctions.jsp" class="button">Browse/Buy Products</a>
    <a href="sell_car.jsp" class="button">Sell Car</a>
    <a href="sell_boat.jsp" class="button">Sell Boat</a>
    <a href="sell_motorbike.jsp" class="button">Sell Motorbike</a>
    <a href="faq.jsp" class="button">View/Post FAQs</a>
    <br><br><br><br>
    <%
	String type = (String) session.getAttribute("type");
	if (type.equals("admin")) {
		out.println("<a href=\"admin_panel.jsp\" class=\"button\">Admin Panel</a>");
	}
	if(type.equals("cs") || type.equals("admin")) {
		out.println("<a href=\"edit_users.jsp\" class=\"button\">Edit Users</a>");
	}
    %>
    <br><br><br><br>
    <a href="logout.jsp" class="button">Logout</a>
</body>
</html>
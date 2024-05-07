<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.sql.*, cs336.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
<title>Remove Auction</title>
</head>
<body>
	<%
	if(session.getAttribute("user") == null) {
		response.sendRedirect("login.jsp");
		return;
	} else {
		String type = (String) session.getAttribute("type");
		if (!type.equals("admin") && (!type.equals("cs"))) {
			out.println("<h1>You do not have permission for this.</h1>");
			out.println("<a href='home.jsp'>Home</a>");
			return;
		}
	}
	
	String auction_id = request.getParameter("auction_id");
	
	Connection conn = null;
	try {
		conn = ApplicationDB.getConnection();
		String removeBids = "DELETE FROM bids WHERE auction_id=" + auction_id + ";";
		String removeAuction = "DELETE FROM auctions WHERE auction_id=" + auction_id + ";";
		conn.prepareStatement(removeBids).executeUpdate();
		int affectedRows = conn.prepareStatement(removeAuction).executeUpdate();

		if (affectedRows > 0) {
			out.println("<p>Success. Auction removed!</p>");
		} else {
			out.println("<p>Error: No rows affected.</p>");
		}
	} catch (Exception e) {
		out.println("<p>SQL Error</p>");
	} finally {
		if (conn != null)
			conn.close();
	}
	out.println("<a href='home.jsp'>Home</a>");
	%>
</body>
</html>
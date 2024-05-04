<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.sql.*, cs336.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
<title>Remove Bid</title>
</head>
<body>
	<%
	String bid_id = request.getParameter("bid_id");
	
	Connection conn = null;
	try {
		conn = ApplicationDB.getConnection();
		String removeBid = "DELETE FROM bids WHERE bid_id=" + bid_id;
		int affectedRows = conn.prepareStatement(removeBid).executeUpdate();

		if (affectedRows > 0) {
			out.println("<p>Success. Bid removed!</p>");
		} else {
			out.println("<p>Error: Bid ID not found, no rows affected.</p>");
		}
	} catch (Exception e) {
		out.println("<p>Internal Error</p>");
	} finally {
		if (conn != null)
			conn.close();
	}
	%>
</body>
</html>
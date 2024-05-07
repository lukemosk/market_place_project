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
	
	String bid_id = request.getParameter("bid_id");
	
	Connection conn = null;
	try {
		conn = ApplicationDB.getConnection();
		String auctionID = null;
		String getAuctionID = "SELECT auction_id FROM bids WHERE bid_id=" + bid_id;
		ResultSet rs = conn.prepareStatement(getAuctionID).executeQuery();
		if(rs.next()) {
			auctionID = rs.getString(1);
		} else {
			return;
		}
		
		String removeBid = "DELETE FROM bids WHERE bid_id=" + bid_id;
		String updateAuction = "UPDATE auctions SET current_price = (SELECT max(bid_amount) FROM bids where auction_id=" + auctionID + ") WHERE auction_id=" + auctionID + ";";
		int affectedRows = conn.prepareStatement(removeBid).executeUpdate();

		if (affectedRows > 0) {
			out.println("<p>Success. Bid removed!</p>");
		} else {
			out.println("<p>Error: No rows affected.</p>");
		}
		
		conn.prepareStatement(updateAuction).executeUpdate();
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
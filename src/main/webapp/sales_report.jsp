<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.sql.*, cs336.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
<title>Generate a Sales Report</title>
</head>
<body>
	<%
	if (session.getAttribute("user") == null) {
		response.sendRedirect("login.jsp");
		return;
	} else {
		String type = (String) session.getAttribute("type");
		if (!type.equals("admin")) {
			out.println("<h1>You do not have permission for this.</h1>");
			out.println("<a href='home.jsp'>Home</a>");
			return;
		}
	}
	%>
	<h2>Please select options then hit generate to get a sales report.</h2>
	<form method="POST">
		<button type="submit" name="bestitems" value="bestitems">Best
			Selling Items</button>
		<button type="submit" name="bestbuyer" value="bestbuyer">Best
			Buyers</button>
		<br> <br> <br> 
		<label for="users">User: </label> <select
			name="users" id="users">
			<option label="ALL" value="ALL"></option>
			<%
			try {
				Connection conn = ApplicationDB.getConnection();
				String getAllUsersQuery = "SELECT username FROM users;";
				ResultSet rs = conn.prepareStatement(getAllUsersQuery).executeQuery();

				while (rs.next()) {
					String user = rs.getString(1);
					out.println("<option value=\"" + user + "\">" + user + "</option>");
				}
			} catch (Exception e) {
				return;
			}
			%>
		</select> <br> <br> <label for="itemtype">Item Type: </label> <select
			name="itemtype" id="itemtype">
			<option label="ALL" value="ALL"></option>
			<option value="car">Cars</option>
			<option value="boat">Boats</option>
			<option value="motorbike">Motorcycles</option>
		</select> <br> <br> <label for="item">Item: </label> <select
			name="item" id="item">
			<option label="ALL" value="ALL"></option>
			<%
			try {
				Connection conn = ApplicationDB.getConnection();
				String getAllAuctionsQuery = "SELECT DISTINCT make, model, year FROM vehicles;";
				ResultSet rs = conn.prepareStatement(getAllAuctionsQuery).executeQuery();

				while (rs.next()) {
					String make = rs.getString(1);
					String model = rs.getString(2);
					String year = rs.getString(3);
					out.println("<option value='" + make + "@" + model + "@" + year + "'>" + make + " " + model + " " + year + "</option>");
				}
			} catch (Exception e) {
				return;
			}
			%>
		</select> <br> <br> <input type="submit" value="Generate">
	</form>
	<br>
	<br>
	<%
	String bestitems = request.getParameter("bestitems");
	String bestbuyer = request.getParameter("bestbuyer");

	String user = request.getParameter("users");
	String itemtype = request.getParameter("itemtype");
	String item = request.getParameter("item");

	if (bestitems == null && bestbuyer == null && user == null && itemtype == null && item == null) {
		return;
	}

	if (bestbuyer != null) {
		String query = "SELECT id, username, sum(bid) spent "
		+ "FROM (SELECT id, username, auction_id, max(bid_amount) bid "
		+ "FROM users join bids on users.id = bids.bidder_id " + "GROUP BY id, auction_id) highest_bids "
		+ "GROUP BY id ORDER BY spent DESC LIMIT 10";
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<th>Buyer(User) ID</th>");
		out.println("<th>Username</th>");
		out.println("<th>Spent</th>");
		out.println("</tr>");
		try {
			Connection conn = ApplicationDB.getConnection();
			if (conn == null) {
		out.println("<h1>Login Failed: SQL Error.</h1>");
			} else {
		ResultSet rs = conn.prepareStatement(query).executeQuery();
		while (rs.next()) {
			out.println("<tr>");
			out.println("<td>" + rs.getString(1) + "</td>");
			out.println("<td>" + rs.getString(2) + "</td>");
			out.println("<td>" + rs.getString(3) + "</td>");
			out.println("</tr>");
		}
		conn.close();
		rs.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		out.println("</table>");
	} else if (bestitems != null) {
		String query = "SELECT VIN, vehicle_type, make, model, year, bid_count " + "FROM vehicles v JOIN "
		+ "(SELECT vehicle_id, count(bid_id) bid_count "
		+ "FROM auctions JOIN bids ON auctions.auction_id = bids.auction_id " + "GROUP BY auctions.auction_id "
		+ "ORDER BY bid_count desc) vbids on v.VIN = vbids.vehicle_id " + "ORDER BY vbids.bid_count DESC LIMIT 10;";
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<th>VIN</th>");
		out.println("<th>Item Type</th>");
		out.println("<th>Make</th>");
		out.println("<th>Model</th>");
		out.println("<th>Year</th>");
		out.println("<th>Bids</th>");
		out.println("</tr>");

		try {
			Connection conn = ApplicationDB.getConnection();
			if (conn == null) {
		out.println("<h1>Login Failed: SQL Error.</h1>");
			} else {
		ResultSet rs = conn.prepareStatement(query).executeQuery();
		while (rs.next()) {
			out.println("<tr>");
			out.println("<td>" + rs.getString(1) + "</td>");
			out.println("<td>" + rs.getString(2) + "</td>");
			out.println("<td>" + rs.getString(3) + "</td>");
			out.println("<td>" + rs.getString(4) + "</td>");
			out.println("<td>" + rs.getInt(5) + "</td>");
			out.println("<td>" + rs.getInt(6) + "</td>");
			out.println("</tr>");
		}
		conn.close();
		rs.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		out.println("</table>");
	} else {
		String reportTableQuery = "CREATE TEMPORARY TABLE report "
		+ "SELECT auctions.auction_id, seller_id, max(bid_amount) max_bid, vehicles.vehicle_type, vehicles.make, vehicles.model, vehicles.year "
		+ "FROM auctions, bids, vehicles "
		+ "WHERE auctions.auction_id = bids.auction_id and auctions.vehicle_id = vehicles.VIN "
		+ "GROUP BY auction_id, seller_id;";
		Connection conn = null;
		ResultSet rs = null;
		try {
			conn = ApplicationDB.getConnection();
			if (conn == null) {
				out.println("<h2>SQL Error.</h2>");
				return;
			}

			int rowsUpdated = conn.prepareStatement(reportTableQuery).executeUpdate();
			if (rowsUpdated > 0) {
				String earningsQuery = "SELECT sum(max_bid) earnings " + "FROM report " + "WHERE 1=1";
				
				if (!user.equals("ALL")) {
					String getUserIDQuery = "SELECT id FROM users where username='" + user + "'";
					rs = conn.prepareStatement(getUserIDQuery).executeQuery();
					String sellerID = null;
					if (rs.next()) {
						sellerID = rs.getString(1);
					} else {
						out.println("<h2>SQL Error.</h2>");
						return;
					}
					earningsQuery += " AND seller_id=" + sellerID;
				}
		
				if (!itemtype.equals("ALL"))
					earningsQuery += " AND vehicle_type='" + itemtype + "'";
		
				if (!item.equals("ALL")) {
					String[] details = item.split("@");
					String make = details[0];
					String model = details[1];
					String year = details[2];
			        
					earningsQuery += " AND make='" + make + "' ";
					earningsQuery += " AND model='" + model + "'";
					earningsQuery += " AND year='" + year + "'";
				}
		
				earningsQuery += ";";
				
				if(rs != null)
					rs.close();
				
				rs = conn.prepareStatement(earningsQuery).executeQuery();
				
				if (rs.next()) {
					String earning = rs.getString(1) == null ? "0" : rs.getString(1);
					out.println("<h2>$" + earning + "</h2>");
				} else {
					out.println("<h2>SQL Error.</h2>");
					return;
				}
			} else {
				out.println("<h2>SQL Error when creating Temporary Report Table.</h2>");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)
				rs.close();
			if(conn != null) {
				String dropReportTableQuery = "DROP TEMPORARY TABLE IF EXISTS report;";
				conn.prepareStatement(dropReportTableQuery).executeUpdate();
				conn.close();
			}
		}
	}
	%>
</body>
</html>
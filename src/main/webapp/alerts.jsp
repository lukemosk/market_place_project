<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="cs336.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
    <title>Alerts Page</title>
</head>
<style>
.alert {
	text-align: center;
	border: 2px solid #C41E3A;
	padding: 10px 10px;
	margin-right: 75%;
	background-color: #E97451;
	opacity: 0.9;
}
.active {
	text-align: center;
	border: 2px solid #50C878;
	padding: 10px 10px;
	margin-right: 75%;
	background-color: #7FFFD4;
}
</style>
<body>
	<a href="browseAuctions.jsp">Products Page</a>
	
	<%
	if(session.getAttribute("user") == null) {
		response.sendRedirect("login.jsp");
	}
	%>
	
    <br><br>
    <h3>Triggered Alerts (blank if none):</h3>
    <%
	try {
		String currentUser = (String) session.getAttribute("user");
		Connection conn = ApplicationDB.getConnection();
		String getUserIDQuery = "SELECT id FROM users where username='" + currentUser + "'";
		ResultSet rs = conn.prepareStatement(getUserIDQuery).executeQuery();
		String currentID = null;
		if (rs.next()) {
			currentID = rs.getString(1);
			rs.close();
		} else {
			out.println("<h2>SQL Error.</h2>");
			rs.close();
			return;
		}

		String query = "SELECT auction_id, details.make, details.model, details.year "
				+ "FROM auctions, vehicles, (SELECT make, model, year FROM alerts WHERE user_id=" + currentID + ") details "
				+ "WHERE auctions.vehicle_id = vehicles.VIN and vehicles.make = details.make and vehicles.model = details.model and vehicles.year = details.year;";
		rs = conn.prepareStatement(query).executeQuery();
		
		while(rs.next()) {
			String id = rs.getString(1);
			String make = rs.getString(2);
			String model = rs.getString(3);
			String year = rs.getString(4);
			%>
			<div class="alert">
				<h3><%= "AuctionID: " + id + " | " + make + " " + model + " " + year %></h3>
				<a href="individualAuctions.jsp?auctionId=<%= id %>">Goto Product</a>
			</div>
			<br>
			<%
		}
	} catch (Exception e) {
		out.println("<h2>SQL Error when trying to load alerts!</h2>");
		return;
	}
	%>
    <br><br>
    
    <h3>Create Alert:</h3>
    <form>
	    <label for="item">Item: </label> 
	    <select name="item">
	    	<option disabled selected> -- select an item -- </option>
			<%
			try {
				Connection conn = ApplicationDB.getConnection();
				String getAllAuctionsQuery = "SELECT DISTINCT make, model, year FROM vehicles;";
				ResultSet rs = conn.prepareStatement(getAllAuctionsQuery).executeQuery();
	
				while (rs.next()) {
					String make = rs.getString(1);
					String model = rs.getString(2);
					String year = rs.getString(3);
					String[] details = {make, model, year};
					out.println("<option value='" + make + "@" + model + "@" + year + "'>" + make + " " + model + " " + year + "</option>");
				}
			} catch (Exception e) {
				return;
			}
			%>
		</select> <input type="submit" value="Create Alert">
	</form>
	<%
	String create_alert = request.getParameter("item");
	String delete_alert = request.getParameter("delete_alert_id");
	
	if (create_alert != null) {
		String[] details = create_alert.split("@");
		String make = details[0];
		String model = details[1];
		String year = details[2];
		try {
			String currentUser = (String) session.getAttribute("user");
			Connection conn = ApplicationDB.getConnection();
			String getUserIDQuery = "SELECT id FROM users where username='" + currentUser + "'";
			ResultSet rs = conn.prepareStatement(getUserIDQuery).executeQuery();
			String currentID = null;
			if (rs.next()) {
				currentID = rs.getString(1);
				rs.close();
			} else {
				out.println("<h2>SQL Error.</h2>");
				rs.close();
				return;
			}

			String createAlertQuery = "INSERT INTO alerts (user_id, make, model, year) VALUES "
					+ "(" + currentID + ", '"
					+ make + "', '"
					+ model + "', " + year + ");";
			conn.prepareStatement(createAlertQuery).executeUpdate();
		} catch (Exception e) {
			out.println("<h2>SQL Error when trying to create alert!</h2>");
			return;
		}
		response.sendRedirect("alerts.jsp");
		return;
	}
	
	if(delete_alert != null) {
		try {
			Connection conn = ApplicationDB.getConnection();
			String deleteAlert = "DELETE FROM alerts WHERE alert_id=" + delete_alert + ";";
			conn.prepareStatement(deleteAlert).executeUpdate();
		} catch (Exception e) {
			out.println("<h2>SQL Error when trying to delete alert!</h2>");
			return;
		}
		response.sendRedirect("alerts.jsp");
		return;
	}
	%>
	<br><br>
	<h3>Active/Watched Items:</h3>
	<% 
	try {
		String currentUser = (String) session.getAttribute("user");
		Connection conn = ApplicationDB.getConnection();
		String getUserIDQuery = "SELECT id FROM users where username='" + currentUser + "'";
		ResultSet rs = conn.prepareStatement(getUserIDQuery).executeQuery();
		String currentID = null;
		if (rs.next()) {
			currentID = rs.getString(1);
			rs.close();
		} else {
			out.println("<h2>SQL Error.</h2>");
			rs.close();
			return;
		}

		String getAlertsQuery = "SELECT alert_id, make, model, year FROM alerts WHERE user_id=" + currentID + ";";
		rs = conn.prepareStatement(getAlertsQuery).executeQuery();
		
		while(rs.next()) {
			String id = rs.getString(1);
			String make = rs.getString(2);
			String model = rs.getString(3);
			String year = rs.getString(4);
			%>
			<div class="active">
				<h3><%= make + " " + model + " " + year %></h3>
				<form action="alerts.jsp" method="POST">
					<button type="submit" name="delete_alert_id" value="<%= id %>">Delete</button>
				</form>
			</div>
			<br>
			<%
		}
	} catch (Exception e) {
		out.println("<h2>SQL Error when trying to load alerts!</h2>");
		return;
	}
	%>
    <br><br><br><br>
    <a href="home.jsp">Home</a>
</body>
</html>
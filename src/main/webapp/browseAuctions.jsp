<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*, java.util.*, java.sql.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="cs336.ApplicationDB"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Browse Auctions</title>
</head>
<body>
    <h1>Browse Auctions</h1>
    
    <h2>Go to Auction Page</h2>
	<form method="get" action="individualAuction.jsp">
	    <label for="auctionId">Enter Auction ID:</label>
	    <input type="number" id="auctionId" name="auctionId" required><br>
	    <input type="submit" value="Go to Auction">
	</form>
    
    <!-- Search Form -->
    <h2>Search Auctions</h2>
    <form method="get" action="browseAuctions.jsp">
        <label for="vehicleType">Vehicle Type:</label>
        <select id="vehicleType" name="vehicleType">
            <option value="">--Any--</option>
            <option value="car">Car</option>
            <option value="motorbike">Motorbike</option>
            <option value="boat">Boat</option>
        </select><br>

        <label for="currentPriceRange">Current Price Range:</label>
        <select id="currentPriceRange" name="currentPriceRange">
            <option value="">--Any--</option>
            <option value="0-25000">0 - 25,000</option>
            <option value="25001-75000">25,001 - 75,000</option>
            <option value="75,001+">75,001+</option>
        </select><br>

        <label for="color">Color:</label>
        <input type="text" id="color" name="color"><br>

        <label for="make">Make:</label>
        <input type="text" id="make" name="make"><br>

        <label for="model">Model:</label>
        <input type="text" id="model" name="model"><br>

        <label for="mileageRange">Mileage Range:</label>
        <select id="mileageRange" name="mileageRange">
            <option value="">--Any--</option>
            <option value="0-50000">0 - 50,000</option>
            <option value="50,001-100,000">50,001 - 100,000</option>
            <option value="100,001+">100,001+</option>
        </select><br>

        <label for="year">Year:</label>
        <input type="number" id="year" name="year" min="0"><br>

        <input type="submit" value="Search">
    </form>

    <% 
    
        String vehicleType = request.getParameter("vehicleType");
        String currentPriceRange = request.getParameter("currentPriceRange");
        String color = request.getParameter("color");
        String make = request.getParameter("make");
        String model = request.getParameter("model");
        String mileageRange = request.getParameter("mileageRange");
        String year = request.getParameter("year");

        try {
            Connection con = ApplicationDB.getConnection();

            String query = "SELECT a.auction_id, v.VIN, v.make, v.model, v.year, v.color, v.mileage, a.start_date, a.end_date, a.starting_price, a.current_price, a.status " +
                           "FROM auctions a " +
                           "JOIN vehicles v ON a.vehicle_id = v.VIN " +
                           "WHERE 1 = 1";  // this is just a placeholder

            if (vehicleType != null && !vehicleType.isEmpty()) {
                query += " AND v.vehicle_type = '" + vehicleType + "'";
            }
            if (currentPriceRange != null && !currentPriceRange.isEmpty()) {
                if (currentPriceRange.equals("0-25000")) {
                    query += " AND a.current_price BETWEEN 0 AND 25000";
                } else if (currentPriceRange.equals("25001-75000")) {
                    query += " AND a.current_price BETWEEN 25001 AND 75000";
                } else if (currentPriceRange.equals("75001+")) {
                    query += " AND a.current_price > 75000";
                }
            }
            if (color != null && !color.isEmpty()) {
                query += " AND v.color = '" + color + "'";
            }
            if (make != null && !make.isEmpty()) {
                query += " AND v.make = '" + make + "'";
            }
            if (model != null && !model.isEmpty()) {
                query += " AND v.model = '" + model + "'";
            }
            if (mileageRange != null && !mileageRange.isEmpty()) {
                if (mileageRange.equals("0-50000")) {
                    query += " AND v.mileage BETWEEN 0 AND 50000";
                } else if (mileageRange.equals("50,001-100,000")) {
                    query += " AND v.mileage BETWEEN 50001 AND 100000";
                } else if (mileageRange.equals("100,001+")) {
                    query += " AND v.mileage > 100000";
                }
            }
            if (year != null && !year.isEmpty()) {
                query += " AND v.year = " + Integer.parseInt(year);
            }

            Statement stmt = con.createStatement();
            ResultSet result = stmt.executeQuery(query);

            out.println("<table border='1'>");
            out.println("<tr>");
            out.println("<th>Auction ID</th>");
            out.println("<th>VIN</th>");
            out.println("<th>Make</th>");
            out.println("<th>Model</th>");
            out.println("<th>Year</th>");
            out.println("<th>Color</th>");
            out.println("<th>Mileage</th>");
            out.println("<th>Start Date</th>");
            out.println("<th>End Date</th>");
            out.println("<th>Starting Price</th>");
            out.println("<th>Current Price</th>");
            out.println("<th>Status</th>");
            out.println("</tr>");

            while (result.next()) {
                out.println("<tr>");
                out.println("<td>" + result.getInt("auction_id") + "</td>");
                out.println("<td>" + result.getString("VIN") + "</td>");
                out.println("<td>" + result.getString("make") + "</td>");
                out.println("<td>" + result.getString("model") + "</td>");
                out.println("<td>" + result.getInt("year") + "</td>");
                out.println("<td>" + result.getString("color") + "</td>");
                out.println("<td>" + result.getInt("mileage") + "</td>");
                out.println("<td>" + result.getString("start_date") + "</td>");
                out.println("<td>" + result.getString("end_date") + "</td>");
                out.println("<td>" + result.getDouble("starting_price") + "</td>");
                out.println("<td>" + result.getDouble("current_price") + "</td>");
                out.println("<td>" + result.getString("status") + "</td>");
                out.println("</tr>");
            }

            out.println("</table>");

            ApplicationDB.closeConnection(con);
        } catch (Exception e) {
            out.print("An error occurred: " + e.getMessage());
        }
    %>
    
    
</body>
</html>

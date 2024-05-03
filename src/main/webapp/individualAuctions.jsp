<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*, java.util.*, java.sql.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Individual Auction</title>
</head>
<body>
    <h1>Individual Auction Details</h1>

    <% 
        String auctionIdParam = request.getParameter("auctionId");
        if (auctionIdParam != null && !auctionIdParam.isEmpty()) {
            int auctionId = Integer.parseInt(auctionIdParam);

            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                String query = "SELECT a.auction_id, v.VIN, v.make, v.model, v.year, v.color, v.mileage, a.start_date, a.end_date, a.starting_price, a.current_price, a.status " +
                               "FROM auctions a " +
                               "JOIN vehicles v ON a.vehicle_id = v.VIN " +
                               "WHERE a.auction_id = ?";

                PreparedStatement pstmt = con.prepareStatement(query);
                pstmt.setInt(1, auctionId);
                ResultSet result = pstmt.executeQuery();

                if (result.next()) {
                    out.println("<table border='1'>");
                    out.println("<tr><th>Auction ID</th><td>" + result.getInt("auction_id") + "</td></tr>");
                    out.println("<tr><th>VIN</th><td>" + result.getString("VIN") + "</td></tr>");
                    out.println("<tr><th>Make</th><td>" + result.getString("make") + "</td></tr>");
                    out.println("<tr><th>Model</th><td>" + result.getString("model") + "</td></tr>");
                    out.println("<tr><th>Year</th><td>" + result.getInt("year") + "</td></tr>");

                    out.println("<tr><th>Color</th><td>" + result.getString("color") + "</td></tr>");
                    out.println("<tr><th>Mileage</th><td>" + result.getInt("mileage") + "</td></tr>");
                    out.println("<tr><th>Start Date</th><td>" + result.getString("start_date") + "</td></tr>");
                    out.println("<tr><th>End Date</th><td>" + result.getString("end_date") + "</td></tr>");
                    out.println("<tr><th>Starting Price</th><td>" + result.getDouble("starting_price") + "</td></tr>");
                    out.println("<tr><th>Current Price</th><td>" + result.getDouble("current_price") + "</td></tr>");
                    out.println("<tr><th>Status</th><td>" + result.getString("status") + "</td></tr>");
                    out.println("</table>");
                } else {
                    out.println("No auction found with ID: " + auctionId);
                }

                result.close();
                pstmt.close();
                db.closeConnection(con);
            } catch (Exception e) {
                out.print("An error occurred: " + e.getMessage());
            }
        } else {
            out.println("Invalid auction ID provided.");
        }
    %>
</body>
</html>

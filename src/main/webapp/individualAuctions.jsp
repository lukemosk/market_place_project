<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*, java.util.*, java.sql.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="cs336.ApplicationDB"%>

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
                Connection con = ApplicationDB.getConnection();

                String auctionQuery = "SELECT a.auction_id, v.VIN, v.make, v.model, v.year, v.color, v.mileage, a.start_date, a.end_date, a.starting_price, a.current_price, a.status " +
                                      "FROM auctions a " +
                                      "JOIN vehicles v ON a.vehicle_id = v.VIN " +
                                      "WHERE a.auction_id = ?";
                PreparedStatement auctionStmt = con.prepareStatement(auctionQuery);
                auctionStmt.setInt(1, auctionId);
                ResultSet auctionResult = auctionStmt.executeQuery();

                if (auctionResult.next()) {
                    out.println("<table border='1'>");
                    out.println("<tr><th>Auction ID</th><td>" + auctionResult.getInt("auction_id") + "</td></tr>");
                    out.println("<tr><th>VIN</th><td>" + auctionResult.getString("VIN") + "</td></tr>");
                    out.println("<tr><th>Make</th><td>" + auctionResult.getString("make") + "</td></tr>");
                    out.println("<tr><th>Model</th><td>" + auctionResult.getString("model") + "</td></tr>");
                    out.println("<tr><th>Year</th><td>" + auctionResult.getInt("year") + "</td></tr>");
                    out.println("<tr><th>Color</th><td>" + auctionResult.getString("color") + "</td></tr>");
                    out.println("<tr><th>Mileage</th><td>" + auctionResult.getInt("mileage") + "</td></tr>");
                    out.println("<tr><th>Start Date</th><td>" + auctionResult.getString("start_date") + "</td></tr>");
                    out.println("<tr><th>End Date</th><td>" + auctionResult.getString("end_date") + "</td></tr>");
                    out.println("<tr><th>Starting Price</th><td>" + auctionResult.getDouble("starting_price") + "</td></tr>");
                    out.println("<tr><th>Current Price</th><td>" + auctionResult.getDouble("current_price") + "</td></tr>");
                    out.println("<tr><th>Status</th><td>" + auctionResult.getString("status") + "</td></tr>");
                    out.println("</table>");
                    
                    String currentVehicleMake = auctionResult.getString("make");

                    out.println("<h2>Bid History</h2>");
                    String bidHistoryQuery = "SELECT b.bid_id, u.username AS bidder_name, b.bid_amount, b.bid_time " +
                                             "FROM bids b JOIN users u ON b.bidder_id = u.id " +
                                             "WHERE b.auction_id = ? ORDER BY b.bid_time DESC;";
                    PreparedStatement bidHistoryStmt = con.prepareStatement(bidHistoryQuery);
                    bidHistoryStmt.setInt(1, auctionId);
                    ResultSet bidHistory = bidHistoryStmt.executeQuery();

                    if (bidHistory.next()) {
                        out.println("<table border='1'>");
                        out.println("<tr><th>Bid ID</th><th>Bidder</th><th>Bid Amount</th><th>Bid Time</th></tr>");
                        do {
                            out.println("<tr>");
                            out.println("<td>" + bidHistory.getInt("bid_id") + "</td>");
                            out.println("<td>" + bidHistory.getString("bidder_name") + "</td>");
                            out.println("<td>" + bidHistory.getDouble("bid_amount") + "</td>");
                            out.println("<td>" + bidHistory.getTimestamp("bid_time") + "</td>");
                            out.println("</tr>");
                        } while (bidHistory.next());
                        out.println("</table>");
                    } else {
                        out.println("No bids found for this auction.");
                    }

                    bidHistory.close();
                    bidHistoryStmt.close();

                    out.println("<h2>Similar Items</h2>");
                    String similarItemsQuery = "SELECT a.auction_id, v.VIN, v.make, v.model, v.year, v.color, a.start_date, a.end_date, a.starting_price, a.current_price " +
                                               "FROM auctions a JOIN vehicles v ON a.vehicle_id = v.VIN " +
                                               "WHERE v.make = ? AND a.auction_id != ? AND a.status = 'ongoing' " +
                                               "LIMIT 5;";
                    PreparedStatement similarItemsStmt = con.prepareStatement(similarItemsQuery);
                    similarItemsStmt.setString(1, currentVehicleMake);
                    similarItemsStmt.setInt(2, auctionId);
                    ResultSet similarItems = similarItemsStmt.executeQuery();

                    if (similarItems.next()) {
                        out.println("<table border='1'>");
                        out.println("<tr><th>VIN</th><th>Make</th><th>Model</ch><th>Year</th><th>Color</th><th>Start Date</th><th>End Date</th><th>Starting Price</th><th>Current Price</th></tr>");
                        do {
                            out.println("<tr>");
                            out.println("<td>" + similarItems.getString("VIN") + "</td>");
                            out.println("<td>" + similarItems.getString("make") + "</td>");
                            out.println("<td>" + similarItems.getString("model") + "</td>");
                            out.println("<td>" + similarItems.getInt("year") + "</td>");
                            out.println("<td>" + similarItems.getString("color") + "</td>");
                            out.println("<td>" + similarItems.getTimestamp("start_date") + "</td>");
                            out.println("<td>" + similarItems.getTimestamp("end_date") + "</td>");
                            out.println("<td>" + similarItems.getDouble("starting_price") + "</td>");
                            out.println("<td>" + similarItems.getDouble("current_price") + "</td>");
                            out.println("</tr>");
                        } while (similarItems.next());
                        out.println("</table>");
                    } else {
                        out.println("No similar items found.");
                    }

                    similarItems.close();
                    similarItemsStmt.close();

                } else {
                    out.println("No auction found with ID: " + auctionId);
                }

                ApplicationDB.closeConnection(con);
                
            } catch (Exception e) {
                out.print("An error occurred: " + e.getMessage());
            }
        } else {
            out.println("Invalid auction ID provided.");
        }
    %>
</body>
</html>

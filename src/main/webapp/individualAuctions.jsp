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

    <% if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
    } %>

    <%
        String auctionIdParam = request.getParameter("auctionId");
        if (auctionIdParam != null && !auctionIdParam.isEmpty()) {
            int auctionId = Integer.parseInt(auctionIdParam);

            try {
                Connection con = ApplicationDB.getConnection();

                String auctionQuery = "SELECT a.auction_id, v.VIN, v.make, v.model, v.year, v.color, v.mileage, a.start_date, a.end_date, a.starting_price, a.current_price, a.reserve_price, a.status " +
                                      "FROM auctions a " +
                                      "JOIN vehicles v ON a.vehicle_id = v.VIN " +
                                      "WHERE a.auction_id = ?";
                PreparedStatement auctionStmt = con.prepareStatement(auctionQuery);
                auctionStmt.setInt(1, auctionId);
                ResultSet auctionResult = auctionStmt.executeQuery();

                if (auctionResult.next()) {
                    double currentPrice = auctionResult.getDouble("current_price");
                    double reservePrice = auctionResult.getDouble("reserve_price");
                    String auctionStatus = auctionResult.getString("status");
                    
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
                    out.println("<tr><th>Current Price</th><td>" + currentPrice + "</td></tr>");
                    out.println("<tr><th>Status</th><td>" + auctionStatus + "</td></tr>");
                    out.println("</table>");

                    if (auctionStatus.equals("ongoing")) {
                        out.println("<h2>Place a Bid</h2>");
                        out.println("<form action='' method='post'>");
                        out.println("<input type='hidden' name='auctionId' value='" + auctionId + "'>");
                        out.println("<label for='bidAmount'>Bid Amount:</label>");
                        out.println("<input type='number' step='0.01' name='bidAmount' id='bidAmount' required><br>");
                        out.println("<label for='autoUpperLimit'>Automatic Bidding Upper Limit:</label>");
                        out.println("<input type='number' step='0.01' name='autoUpperLimit' id='autoUpperLimit'><br>");
                        out.println("<label for='bidIncrement'>Bid Increment:</label>");
                        out.println("<input type='number' step='0.01' name='bidIncrement' id='bidIncrement'><br>");
                        out.println("<input type='submit' value='Place Bid'>");
                        out.println("</form>");
                        
                        String bidAmountParam = request.getParameter("bidAmount");
                        String autoUpperLimitParam = request.getParameter("autoUpperLimit");
                        String bidIncrementParam = request.getParameter("bidIncrement");
                        
                        if (bidAmountParam != null && !bidAmountParam.isEmpty()) {
                            double bidAmount = Double.parseDouble(bidAmountParam);
                            
                            if (bidAmount > currentPrice && bidAmount >= reservePrice) {
                                String insertBidQuery = "INSERT INTO bids (auction_id, bidder_id, bid_amount, bid_time) VALUES (?, ?, ?, NOW())";
                                PreparedStatement insertBidStmt = con.prepareStatement(insertBidQuery);
                                insertBidStmt.setInt(1, auctionId);

                                int bidderId = 0;
                                String currentUser = (String) session.getAttribute("user");
                                if (currentUser != null) {
                                    out.println("<h2>Username: " + currentUser + "</h2>");

                                    String getUserIDQuery = "SELECT id FROM users WHERE username = ?";
                                    PreparedStatement getUserIDStmt = con.prepareStatement(getUserIDQuery);
                                    getUserIDStmt.setString(1, currentUser);
                                    ResultSet rs = getUserIDStmt.executeQuery();
                                    if (rs.next()) {
                                        bidderId = rs.getInt("id");
                                    }
                                    rs.close();
                                    getUserIDStmt.close();
                                    
                                    if (bidderId == 0) {
                                        out.println("<h2>User not found. Please log in with a valid user account.</h2>");
                                        return;
                                    }
                                } else {
                                    out.println("<h2>User not logged in. Please log in to place a bid.</h2>");
                                    return;
                                }

                                insertBidStmt.setInt(2, bidderId);
                                insertBidStmt.setDouble(3, bidAmount);
                                insertBidStmt.executeUpdate();
                                
                                String updateAuctionQuery = "UPDATE auctions SET current_price = ? WHERE auction_id = ?";
                                PreparedStatement updateAuctionStmt = con.prepareStatement(updateAuctionQuery);
                                updateAuctionStmt.setDouble(1, bidAmount);
                                updateAuctionStmt.setInt(2, auctionId);
                                updateAuctionStmt.executeUpdate();
                                
                                out.println("<p>Your bid has been accepted!</p>");
                                
                                String alertOtherBuyersQuery = "INSERT INTO alerts_generic (user_id, message) " +
                                                               "SELECT b.bidder_id, CONCAT('A higher bid of $', ?, ' has been placed on the ', v.make, ' ', v.model, ' auction.') " +
                                                               "FROM bids b " +
                                                               "JOIN auctions a ON b.auction_id = a.auction_id " +
                                                               "JOIN vehicles v ON a.vehicle_id = v.VIN " +
                                                               "WHERE b.auction_id = ? AND b.bidder_id != ?";
                                PreparedStatement alertOtherBuyersStmt = con.prepareStatement(alertOtherBuyersQuery);
                                alertOtherBuyersStmt.setDouble(1, bidAmount);
                                alertOtherBuyersStmt.setInt(2, auctionId);
                                alertOtherBuyersStmt.setInt(3, bidderId);
                                alertOtherBuyersStmt.executeUpdate();
                                
                                String alertAutoBiddersQuery = "INSERT INTO alerts_generic (user_id, message) " +
                                                               "SELECT b.bidder_id, CONCAT('Your automatic bid upper limit of $', b.bid_upper, ' has been exceeded for the ', v.make, ' ', v.model, ' auction.') " +
                                                               "FROM bids b " +
                                                               "JOIN auctions a ON b.auction_id = a.auction_id " +
                                                               "JOIN vehicles v ON a.vehicle_id = v.VIN " +
                                                               "WHERE b.auction_id = ? AND b.bid_upper < ?";
                                PreparedStatement alertAutoBiddersStmt = con.prepareStatement(alertAutoBiddersQuery);
                                alertAutoBiddersStmt.setInt(1, auctionId);
                                alertAutoBiddersStmt.setDouble(2, bidAmount);
                                alertAutoBiddersStmt.executeUpdate();

                                if (autoUpperLimitParam != null && !autoUpperLimitParam.isEmpty() && bidIncrementParam != null && !bidIncrementParam.isEmpty()) {
                                    double autoUpperLimit = Double.parseDouble(autoUpperLimitParam);
                                    double bidIncrement = Double.parseDouble(bidIncrementParam);
                                    
                                    String updateAutoBidQuery = "UPDATE bids SET bid_upper = ?, bid_increment = ? WHERE auction_id = ? AND bidder_id = ?";
                                    PreparedStatement updateAutoBidStmt = con.prepareStatement(updateAutoBidQuery);
                                    updateAutoBidStmt.setDouble(1, autoUpperLimit);
                                    updateAutoBidStmt.setDouble(2, bidIncrement);
                                    updateAutoBidStmt.setInt(3, auctionId);
                                    updateAutoBidStmt.setInt(4, bidderId);
                                    updateAutoBidStmt.setInt(5, auctionId);
                                    updateAutoBidStmt.setInt(6, bidderId);
                                }
                            } else {
                                out.println("<p>Please enter a bid higher than the current price and the reserve price.</p>");
                            }
                        }
                    }

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
                        out.println("<tr><th>VIN</th><th>Make</th><th>Model</th><th>Year</th><th>Color</th><th>Start Date</th><th>End Date</th><th>Starting Price</th><th>Current Price</th></tr>");
                        do {
                            out.println("<tr>");
                            out.println("<td><a href='auction.jsp?auctionId=" + similarItems.getInt("auction_id") + "'>" + similarItems.getString("VIN") + "</a></td>");
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="cs336.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
    <title>Bid History</title>
</head>
<body>
    <h1>Bid History</h1>
    
    <% if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
    } %>
    
    <h2>Your Bid History:</h2>
    <%
    try {
        String currentUser = (String) session.getAttribute("user");
        Connection conn = ApplicationDB.getConnection();
        String getUserIDQuery = "SELECT id FROM users WHERE username='" + currentUser + "'";
        ResultSet rs = conn.prepareStatement(getUserIDQuery).executeQuery();
        String currentID = null;
        if (rs.next()) {
            currentID = rs.getString(1);
            rs.close();
        } else {
            out.println("<h3>SQL Error.</h3>");
            rs.close();
            return;
        }

        String bidHistoryQuery = "SELECT a.auction_id, v.make, v.model, v.year, b.bid_amount, b.bid_time " +
                                 "FROM bids b " +
                                 "JOIN auctions a ON b.auction_id = a.auction_id " +
                                 "JOIN vehicles v ON a.vehicle_id = v.VIN " +
                                 "WHERE b.bidder_id = " + currentID + " " +
                                 "ORDER BY b.bid_time DESC";
        rs = conn.prepareStatement(bidHistoryQuery).executeQuery();
        
        if (!rs.isBeforeFirst()) {
            out.println("<p>No records found.</p>");
        } else {
            out.println("<table>");
            out.println("<tr><th>Auction ID</th><th>Vehicle</th><th>Bid Amount</th><th>Bid Time</th></tr>");
            while (rs.next()) {
                String auctionId = rs.getString(1);
                String vehicle = rs.getString(2) + " " + rs.getString(3) + " " + rs.getString(4);
                String bidAmount = rs.getString(5);
                String bidTime = rs.getString(6);
                out.println("<tr>");
                out.println("<td>" + auctionId + "</td>");
                out.println("<td>" + vehicle + "</td>");
                out.println("<td>" + bidAmount + "</td>");
                out.println("<td>" + bidTime + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        }
    } catch (Exception e) {
        out.println("<h3>SQL Error when trying to load bid history!</h3>");
        return;
    }
    %>
    
    <h2>Your Selling History:</h2>
    <%
    try {
        String currentUser = (String) session.getAttribute("user");
        Connection conn = ApplicationDB.getConnection();
        String getUserIDQuery = "SELECT id FROM users WHERE username='" + currentUser + "'";
        ResultSet rs = conn.prepareStatement(getUserIDQuery).executeQuery();
        String currentID = null;
        if (rs.next()) {
            currentID = rs.getString(1);
            rs.close();
        } else {
            out.println("<h3>SQL Error.</h3>");
            rs.close();
            return;
        }

        String sellingHistoryQuery = "SELECT a.auction_id, v.make, v.model, v.year, a.current_price, a.end_date " +
                                     "FROM auctions a " +
                                     "JOIN vehicles v ON a.vehicle_id = v.VIN " +
                                     "WHERE a.seller_id = " + currentID + " " +
                                     "ORDER BY a.end_date DESC";
        rs = conn.prepareStatement(sellingHistoryQuery).executeQuery();
        
        if (!rs.isBeforeFirst()) {
            out.println("<p>No records found.</p>");
        } else {
            out.println("<table>");
            out.println("<tr><th>Auction ID</th><th>Vehicle</th><th>Current Price</th><th>End Date</th></tr>");
            while (rs.next()) {
                String auctionId = rs.getString(1);
                String vehicle = rs.getString(2) + " " + rs.getString(3) + " " + rs.getString(4);
                String currentPrice = rs.getString(5);
                String endDate = rs.getString(6);
                out.println("<tr>");
                out.println("<td>" + auctionId + "</td>");
                out.println("<td>" + vehicle + "</td>");
                out.println("<td>" + currentPrice + "</td>");
                out.println("<td>" + endDate + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        }
    } catch (Exception e) {
        out.println("<h3>SQL Error when trying to load selling history!</h3>");
        return;
    }
    %>
    
    <h2>Search User History:</h2>
    <form action="bidHistory.jsp" method="post">
        <input type="text" name="searchUsername" placeholder="Enter username">
        <input type="submit" value="Search">
    </form>
    <%
    String searchUsername = request.getParameter("searchUsername");
    if (searchUsername != null && !searchUsername.isEmpty()) {
        try {
            Connection conn = ApplicationDB.getConnection();
            String getUserIDQuery = "SELECT id FROM users WHERE username='" + searchUsername + "'";
            ResultSet rs = conn.prepareStatement(getUserIDQuery).executeQuery();
            String searchUserID = null;
            if (rs.next()) {
                searchUserID = rs.getString(1);
                rs.close();
            } else {
                out.println("<h3>User not found.</h3>");
                rs.close();
                return;
            }

            String bidHistoryQuery = "SELECT a.auction_id, v.make, v.model, v.year, b.bid_amount, b.bid_time " +
                                     "FROM bids b " +
                                     "JOIN auctions a ON b.auction_id = a.auction_id " +
                                     "JOIN vehicles v ON a.vehicle_id = v.VIN " +
                                     "WHERE b.bidder_id = " + searchUserID + " " +
                                     "ORDER BY b.bid_time DESC";
            rs = conn.prepareStatement(bidHistoryQuery).executeQuery();
            
            out.println("<h3>Bid History for " + searchUsername + ":</h3>");
            if (!rs.isBeforeFirst()) {
                out.println("<p>No records found.</p>");
            } else {
                out.println("<table>");
                out.println("<tr><th>Auction ID</th><th>Vehicle</th><th>Bid Amount</th><th>Bid Time</th></tr>");
                while (rs.next()) {
                    String auctionId = rs.getString(1);
                    String vehicle = rs.getString(2) + " " + rs.getString(3) + " " + rs.getString(4);
                    String bidAmount = rs.getString(5);
                    String bidTime = rs.getString(6);
                    out.println("<tr>");
                    out.println("<td>" + auctionId + "</td>");
                    out.println("<td>" + vehicle + "</td>");
                    out.println("<td>" + bidAmount + "</td>");
                    out.println("<td>" + bidTime + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }

            String sellingHistoryQuery = "SELECT a.auction_id, v.make, v.model, v.year, a.current_price, a.end_date " +
                                         "FROM auctions a " +
                                         "JOIN vehicles v ON a.vehicle_id = v.VIN " +
                                         "WHERE a.seller_id = " + searchUserID + " " +
                                         "ORDER BY a.end_date DESC";
            rs = conn.prepareStatement(sellingHistoryQuery).executeQuery();
            
            out.println("<h3>Selling History for " + searchUsername + ":</h3>");
            if (!rs.isBeforeFirst()) {
                out.println("<p>No records found.</p>");
            } else {
                out.println("<table>");
                out.println("<tr><th>Auction ID</th><th>Vehicle</th><th>Current Price</th><th>End Date</th></tr>");
                while (rs.next()) {
                    String auctionId = rs.getString(1);
                    String vehicle = rs.getString(2) + " " + rs.getString(3) + " " + rs.getString(4);
                    String currentPrice = rs.getString(5);
                    String endDate = rs.getString(6);
                    out.println("<tr>");
                    out.println("<td>" + auctionId + "</td>");
                    out.println("<td>" + vehicle + "</td>");
                    out.println("<td>" + currentPrice + "</td>");
                    out.println("<td>" + endDate + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
        } catch (Exception e) {
            out.println("<h3>SQL Error when trying to load user history!</h3>");
            return;
        }
    }
    %>
    
    <br><br>
    <a href="home.jsp">Home</a>
</body>
</html>
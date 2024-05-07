<%@ page import="java.sql.*, java.util.ArrayList, java.util.List" %>
<%@ page import="cs336.ApplicationDB" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Auction History</title>
    <style>
        table, th, td {
            border: 1px solid black;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #FFFFFF;
        }
        tr:nth-child(even) {
            background-color: #D3D3D3;
        }
    </style>
</head>
<body>
    <h1>View User Auction History</h1>
    <form method="GET">
        <label for="userId">Enter User ID:</label>
        <input type="text" id="userId" name="userId" required>
        <input type="submit" value="Submit">
    </form>

    <%
        String userId = request.getParameter("userId");
        if (userId != null && !userId.trim().isEmpty()) {
            int userIntId = Integer.parseInt(userId);
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = ApplicationDB.getConnection();

                // Fetch all auctions where this user is a seller
                String sqlSeller = "SELECT a.auction_id, a.start_date, a.end_date, a.current_price, a.status, "
                                 + "v.vehicle_type, v.make, v.model, v.year "
                                 + "FROM auctions a "
                                 + "JOIN vehicles v ON a.vehicle_id = v.VIN "
                                 + "WHERE a.seller_id = ?";
                pstmt = conn.prepareStatement(sqlSeller);
                pstmt.setInt(1, userIntId);
                rs = pstmt.executeQuery();
                List<String> sellerAuctions = new ArrayList<>();
                while (rs.next()) {
                    sellerAuctions.add("Auction ID: " + rs.getInt("auction_id")
                                     + ", Start Date: " + rs.getTimestamp("start_date")
                                     + ", End Date: " + rs.getTimestamp("end_date")
                                     + ", Current Price: $" + rs.getDouble("current_price")
                                     + ", Status: " + rs.getString("status")
                                     + ", Vehicle Type: " + rs.getString("vehicle_type")
                                     + ", Make: " + rs.getString("make")
                                     + ", Model: " + rs.getString("model")
                                     + ", Year: " + rs.getInt("year"));
                }
                if(!sellerAuctions.isEmpty()) {
                out.println("<h2>Auctions Listed as Seller:</h2>");
                out.println("<table><tr><th>Auction ID</th><th>Start Date</th><th>End Date</th><th>Current Price</th><th>Status</th><th>Vehicle Type</th><th>Make</th><th>Model</th><th>Year</th></tr>");
                for (String auction : sellerAuctions) {
                    out.println("<tr><td>" + auction.replace(", ", "</td><td>") + "</td></tr>");
                }
                out.println("</table>");
                } else {
                	out.println("<p>User has not posted any items.</p>");
                }

                rs.close();
                pstmt.close();

                // Fetch all auctions where this user has placed bids
                String sqlBuyer = "SELECT a.auction_id, a.start_date, a.end_date, a.current_price, a.status, "
                                + "v.vehicle_type, v.make, v.model, v.year "
                                + "FROM auctions a "
                                + "JOIN bids b ON a.auction_id = b.auction_id "
                                + "JOIN vehicles v ON a.vehicle_id = v.VIN "
                                + "WHERE b.bidder_id = ?";
                pstmt = conn.prepareStatement(sqlBuyer);
                pstmt.setInt(1, userIntId);
                rs = pstmt.executeQuery();
                List<String> buyerAuctions = new ArrayList<>();
                while (rs.next()) {
                    buyerAuctions.add("Auction ID: " + rs.getInt("auction_id")
                                    + ", Start Date: " + rs.getTimestamp("start_date")
                                    + ", End Date: " + rs.getTimestamp("end_date")
                                    + ", Current Price: $" + rs.getDouble("current_price")
                                    + ", Status: " + rs.getString("status")
                                    + ", Vehicle Type: " + rs.getString("vehicle_type")
                                    + ", Make: " + rs.getString("make")
                                    + ", Model: " + rs.getString("model")
                                    + ", Year: " + rs.getInt("year"));
                }
                if (!buyerAuctions.isEmpty()) {
                    out.println("<h2>Auctions Participated in as Buyer:</h2>");
                    out.println("<table><tr><th>Auction ID</th><th>Start Date</th><th>End Date</th><th>Current Price</th><th>Status</th><th>Vehicle Type</th><th>Make</th><th>Model</th><th>Year</th></tr>");
                    for (String auction : buyerAuctions) {
                        out.println("<tr><td>" + auction.replace(", ", "</td><td>") + "</td></tr>");
                    }
                    out.println("</table>");
                } else {
                    out.println("<p>User has not placed any bids.</p>");
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ex) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) {}
                if (conn != null) try { conn.close(); } catch (SQLException ex) {}
            }
        }
    %>
</body>
</html>


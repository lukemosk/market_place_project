<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*, java.sql.*, java.math.BigDecimal, cs336.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
    <title>List a motorbike for Sale</title>
</head>
<body>
    <h1>List a motorbike for Sale</h1>
    <form method="POST">
        <label for="username">Username:</label><br>
        <input type="text" id="username" name="username" required><br><br>

        <label for="endDate">Auction End Date and Time:</label><br>
        <input type="datetime-local" id="endDate" name="endDate" required><br><br>

        <label for="startingPrice">Starting Price:</label><br>
        <input type="number" id="startingPrice" name="startingPrice" step="0.01" required><br><br>

        <label for="reservePrice">Reserve Price:</label><br>
        <input type="number" id="reservePrice" name="reservePrice" step="0.01"><br><br>

        <label for="VIN">VIN:</label><br>
        <input type="text" id="VIN" name="VIN" required><br><br>

        <label for="Make">Make:</label><br>
        <input type="text" id="Make" name="Make" required><br><br>

        <label for="Model">Model:</label><br>
        <input type="text" id="Model" name="Model" required><br><br>

        <label for="Year">Year:</label><br>
        <input type="number" id="Year" name="Year" required><br><br>

        <label for="Mileage">Mileage:</label><br>
        <input type="number" id="Mileage" name="Mileage" required><br><br>

        <label for="Color">Color:</label><br>
        <input type="text" id="Color" name="Color"><br><br>

        <input type="submit" value="List motorbike">
    </form>
<%
    String username = request.getParameter("username");
    if (username != null && !username.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = ApplicationDB.getConnection();
            String userQuery = "SELECT id FROM users WHERE username = ?";
            pstmt = conn.prepareStatement(userQuery);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("id");

                String endDate = request.getParameter("endDate");
                String startingPrice = request.getParameter("startingPrice");
                String reservePrice = request.getParameter("reservePrice");
                String VIN = request.getParameter("VIN");
                String make = request.getParameter("Make");
                String model = request.getParameter("Model");
                String year = request.getParameter("Year");
                String mileage = request.getParameter("Mileage");
                String color = request.getParameter("Color");
                color = (color != null && !color.isEmpty()) ? color : "unknown";  // Set default color if not specified

                // Insert into vehicles table
                String sqlInsertVehicle = "INSERT INTO vehicles (VIN, vehicle_type, owner_id, make, model, year, mileage, color) VALUES (?, 'motorbike', ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sqlInsertVehicle);
                pstmt.setString(1, VIN);
                pstmt.setInt(2, userId);
                pstmt.setString(3, make);
                pstmt.setString(4, model);
                pstmt.setInt(5, Integer.parseInt(year));
                pstmt.setInt(6, Integer.parseInt(mileage));
                pstmt.setString(7, color);
                pstmt.executeUpdate();

                // Insert into auctions table
                String sqlInsertAuction = "INSERT INTO auctions (vehicle_id, seller_id, start_date, end_date, starting_price, current_price, reserve_price) VALUES (?, ?, NOW(), ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sqlInsertAuction);
                pstmt.setString(1, VIN);
                pstmt.setInt(2, userId);
                pstmt.setString(3, endDate);
                pstmt.setBigDecimal(4, new BigDecimal(startingPrice));
                pstmt.setBigDecimal(5, new BigDecimal(startingPrice));
                if (reservePrice != null && !reservePrice.isEmpty()) {
                    pstmt.setBigDecimal(6, new BigDecimal(reservePrice));
                } else {
                    pstmt.setNull(6, java.sql.Types.DECIMAL);
                }
                pstmt.executeUpdate();

                out.println("<p>motorbike listed successfully!</p>");
            } else {
                out.println("<p>User not found. Please check your username and try again.</p>");
            }
        } catch (Exception e) {
            out.println("<p>Error processing request: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    } else {
        out.println("<p>Please enter a username.</p>");
    }
%>
</body>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, cs336.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
    <title>List a Car for Sale</title>
</head>
<body>
    <h1>List a Car for Sale</h1>
    <form method="POST">
        <label for="endDate">Auction End Date and Time:</label><br>
        <input type="datetime-local" id="endDate" name="endDate" required><br><br>

        <label for="minSellingPrice">Minimum Selling Price:</label><br>
        <input type="number" id="minSellingPrice" name="minSellingPrice" required><br><br>

        <label for="bidIncrement">Bid Increment:</label><br>
        <input type="number" id="bidIncrement" name="bidIncrement" required><br><br>

        <label for="VIN">VIN:</label><br>
        <input type="text" id="VIN" name="VIN" required><br><br>

        <label for="Price">Price:</label><br>
        <input type="number" id="Price" name="Price" required><br><br>

        <label for="Make">Make:</label><br>
        <input type="text" id="Make" name="Make" required><br><br>

        <label for="Model">Model:</label><br>
        <input type="text" id="Model" name="Model" required><br><br>

        <label for="Year">Year:</label><br>
        <input type="number" id="Year" name="Year" required><br><br>

        <label for="Mileage">Mileage:</label><br>
        <input type="number" id="Mileage" name="Mileage" required><br><br>

        <input type="submit" value="List Car">
    </form>
<% 
    // Initialize necessary variables from the form data
    String endDate = request.getParameter("endDate");
    String minSellingPrice = request.getParameter("minSellingPrice");
    String bidIncrement = request.getParameter("bidIncrement");
    String VIN = request.getParameter("VIN");
    String price = request.getParameter("Price");
    String make = request.getParameter("Make");
    String model = request.getParameter("Model");
    String year = request.getParameter("Year");
    String mileage = request.getParameter("Mileage");

    // Check if the form has been submitted (e.g., check one required field)
    if (endDate != null && !endDate.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            // Establish database connection
            conn = ApplicationDB.getConnection();

            // Insert into the Auctions table
            String sqlInsertAuction = "INSERT INTO Auctions (endDate, minSellingPrice, bidIncrement) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sqlInsertAuction, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, endDate);
            pstmt.setInt(2, Integer.parseInt(minSellingPrice));
            pstmt.setInt(3, Integer.parseInt(bidIncrement));
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                // Get the generated key for the auction (listing ID)
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    long listingID = rs.getLong(1);

                    // Insert into the Car table using the new listing ID
                    String sqlInsertCar = "INSERT INTO Car (VIN, Price, Make, Model, Year, Mileage, listingID) VALUES (?, ?, ?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sqlInsertCar);
                    pstmt.setString(1, VIN);
                    pstmt.setInt(2, Integer.parseInt(price));
                    pstmt.setString(3, make);
                    pstmt.setString(4, model);
                    pstmt.setInt(5, Integer.parseInt(year));
                    pstmt.setInt(6, Integer.parseInt(mileage));
                    pstmt.setLong(7, listingID);
                    pstmt.executeUpdate();

                    out.println("<p>Car listed successfully!</p>");
                } else {
                    out.println("<p>Error: Auction was not created, no ID obtained.</p>");
                }
            } else {
                out.println("<p>Error: No rows affected, auction not created.</p>");
            }
        } catch (Exception e) {
            out.println("<p>Error processing request: " + e.getMessage() + "</p>");
        } finally {
            // Clean up database resources
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }
%>


</body>
</html>

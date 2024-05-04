<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="java.sql.*, cs336.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
    <title>List an Item for Sale</title>
    <script>
        function showFields() {
            var productType = document.getElementById("productType").value;
            var carFields = document.getElementById("carFields");
            var boatFields = document.getElementById("boatFields");
            var motorbikeFields = document.getElementById("motorbikeFields");

            carFields.style.display = "none";
            boatFields.style.display = "none";
            motorbikeFields.style.display = "none";

            if (productType === "Car") {
                carFields.style.display = "block";
            } else if (productType === "Boat") {
                boatFields.style.display = "block";
            } else if (productType === "Motorbike") {
                motorbikeFields.style.display = "block";
            }
        }
    </script>
</head>
<body>
    <h1>Create an Auction and List an Item for Sale</h1>
    <form method="POST">
        <!-- Auction Details -->
        <label for="endDate">Auction End Date and Time:</label><br>
        <input type="datetime-local" id="endDate" name="endDate" required><br><br>

        <label for="minSellingPrice">Minimum Selling Price:</label><br>
        <input type="number" id="minSellingPrice" name="minSellingPrice" required><br><br>

        <label for="bidIncrement">Bid Increment:</label><br>
        <input type="number" id="bidIncrement" name="bidIncrement" required><br><br>

        <!-- Product Type Selection -->
        <label for="productType">Choose Product Type:</label><br>
        <select id="productType" name="productType" onchange="showFields()" required>
            <option value="">Select...</option>
            <option value="Car">Car</option>
            <option value="Boat">Boat</option>
            <option value="Motorbike">Motorbike</option>
        </select><br><br>

        <!-- Car Fields -->
        <div id="carFields" style="display:none;">
            <input type="text" name="VIN" placeholder="VIN" required><br>
            <input type="number" name="Price" placeholder="Price" required><br>
            <input type="text" name="Make" placeholder="Make" required><br>
            <input type="text" name="Model" placeholder="Model" required><br>
            <input type="number" name="Year" placeholder="Year" required><br>
            <input type="number" name="Mileage" placeholder="Mileage" required><br>
        </div>

        <!-- Boat Fields -->
        <div id="boatFields" style="display:none;">
            <input type="text" name="VIN" placeholder="VIN" required><br>
            <input type="number" name="Price" placeholder="Price" required><br>
            <input type="text" name="Make" placeholder="Make" required><br>
            <input type="text" name="Model" placeholder="Model" required><br>
            <input type="number" name="Year" placeholder="Year" required><br>
            <input type="number" name="Mileage" placeholder="Mileage" required><br>
        </div>

        <!-- Motorbike Fields -->
        <div id="motorbikeFields" style="display:none;">
            <input type="text" name="VIN" placeholder="VIN" required><br>
            <input type="number" name="Price" placeholder="Price" required><br>
            <input type="text" name="Make" placeholder="Make" required><br>
            <input type="text" name="Model" placeholder="Model" required><br>
            <input type="number" name="Year" placeholder="Year" required><br>
            <input type="number" name="Mileage" placeholder="Mileage" required><br>
        </div>

        <input type="submit" value="Create Auction and List Item">
    </form>
    <% 
        String endDate = request.getParameter("endDate");
        if (endDate != null && !endDate.isEmpty()) {
            String minSellingPrice = request.getParameter("minSellingPrice");
            String bidIncrement = request.getParameter("bidIncrement");
            String productType = request.getParameter("productType");
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = ApplicationDB.getConnection();
                String sqlInsertAuction = "INSERT INTO Auctions (endDate, minSellingPrice, bidIncrement) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(sqlInsertAuction, Statement.RETURN_GENERATED_KEYS);
                pstmt.setString(1, endDate);
                pstmt.setInt(2, Integer.parseInt(minSellingPrice));
                pstmt.setInt(3, Integer.parseInt(bidIncrement));
                int affectedRows = pstmt.executeUpdate();
                if (affectedRows > 0) {
                    rs = pstmt.getGeneratedKeys();
                    if (rs.next()) {
                        long listingID = rs.getLong(1);
                        // Insert product details based on the product type
                        String sqlInsertProduct = "INSERT INTO " + productType + " (VIN, Price, Make, Model, Year, Mileage, listingID) VALUES (?, ?, ?, ?, ?, ?, ?)";
                        pstmt = conn.prepareStatement(sqlInsertProduct);
                        pstmt.setString(1, request.getParameter("VIN"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("Price")));
                        pstmt.setString(3, request.getParameter("Make"));
                        pstmt.setString(4, request.getParameter("Model"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("Year")));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("Mileage")));
                        pstmt.setLong(7, listingID);
                        pstmt.executeUpdate();
                        out.println("<p>Product listed successfully!</p>");
                        out.println("<a href='sell.jsp'><button type='button'>List Another Product</button></a>");
                    }else{
                    	out.println("<p>Error: No ID obtained, product not listed.</p>");
                    }
                }else{
                	out.println("<p>Error: Auction could not be created, no rows affected.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                if (conn != null) try { conn.close(); } catch (SQLException e) { }
            }
        }
    %>
</body>
</html>

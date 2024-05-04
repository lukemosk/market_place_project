<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*, java.util.*, java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="cs336.ApplicationDB"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Create Auction</title>
</head>
<body>
    <%
        try {
            Connection con = ApplicationDB.getConnection();

            String vin = request.getParameter("vin");
            String vehicleType = request.getParameter("vehicleType");
            String make = request.getParameter("make");
            String model = request.getParameter("model");
            int year = Integer.parseInt(request.getParameter("year"));
            int mileage = Integer.parseInt(request.getParameter("mileage"));
            String color = request.getParameter("color");
            int sellerId = Integer.parseInt(request.getParameter("sellerId"));
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            double startingPrice = Double.parseDouble(request.getParameter("startingPrice"));
            Double reservePrice = request.getParameter("reservePrice") != null 
                ? Double.parseDouble(request.getParameter("reservePrice")) 
                : null;

            con.setAutoCommit(false);

            String insertVehicleSQL = "INSERT INTO vehicles (VIN, vehicle_type, owner_id, make, model, year, mileage, color) "
                                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement vehicleStmt = con.prepareStatement(insertVehicleSQL);
            vehicleStmt.setString(1, vin);
            vehicleStmt.setString(2, vehicleType);
            vehicleStmt.setInt(3, sellerId);
            vehicleStmt.setString(4, make);
            vehicleStmt.setString(5, model);
            vehicleStmt.setInt(6, year);
            vehicleStmt.setInt(7, mileage);
            vehicleStmt.setString(8, color);
            vehicleStmt.executeUpdate();

            String insertAuctionSQL = "INSERT INTO auctions (vehicle_id, seller_id, start_date, end_date, starting_price, current_price, reserve_price, status) "
                                    + "VALUES (?, ?, ?, ?, ?, ?, ?, 'pending')";
            PreparedStatement auctionStmt = con.prepareStatement(insertAuctionSQL);
            auctionStmt.setString(1, vin);
            auctionStmt.setInt(2, sellerId);
            auctionStmt.setString(3, startDate);
            auctionStmt.setString(4, endDate);
            auctionStmt.setDouble(5, startingPrice);
            auctionStmt.setDouble(6, startingPrice);
            if (reservePrice != null) {
                auctionStmt.setDouble(7, reservePrice);
            } else {
                auctionStmt.setNull(7, java.sql.Types.DECIMAL);
            }
            auctionStmt.executeUpdate();

            con.commit();

        
            out.println("<p>Success! Auction created successfully.</p>");

            vehicleStmt.close();
            auctionStmt.close();
           
            ApplicationDB.closeConnection(con);

        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>
</body>
</html>

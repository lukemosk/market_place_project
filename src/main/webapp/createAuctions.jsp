<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Your Own Auction!</title>
</head>
<body>
    <h2>Welcome!</h2>
    <p>Please fill out the form below to create your own auction:</p>
    <form action="submitAuction.jsp" method="POST">
        <!-- Vehicle Information -->
        <h3>Vehicle Details</h3>
        <label for="vin">VIN:</label>
        <input type="text" id="vin" name="vin" required>
        <br>
        <label for="vehicleType">Vehicle Type:</label>
        <select id="vehicleType" name="vehicleType" required>
            <option value="car">Car</option>
            <option value="motorbike">Motorbike</option>
            <option value="boat">Boat</option>
        </select>
        <br>
        <label for="make">Make:</label>
        <input type="text" id="make" name="make" required>
        <br>
        <label for="model">Model:</label>
        <input type="text" id="model" name="model" required>
        <br>
        <label for="year">Year:</label>
        <input type="number" id="year" name="year" required>
        <br>
        <label for="mileage">Mileage:</label>
        <input type="number" id="mileage" name="mileage" required>
        <br>
        <label for="color">Color:</label>
        <input type="text" id="color" name="color" required>
        <br>

        <!-- Auction Information -->
        <h3>Auction Details</h3>
        <label for="startDate">Start Date and Time:</label>
        <input type="datetime-local" id="startDate" name="startDate" required>
        <br>
        <label for="endDate">End Date and Time:</label>
        <input type="datetime-local" id="endDate" name="endDate" required>
        <br>
        <label for="startingPrice">Starting Price ($):</label>
        <input type="number" id="startingPrice" name="startingPrice" step="0.01" required>
        <br>
        <label for="reservePrice">Reserve Price ($):</label>
        <input type="number" id="reservePrice" name="reservePrice" step="0.01">
        <br>
        
        <!-- Seller ID -->
        <h3>Seller Information</h3>
        <label for="sellerId">User ID:</label>
        <input type="number" id="sellerId" name="sellerId" required>
        <br>
        
        <!-- Submit Button -->
        <button type="submit">Create Auction</button>
    </form>
</body>
</html>

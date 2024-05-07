<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="cs336.Queries"%>
<%@ page import="cs336.ApplicationDB"%>
<%@ page import="java.util.Timer"%>
<%@ page import="java.util.TimerTask"%>
<%@ page import="cs336.AuctionCloser"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Login Result</title>
</head>
<body>
    <h2>Login</h2>
    <form action="login.jsp" method="POST">
        Username: <input type="text" name="username" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Login">
    </form>
    <p>Register</p>
    <form action="register.jsp" method="POST">
        <button>Register</button>
    </form>
    <br><br>
    <%
        // If they are logged in, send them to home page
        if (session.getAttribute("user") != null) {
            response.sendRedirect("home.jsp");
            return;
        }
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if (username == null || password == null) {
            return;
        }
        try (Connection conn = ApplicationDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(Queries.getLoginUser(username, password));
             ResultSet rs = stmt.executeQuery()) {
            if (conn == null) {
                out.println("<h1>Login Failed: SQL Error.</h1>");
                return;
            }
            if (rs.next()) {
                session.setAttribute("user", username);
                session.setAttribute("type", rs.getString(2));
                // Start the AuctionCloser timer
                AuctionCloser auctionCloser = new AuctionCloser();
                Timer timer = new Timer();
                timer.scheduleAtFixedRate(auctionCloser, 0, AuctionCloser.getInterval());
                response.sendRedirect("home.jsp");
            } else {
                out.println("<h2>Login Failed: Incorrect username or password.</h2>");
                out.println("<h2>Please try again.</h2>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.sql.*, cs336.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Users</title>
</head>
<style>
.disabled {
	pointer-events: none;
	background: gainsboro;
}
</style>
<body>
	<%
	if(session.getAttribute("user") == null) {
		response.sendRedirect("login.jsp");
	} else {
		String type = (String) session.getAttribute("type");
		if (!type.equals("admin") && (!type.equals("cs"))) {
			out.println("<h1>You do not have permission for this.</h1>");
			out.println("<a href='home.jsp'>Home</a>");
			return;
		}
	}
	%>
	<a href='home.jsp'>Home</a>
    <h2>Please select a user to edit:</h2>
    <form method="POST">
	  	<label for="users">User: </label> 
	  		<select name="selected_user">
			<%
			try {
				Connection conn = ApplicationDB.getConnection();
				String getAllUsersQuery = "SELECT username FROM users WHERE type='default';";
				ResultSet rs = conn.prepareStatement(getAllUsersQuery).executeQuery();
		
				while (rs.next()) {
					String user = rs.getString(1);
					out.println("<option value=\"" + user + "\">" + user + "</option>");
				}
			} catch (Exception e) {
				return;
			}
			%>
			</select>
		<input type="submit" value="Select">
	</form>
	<br> <br>
	<%
	String user = request.getParameter("selected_user");
	
	String editUserID = request.getParameter("id_original");
	String username_edit = request.getParameter("username_edit");
	String password_edit = request.getParameter("password_edit");
	String email_edit = request.getParameter("email_edit");
	String dob_edit = request.getParameter("dob_edit");

	if ((user == null) && (password_edit == null || username_edit == null || email_edit == null || dob_edit == null)) {
		return;
	}
	
	if(password_edit != null && username_edit != null && email_edit != null && dob_edit != null) {
		String updateQuery = "UPDATE users "
							+ "SET username = '" + username_edit + "', password = '" + password_edit + "', "
							+ "email = '" + email_edit + "', dob = '" +  dob_edit + "' "
							+ "WHERE id = " + editUserID + ";";
		try {
			Connection conn = ApplicationDB.getConnection();
			int updatedRows = conn.prepareStatement(updateQuery).executeUpdate();

			if (updatedRows > 0) {
				out.println("<h3>Success!</h3>");
			} else {
				out.println("<h3>Error...ID not found!</h3>");
			}
			conn.close();
		} catch (Exception e) {
			out.println("<h2>SQL Error when trying to update!</h2>");
			return;
		}
	} else {
		String id = null;
		String password = null;
		String email = null;
		String dob = null;
		
		try {
			Connection conn = ApplicationDB.getConnection();
			String getUserIDQuery = "SELECT id, password, email, dob FROM users where username='" + user + "'";
			ResultSet rs = conn.prepareStatement(getUserIDQuery).executeQuery();
			if (rs.next()) {
				id = rs.getString(1);
				password = rs.getString(2);
				email = rs.getString(3);
				dob = rs.getString(4);
				rs.close();
			} else {
				out.println("<h2>SQL Error when grabbing values.</h2>");
				rs.close();
				return;
			}
			conn.close();
		} catch (Exception e) {
			out.println("<h2>SQL Error when trying to update!</h2>");
			return;
		}
		%>
		<h2><%= user %>'s Information</h2>
	    <form method="POST">
	    	<label for="id">ID:</label><br>
	        <input type="text" name="id_original" value="<%= id %>" class="disabled" readonly><br><br>
	    	
	        <label for="username">Username:</label><br>
	        <input type="text" name="username_edit" value="<%= user %>" required><br><br>

	        <label for="password">Password:</label><br>
	        <input type="password" name="password_edit" value="<%= password %>" required><br><br>

	        <label for="email">Email Address:</label><br>
	        <input type="text" name="email_edit" value="<%= email == null ? "" : email %>" required><br><br>

	        <label for="dob">D.O.B:</label><br>
	        <input type="date" name="dob_edit" value="<%= dob %>" required><br><br>
	        <input type="submit" value="Save Information">
	    </form>
	    <%
	}
	%>
</body>
</html>
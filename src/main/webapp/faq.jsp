<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="cs336.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
<title>FAQ Page</title>
<style>
body {
	font-family: Arial, sans-serif;
	text-align: center;
	padding-top: 50px;
}

.button {
	background-color: #89CFF0;
	border: none;
	color: white;
	padding: 8px 16px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 16px;
	margin: 4px 2px;
	cursor: pointer;
}

.question {
	border: 2px solid #ccc;
	padding: 10px 10px;
	margin-right: 25%;
	margin-left: 25%;
	margin-top: 35px;
	margin-bottom: 70px;
	background-color: #e9e9e9;
}

.question h3 {
	font-size: 18px;
	margin: 0;
}

.question p {
	font-size: 14px;
}

.reply {
	border: 2px solid #ccc;
	padding: 10px 10px;
	margin-right: 0%;
	margin-left: 0%;
	margin-top: 10px;
	margin-bottom: 10px;
	background-color: #e9e9e9;
}

.reply h3 {
	font-size: 16px;
	margin: 0;
}

.reply p {
	font-size: 12px;
}
</style>
</head>
<body>
	<%
	if (session.getAttribute("user") == null) {
		response.sendRedirect("login.jsp");
		return;
	}
	%>
	<h1>Welcome to the FAQ page!</h1>
	<a href="home.jsp" class="button">Home</a>
	<br>
	<br>
	<br>
	<br>
	<h3>Post a question...</h3>
	<div>
		<form>
			<textarea name="content" placeholder="Ask a question..."
				style="width: 400px; height: 100px;"></textarea>
			<input type="submit" value="Post">
		</form>
	</div>
	<br>
	<h3>Search for a question...</h3>
	<div>
		<form>
			<input type="text" name="search">
			<input type="submit" value="Search">
		</form>
	</div>
	<br>
	<br>

	<%
	String delete_id = request.getParameter("delete");
	String parent_id = request.getParameter("parent_id");
	String content = request.getParameter("content");
	String search_content = request.getParameter("search");

	// If a delete request was sent
	if (delete_id != null) {
		try {
			Connection conn = ApplicationDB.getConnection();
			String deleteReplies = "DELETE FROM faqs WHERE parent_id=" + delete_id + ";";
			String deleteQuestion = "DELETE FROM faqs WHERE message_id=" + delete_id + ";";
			conn.prepareStatement(deleteReplies).executeUpdate();
			int updatedRows = conn.prepareStatement(deleteQuestion).executeUpdate();

			if (updatedRows > 0) {
				conn.close();
				response.sendRedirect("faq.jsp");
			} else {
				out.println("<h2>SQL Error when trying to delete message (no rows deleted)!</h2>");
				conn.close();
				return;
			}
		} catch (Exception e) {
			out.println("<h2>SQL Error when trying to delete message!</h2>");
			return;
		}
	}

	// If it was a reply
	else if (parent_id != null && content != null) {
		try {
			String currentUser = (String) session.getAttribute("user");
			Connection conn = ApplicationDB.getConnection();
			String getUserIDQuery = "SELECT id FROM users where username='" + currentUser + "'";
			ResultSet rs = conn.prepareStatement(getUserIDQuery).executeQuery();
			String sellerID = null;
			if (rs.next()) {
				sellerID = rs.getString(1);
				rs.close();
			} else {
				out.println("<h2>SQL Error.</h2>");
				rs.close();
				return;
			}

			String addReply = "INSERT INTO faqs (poster_id, parent_id, content) VALUES (" + sellerID + ", " + parent_id
							+ ", '" + content + "');";
			int updatedRows = conn.prepareStatement(addReply).executeUpdate();

			if (updatedRows > 0) {
				conn.close();
				response.sendRedirect("faq.jsp");
				return;
			} else {
				out.println("<h2>SQL Error when trying to add reply (no rows added)!</h2>");
				conn.close();
				return;
			}
		} catch (Exception e) {
			out.println("<h2>SQL Error when trying to add reply!</h2>");
			return;
		}
	}

	// If a question was requested to be posted
	else if (content != null) {
		try {
			String currentUser = (String) session.getAttribute("user");
			Connection conn = ApplicationDB.getConnection();
			String getUserIDQuery = "SELECT id FROM users where username='" + currentUser + "'";
			ResultSet rs = conn.prepareStatement(getUserIDQuery).executeQuery();
			String sellerID = null;
			if (rs.next()) {
				sellerID = rs.getString(1);
				rs.close();
			} else {
				out.println("<h2>SQL Error.</h2>");
				rs.close();
				return;
			}

			String addReply = "INSERT INTO faqs (poster_id, content) VALUES (" + sellerID + ", '" + content + "');";
			int updatedRows = conn.prepareStatement(addReply).executeUpdate();

			if (updatedRows > 0) {
				conn.close();
				response.sendRedirect("faq.jsp");
				return;
			} else {
				out.println("<h2>SQL Error when trying to add question (no rows added)!</h2>");
				conn.close();
				return;
			}
		} catch (Exception e) {
			out.println("<h2>SQL Error when trying to add question!</h2>");
			return;
		}
	}

	// NOW LOAD QUESTIONS

	try {
		Connection conn = ApplicationDB.getConnection();
		String type = (String) session.getAttribute("type");
		String getQuestionsQuery = null;
		if(search_content != null) {
			getQuestionsQuery = "SELECT message_id, poster_id, content FROM faqs WHERE parent_id IS NULL "
					+ "AND content like '%"
					+ search_content + "%' "
					+ "ORDER BY message_id DESC;";
		} else {
			getQuestionsQuery = "SELECT message_id, poster_id, content FROM faqs WHERE parent_id IS NULL ORDER BY message_id DESC;";
		}
		ResultSet questions = conn.prepareStatement(getQuestionsQuery).executeQuery();

		while (questions.next()) {
			String message_id = questions.getString(1);
			String poster_id = questions.getString(2);
			String message_content = questions.getString(3);

			String getUserNameQuery = "SELECT username FROM users where id='" + poster_id + "'";
			ResultSet nameResult = conn.prepareStatement(getUserNameQuery).executeQuery();
			String posterName = null;
			if (nameResult.next())
				posterName = nameResult.getString(1);
			else
				posterName = "ERR";
			nameResult.close();
			%>
			<div class="question">
				<h3><%=posterName%></h3>
				<p><%=message_content%></p>
				<%
				String getRepliesQuery = "SELECT poster_id, content FROM faqs WHERE parent_id =" + message_id + ";";
				ResultSet replies = conn.prepareStatement(getRepliesQuery).executeQuery();
				while (replies.next()) {
					String reply_poster_id = replies.getString(1);
					String reply_content = replies.getString(2);
		
					String getReplyUserQuery = "SELECT username FROM users where id='" + reply_poster_id + "'";
					ResultSet replyNameResult = conn.prepareStatement(getReplyUserQuery).executeQuery();
					String replierName = null;
					if (replyNameResult.next())
						replierName = replyNameResult.getString(1);
					else
						replierName = "ERR";
					replyNameResult.close();
				%>
				<div class="reply">
					<h3><%=replierName%></h3>
					<p><%=reply_content%></p>
				</div>
				<%
				}
				
				if (type.equals("cs") || type.equals("admin")) {
				%>
				<form action="faq.jsp" method="POST">
					<button type="submit" name="delete" value="<%=message_id%>">Delete</button>
					<br>
					<br> <input type="text" name="content" placeholder="Reply..."
						style="width: 400px; height: 20px;"> <input type="submit"
						value="Reply"> <input type="hidden" name="parent_id"
						value="<%=message_id%>">
				</form>
				<%
				}
			%>
			</div>
		<%
		}
	} catch (Exception e) {
		out.println("<h2>SQL Error when trying to load questions!</h2>");
		return;
	}
	%>
</body>
</html>
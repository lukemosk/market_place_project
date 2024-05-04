package cs336;

public class Queries {
	
	public static String getLoginUser(String username, String password) {
		return "SELECT username, type FROM users WHERE username='" + username + "' AND password='" + password + "';";
	}
	
	public static String createLoginUser(String username, String password) {
		return "INSERT INTO users (username, password, type) VALUES ('" + username + "', '" + password + "', 'default');";
	}
	
	public static String createCSUser(String username, String password) {
		return "INSERT INTO users (username, password, type) VALUES ('" + username + "', '" + password + "', 'cs');";
	}
}

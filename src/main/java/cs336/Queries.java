package cs336;

public class Queries {
	
	public static String getLoginUser(String username, String password) {
		return "SELECT * FROM users WHERE username='" + username + "' AND password='" + password + "';";
	}
	
	public static String getLoginUser(String username) {
		return "SELECT * FROM users WHERE username='" + username + "';";
	}
	
	public static String getUserType(String username) {
		return "SELECT type FROM users WHERE username='" + username + "';";
	}
	
	public static String[] createLoginUser(String username, String password) {
		String lock = "LOCK TABLES users WRITE;";
		String insert = "INSERT INTO users (username, password, type) VALUES ('" + username + "', '" + password + "', 'default');";
		String unlock = "UNLOCK TABLES;";
		return new String[] {lock, insert, unlock};
	}
	
	public static String[] createCSUser(String username, String password) {
		String lock = "LOCK TABLES users WRITE;";
		String insert = "INSERT INTO users (username, password, type) VALUES ('" + username + "', '" + password + "', 'cs');";
		String unlock = "UNLOCK TABLES;";
		return new String[] {lock, insert, unlock};
	}
}

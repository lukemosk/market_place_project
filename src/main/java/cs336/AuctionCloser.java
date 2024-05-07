package cs336;

import java.sql.*;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.Timer;
import java.util.TimerTask;
import cs336.ApplicationDB;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AuctionCloser extends TimerTask {
    private static final Logger logger = Logger.getLogger(AuctionCloser.class.getName());

    private static final long INTERVAL = 5000; // 5 seconds

    public static long getInterval() {
        return INTERVAL;
    }

    public static void main(String[] args) {
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new AuctionCloser(), 0, INTERVAL);
    }

    @Override
    public void run() {
        logger.log(Level.INFO, "AuctionCloser task started");
        try (Connection conn = ApplicationDB.getConnection()) {
            // Get the current timestamp
            LocalDateTime currentTimestamp = LocalDateTime.now();

            // Query to fetch ongoing auctions that have reached their closing time
            String sql = "SELECT * FROM auctions WHERE status = 'ongoing' AND end_date <= ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setTimestamp(1, Timestamp.valueOf(currentTimestamp));
                ResultSet rs = stmt.executeQuery();

                // Process each auction
                while (rs.next()) {
                    int auctionId = rs.getInt("auction_id");
                    String vehicleId = rs.getString("vehicle_id");
                    int sellerId = rs.getInt("seller_id");

                    // Query to fetch the highest bid for the auction
                    String bidSql = "SELECT * FROM bids WHERE auction_id = ? ORDER BY bid_amount DESC LIMIT 1";
                    try (PreparedStatement bidStmt = conn.prepareStatement(bidSql)) {
                        bidStmt.setInt(1, auctionId);
                        ResultSet bidRs = bidStmt.executeQuery();

                        // Update the auction status to 'closed'
                        String updateSql = "UPDATE auctions SET status = 'closed' WHERE auction_id = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setInt(1, auctionId);
                            updateStmt.executeUpdate();
                        }

                        if (bidRs.next()) {
                            int winnerId = bidRs.getInt("bidder_id");
                            BigDecimal winningBid = bidRs.getBigDecimal("bid_amount");

                            // Alert the winner
                            String winnerMessage = "Congratulations! You have won the auction for vehicle " + vehicleId +
                                    " with a bid of " + winningBid.toPlainString() + ".";
                            String insertWinnerAlert = "INSERT INTO alerts_generic (user_id, message) VALUES (?, ?)";
                            try (PreparedStatement insertWinnerStmt = conn.prepareStatement(insertWinnerAlert)) {
                                insertWinnerStmt.setInt(1, winnerId);
                                insertWinnerStmt.setString(2, winnerMessage);
                                insertWinnerStmt.executeUpdate();
                            }

                            // Alert other bidders
                            String otherBiddersSql = "SELECT DISTINCT bidder_id FROM bids WHERE auction_id = ? AND bidder_id != ?";
                            try (PreparedStatement otherBiddersStmt = conn.prepareStatement(otherBiddersSql)) {
                                otherBiddersStmt.setInt(1, auctionId);
                                otherBiddersStmt.setInt(2, winnerId);
                                ResultSet otherBiddersRs = otherBiddersStmt.executeQuery();

                                while (otherBiddersRs.next()) {
                                    int bidderId = otherBiddersRs.getInt("bidder_id");
                                    String loserMessage = "Unfortunately, you did not win the auction for vehicle " + vehicleId + ".";
                                    String insertLoserAlert = "INSERT INTO alerts_generic (user_id, message) VALUES (?, ?)";
                                    try (PreparedStatement insertLoserStmt = conn.prepareStatement(insertLoserAlert)) {
                                        insertLoserStmt.setInt(1, bidderId);
                                        insertLoserStmt.setString(2, loserMessage);
                                        insertLoserStmt.executeUpdate();
                                    }
                                }
                            }
                        } else {
                            // No bids found for the auction
                            System.out.println("No bids found for auction with ID: " + auctionId);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error occurred while processing auctions", e);
            e.printStackTrace();
        }
        logger.log(Level.INFO, "AuctionCloser task completed");
    }
}
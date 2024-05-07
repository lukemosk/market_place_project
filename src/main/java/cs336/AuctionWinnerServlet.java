package cs336;

import javax.servlet.ServletException;
import javax.servlet.ServletContext;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

@WebServlet("/AuctionWinnerServlet")
public class AuctionWinnerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processAuctions(request.getServletContext());
    }

    public void processAuctions(ServletContext context) {
        try {
            Connection con = ApplicationDB.getConnection();

            String selectAuctionsQuery = "SELECT * FROM auctions WHERE status = 'ongoing'";
            PreparedStatement selectAuctionsStmt = con.prepareStatement(selectAuctionsQuery);
            ResultSet auctionsResult = selectAuctionsStmt.executeQuery();

            while (auctionsResult.next()) {
                int auctionId = auctionsResult.getInt("auction_id");
                Timestamp endTime = auctionsResult.getTimestamp("end_date");

                if (endTime.before(new Timestamp(System.currentTimeMillis()))) {
                    String selectHighestBidQuery = "SELECT * FROM bids WHERE auction_id = ? ORDER BY bid_amount DESC LIMIT 1";
                    PreparedStatement selectHighestBidStmt = con.prepareStatement(selectHighestBidQuery);
                    selectHighestBidStmt.setInt(1, auctionId);
                    ResultSet highestBidResult = selectHighestBidStmt.executeQuery();

                    double reservePrice = auctionsResult.getDouble("reserve_price");
                    int winnerId = 0;

                    if (highestBidResult.next()) {
                        double highestBid = highestBidResult.getDouble("bid_amount");
                        if (reservePrice == 0 || highestBid >= reservePrice) {
                            winnerId = highestBidResult.getInt("bidder_id");
                        }
                    }

                    String updateAuctionStatusQuery = "UPDATE auctions SET status = 'closed' WHERE auction_id = ?";
                    PreparedStatement updateAuctionStatusStmt = con.prepareStatement(updateAuctionStatusQuery);
                    updateAuctionStatusStmt.setInt(1, auctionId);
                    updateAuctionStatusStmt.executeUpdate();

                    if (winnerId != 0) {
                        String insertAlertQuery = "INSERT INTO alerts_generic (user_id, message) VALUES (?, 'Congratulations! You won the auction.')";
                        PreparedStatement insertAlertStmt = con.prepareStatement(insertAlertQuery);
                        insertAlertStmt.setInt(1, winnerId);
                        insertAlertStmt.executeUpdate();
                    }
                }
            }

            ApplicationDB.closeConnection(con);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

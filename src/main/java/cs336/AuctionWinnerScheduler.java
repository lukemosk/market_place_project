package cs336;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.Timer;
import java.util.TimerTask;

@WebListener
public class AuctionWinnerScheduler implements ServletContextListener {
    private Timer timer;
    private ServletContext context;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        context = sce.getServletContext();
        timer = new Timer();
        // Timer schedule changed for demonstration, ideally should be set according to requirements.
        timer.scheduleAtFixedRate(new AuctionWinnerTask(), 0, 5 * 1000); // Run every 5 minutes
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        timer.cancel();
    }

    private class AuctionWinnerTask extends TimerTask {
        @Override
        public void run() {
            System.out.println("AuctionWinnerTask is running...");
            try {
                AuctionWinnerServlet auctionWinnerServlet = new AuctionWinnerServlet();
                auctionWinnerServlet.processAuctions(context);
                System.out.println("AuctionWinnerServlet executed successfully.");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

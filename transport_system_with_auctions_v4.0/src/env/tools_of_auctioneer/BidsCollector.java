// CArtAgO artifact code for project transport_system_with_auctions

package tools_of_auctioneer;

import java.util.ArrayList;
import java.util.List;

import cartago.*;
import models.Bid;
import models.ComplexBid;

public class BidsCollector extends Artifact {
	
	public static List<Bid> roundOneBidsList = new ArrayList<>();
	public static List<ComplexBid> roundWinnersList = new ArrayList<>();
	public static List<List<ComplexBid>> roundBidsList = new ArrayList<>();
	public static ComplexBid endResult = new ComplexBid();
	public static double dayResult = 0;
	
	@OPERATION
	void fixateNewBids(ArrayList <Bid> newBusBidsList) {
		roundOneBidsList.addAll(newBusBidsList);
	}
	
	@OPERATION
	void fixateLastResult() {
		dayResult += endResult.getTotalBid();
		dayResult = Math.ceil(dayResult * Math.pow(10, 2)) / Math.pow(10, 2);
	}
	
	@OPERATION
	void clearResults() {
		BidsCollector.roundOneBidsList = new ArrayList<>();
		BidsCollector.roundWinnersList = new ArrayList<>();
		BidsCollector.roundBidsList = new ArrayList<>();
		BidsCollector.endResult = new ComplexBid();
	}
}


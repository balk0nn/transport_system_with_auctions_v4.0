package models;

import java.util.ArrayList;
import java.util.List;

public class ComplexBid {

	
	public List <Bid> winBids = new ArrayList<>();
	
	public ComplexBid(Bid... bids) {
		for(Bid bid : bids) {
			winBids.add(bid);
		}
	}
	
	public double getTotalBid() {
		double result = 0;
		for(int i=0; i < winBids.size();i++) {
			result += winBids.get(i).getBusBid();
		}
		result = Math.ceil(result * Math.pow(10, 2)) / Math.pow(10, 2);
		return result;
	}
	
	@Override
	public String toString() {
		StringBuilder result = new StringBuilder();
		for(Bid bid : winBids) {
			result.append(bid + "\n, ");
		}
		result.append("TotalBid: " + getTotalBid());
		return result.toString();
	}

	
	
}

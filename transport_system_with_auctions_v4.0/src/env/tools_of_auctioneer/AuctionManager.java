// CArtAgO artifact code for project transport_system_with_auctions

package tools_of_auctioneer;

import java.util.ArrayList;
import java.util.List;

import javax.swing.JOptionPane;

import cartago.*;
import models.*;

public class AuctionManager extends Artifact {
	
	@OPERATION
	void createAuction(OpFeedbackParam <Auction> newAuction) {
		Auction auction = new Auction();
		newAuction.set(auction);
	}

	@OPERATION
	void addPassenger(String name, double price, String startPoint, String endPoint, String startTime, Auction auction) {
		Passenger passenger = new Passenger(name, price, startPoint, endPoint, startTime);
		auction.getPassengersList().add(passenger);
	}
	
	@OPERATION
	void addBus(String name, Auction auction) {
		auction.getBusesList().add(name);
	}

	@OPERATION
	void createNewListInRoundBidsList() {
		List <ComplexBid> newListInRoundBidsList = new ArrayList<>();
		BidsCollector.roundBidsList.add(newListInRoundBidsList);
	}
	
	@OPERATION
	void countRoundResults(Auction auction) {
		if(NoticeBoard.currentRound == 1) {
			ComplexBid roundOneWinnerBids = new ComplexBid();
			chooseRoundOneWinners(auction,roundOneWinnerBids);
			for(int i=0; i < roundOneWinnerBids.winBids.size(); i++) {
				System.out.println(roundOneWinnerBids.winBids.get(i));
			}
			BidsCollector.roundWinnersList.add(NoticeBoard.currentRound-1,roundOneWinnerBids);
		}
		if (NoticeBoard.currentRound > 1) {
			
			
			try {
				ComplexBid roundWinner = BidsCollector.roundBidsList.get(NoticeBoard.currentRound-2).get(0);
			}
			catch(Exception e) {
				System.out.println("No bids were received");
				return;
			}
			
			
			ComplexBid roundWinner = BidsCollector.roundBidsList.get(NoticeBoard.currentRound-2).get(0);
			for(int i=0; i < BidsCollector.roundBidsList.get(NoticeBoard.currentRound-2).size(); i++) {
				if(roundWinner.getTotalBid() > BidsCollector.roundBidsList.get(NoticeBoard.currentRound-2).get(i).getTotalBid()) {
					roundWinner = BidsCollector.roundBidsList.get(NoticeBoard.currentRound-2).get(i);
				}
			}
			BidsCollector.roundWinnersList.add(NoticeBoard.currentRound-1,roundWinner);
			System.out.println(roundWinner);
		}
	}
	
	void chooseRoundOneWinners(Auction auction, ComplexBid roundOneWinnerBids) {		
		for(int i=0; i < auction.getPassengersList().size(); i++) {
			roundOneWinnerBids.winBids.add(i,BidsCollector.roundOneBidsList.get(i));
			for(int j=1; j < auction.getBusesList().size(); j++) {
				Bid anotherBid = BidsCollector.roundOneBidsList.get(i+j*auction.getPassengersList().size());
				if(anotherBid.getBusBid() < roundOneWinnerBids.winBids.get(i).getBusBid()) {
					roundOneWinnerBids.winBids.set(i,BidsCollector.roundOneBidsList.get(i+j*auction.getPassengersList().size()));
				}
			}
		}
	}
	
	@OPERATION
	public void declareResults() {
		int numOfRounds = BidsCollector.roundWinnersList.size();
		ComplexBid winCombination = (BidsCollector.roundWinnersList.get(0).getTotalBid() 
				> BidsCollector.roundWinnersList.get(numOfRounds-1).getTotalBid()) 
				? BidsCollector.roundWinnersList.get(numOfRounds-1): BidsCollector.roundWinnersList.get(numOfRounds-1);
			for(int i=1; i < numOfRounds-1; i++) {
				findRoundWinnerCombination(BidsCollector.roundWinnersList.get(0),BidsCollector.roundWinnersList.get(i));
				winCombination = (winCombination.getTotalBid() 
						> BidsCollector.roundWinnersList.get(i).getTotalBid()) 
						? BidsCollector.roundWinnersList.get(i): winCombination;
			}
		BidsCollector.endResult = winCombination;
		//JOptionPane.showMessageDialog(null, BidsCollector.endResult.toString().replaceAll(", ","\n"),"Winner combination", JOptionPane.INFORMATION_MESSAGE);
	}

	public void findRoundWinnerCombination(ComplexBid firstResultsList, ComplexBid secondResultsList) {
		boolean notInSecondList = false;
		for(int i=0; i < firstResultsList.winBids.size(); i++) {
			notInSecondList = false;
			for(int j=0; j < secondResultsList.winBids.size(); j++) {
				if(	firstResultsList.winBids.get(i).getPassengerName() != secondResultsList.winBids.get(j).getPassengerName()) {
					notInSecondList = true;
				}
				else {
					notInSecondList = false;
					break;
				}
			}
			if(notInSecondList) {
				secondResultsList.winBids.add(firstResultsList.winBids.get(i));
			}
		}
	}
	
	@OPERATION
	public void declareDayResults() {
		BidsCollector.dayResult *= -1;
		JOptionPane.showMessageDialog(null, "Total income from all completed requests: " + BidsCollector.dayResult,"Working day result", JOptionPane.INFORMATION_MESSAGE);
	}


}


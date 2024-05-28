// CArtAgO artifact code for project transport_system_with_auctions

package tools_of_bus;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.NoSuchElementException;

import cartago.*;
import models.Auction;
import models.Bid;
import models.Bus;
import models.ComplexBid;
import models.Passenger;
import tools_of_auctioneer.BidsCollector;
import tools_of_auctioneer.NoticeBoard;

public class BidCalculator extends Artifact {
	
	public static int numOfBids = 0;

	@OPERATION
	public void makeBids(String busPoint, double weightA, double weightB, double weightG,
			String busName, Auction auction, OpFeedbackParam <List<Bid>> newBids) {
		List <Passenger> passengerList = auction.getPassengersList();
		newBids.set(evokeCalculation(busPoint, weightA, weightB, weightG,busName, passengerList));
	}
	
	public List<Bid> evokeCalculation(String busPoint, double weightA, double weightB, double weightG,
			String busName, List<Passenger> passengerList){
		double[] weights = {weightA/100, weightB/100, weightG/100};
		double[] bids = calculateBids(busPoint, weights, passengerList);
		List<Bid> bidsList = new ArrayList<>();
		for(int i = 0; i < bids.length; i++) {
			Bid bid = new Bid(++numOfBids, passengerList.get(i).getName(), busName, bids[i]);
			bidsList.add(bid);
		}
		return bidsList;
	}
	
	public double[] calculateBids(String busPoint, double[] weights, List<Passenger> passengerList) {
		double[] bids = new double[passengerList.size()];
		for(int i = 0; i < bids.length; i++) {
			bids[i] += (-1) * weights[0] * passengerList.get(i).getPrice() 
					+ weights[1] * calculatePathsLength(busPoint,passengerList.get(i)) + weights[2] * 360;
			bids[i] = Math.ceil(bids[i] * Math.pow(10, 2)) / Math.pow(10, 2);
		}
		return bids;
	}
	
	public int calculatePathsLength(String busPoint, Passenger passenger) {
		int length = 0;
		
		length+= ShortestPathSearcher.getShortestPathLength(busPoint, passenger.getStartPoint());
		length+= ShortestPathSearcher.getShortestPathLength(passenger.getStartPoint(), passenger.getEndPoint());
		
		return length;
	}
	
	@OPERATION
	public void findBestBidsCombination(String busPoint, double weightA, double weightB, double weightG,
			String busName, Auction auction, int capacity, int numberOfPassengers) {
		
		if (NoticeBoard.currentRound > capacity - numberOfPassengers) {
			return;
		}
		
		List <Passenger> passengerList = auction.getPassengersList();
		List<Bid> minBidsList = new ArrayList<>();
		List <Bid> bidsList = new ArrayList<>();
		
		//first min in sequence
		bidsList = evokeCalculation(busPoint, weightA, weightB, weightG,busName, passengerList);
		Bid minBid = bidsList.stream().min(Comparator.comparing(Bid::getBusBid)).orElseThrow(NoSuchElementException::new);
		minBidsList.add(minBid);
		
		//next min in sequence
		for (int i=1; i < NoticeBoard.currentRound;i++) {
			String newBusPoint = getEndPoint(passengerList,minBidsList.get(i-1).getPassengerName());
			passengerList = cutChosenFromPassengerList(passengerList,minBidsList.get(i-1).getPassengerName());
			bidsList = evokeCalculation(newBusPoint, weightA, weightB, weightG,busName, passengerList);
			minBid = bidsList.stream().min(Comparator.comparing(Bid::getBusBid)).orElseThrow(NoSuchElementException::new);
			minBidsList.add(minBid);
		}
		
		//fixate bid
		ComplexBid complexBid = new ComplexBid(minBidsList.get(0));
		for(int i=1; i < minBidsList.size();i++) {
			complexBid.winBids.add(i,minBidsList.get(i));
		}
		BidsCollector.roundBidsList.get(NoticeBoard.currentRound-2).add(complexBid);
		printBid(complexBid);
	}
	
	public List <Passenger> cutChosenFromPassengerList(List <Passenger> passengerList, String passengerName){
		List <Passenger> newPassengerList = new ArrayList<>();
		for(Passenger passenger: passengerList) {
			if(!passenger.getName().equals(passengerName)) {
				newPassengerList.add(passenger);
			}
		}
		return newPassengerList;
	}
	
	public String getEndPoint(List <Passenger> passengerList, String passengerName) {
		String endPoint = "";
		for(Passenger passenger: passengerList) {
			if(!passenger.getName().equals(passengerName)) {
				endPoint = passenger.getEndPoint();
			}
		}
		return endPoint;
	}
	
	public void printBid(ComplexBid complexBid) {
		String result = complexBid.winBids.get(0).toString();
		for(int i=1; i < NoticeBoard.currentRound;i++) {
			result+=" and " + complexBid.winBids.get(i).toString();
		}
		System.out.println(result);
	}
	
	@OPERATION
	public void fixateStops(Bus bus, Auction auction, OpFeedbackParam <Integer> numberOfPassengers) {
		for(Bid bid : BidsCollector.endResult.winBids) {
			if(bid.getBusName().equals(bus.getName())){
				for(Passenger passenger : auction.getPassengersList()) {
					if(bid.getPassengerName().equals(passenger.getName())){
						bus.setCurrentPoint(passenger.getEndPoint());
						bus.getNextStops().add(passenger.getEndPoint());
					}
				}
			}
		}
		numberOfPassengers.set(bus.getNextStops().size() - bus.getNumberOfCompletedRides());
	}
	
	@OPERATION
	public void moveToNextStop(Bus bus,
			OpFeedbackParam <String> newPoint, OpFeedbackParam <Integer> numberOfPassengers) {
		if(bus.getNextStops().size() <= bus.getNumberOfCompletedRides()) {
			newPoint.set(bus.getCurrentPoint());
			numberOfPassengers.set(0);
		}
		else {
			bus.setCurrentPoint(bus.getNextStops().get(bus.getNumberOfCompletedRides()));
			bus.setNumberOfCompletedRides(bus.getNumberOfCompletedRides() + 1);
			newPoint.set(bus.getCurrentPoint());
			numberOfPassengers.set(bus.getNextStops().size() - bus.getNumberOfCompletedRides());
		}
	}
	
	@OPERATION
	public void createBus(String name, String point, OpFeedbackParam <Bus> newBus) {
		Bus bus = new Bus(name, point);
		newBus.set(bus);
	}
	
}


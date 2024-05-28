// CArtAgO artifact code for project transport_system_with_auctions

package tools_of_auctioneer;

import cartago.*;
import models.Auction;

public class NoticeBoard extends Artifact {
	
	public static int currentRound = 0;
	public static Auction currentAuction;
	
	void init() {
		defineObsProperty("last_notice", "");
		defineObsProperty("current_round", currentRound);
		defineObsProperty("current_auction", currentAuction);
	}

	@OPERATION
	void writeNotice(String notice) {
		System.out.println("[NOTICEBOARD] " + notice);
		getObsProperty("last_notice").updateValue(notice);
	}
	
	@OPERATION
	void writeNoticeRound() {
		currentRound++;
		String notice = "Round " + currentRound + " has been started.";
		System.out.println("[NOTICEBOARD] " + notice);
		getObsProperty("last_notice").updateValue(notice);
		getObsProperty("current_round").updateValue(currentRound);
	}
	
	
	@OPERATION
	void announceParticipants(Auction auction) {
		System.out.println("[NOTICEBOARD] Participants of the current auction:");
		System.out.print("Passengers: ");
		for (int i = 0; i < auction.getPassengersList().size(); i++) {
			System.out.print(auction.getPassengersList().get(i).getName() + "; ");
		}
		System.out.println();
		System.out.print("Buses: ");
		for (int i = 0; i < auction.getBusesList().size(); i++) {
			System.out.print(auction.getBusesList().get(i) + "; ");
		}
		System.out.println();
		getObsProperty("current_auction").updateValue(auction);
	}
	
	@OPERATION
	void writeNoticeRoundEnd() {
		String notice = "Round " + currentRound + " has been ended.";
		System.out.println("[NOTICEBOARD] " + notice);
		getObsProperty("last_notice").updateValue(notice);
		System.out.println("[NOTICEBOARD] Round winners:");
	}
	
	@OPERATION
	void writeNoticeAuctionEnd() {
		String notice = "Auction has been ended.";
		System.out.println("[NOTICEBOARD] " + notice);
		getObsProperty("last_notice").updateValue(notice);
		System.out.println("[NOTICEBOARD] Auction winners:");
		System.out.println(BidsCollector.endResult);
	}
	
	@OPERATION
	void writeNoticeWorkingDayEnd() {
		String notice = "Working day has been ended.";
		System.out.println("[NOTICEBOARD] " + notice);
		getObsProperty("last_notice").updateValue(notice);
		System.out.println("[NOTICEBOARD] Working day result:");
		System.out.println(BidsCollector.dayResult);
	}
	
	@OPERATION
	void clearProperties() {
		currentRound = 0;
		currentAuction = null;
		getObsProperty("current_round").updateValue(currentRound);
		getObsProperty("current_auction").updateValue(currentAuction);
	}
	
}



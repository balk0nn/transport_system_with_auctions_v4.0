// Agent auctioneer in project transport_system_with_auctions

/* Initial beliefs and rules */

number_of_auctions(0).
number_of_requests(0).
threshold(4).
number_of_bus_participants(0).
round_replies(0).
threshold_auctions(100).

/* Initial goals */

//!start_waiting.

/* Plans */

+permission(A,_,committed(A,M,S),_): .my_name(A) & my_mission(M)  <- commitMission(M).

+!start_waiting: number_of_auctions(NA) & threshold_auctions(TA) & TA > NA <- .wait(500);
						.print("is waiting for requests");
						createAuction(A);
						+auction(A);
						writeNotice("The collection of requests has been started.").
						
+!start_waiting: number_of_auctions(NA) & threshold_auctions(TA) & TA <= NA <- declareDayResults; writeNoticeWorkingDayEnd.

+!add_passenger(N,P,SP,EP,ST): number_of_requests(NR) & threshold(T) & NR > T <- .send(N,tell,request_status("denied")).

+!add_passenger(N,P,SP,EP,ST): number_of_requests(NR) & threshold(T) & NR = T <- .send(N,tell,request_status("denied")).

+!add_passenger(N,P,SP,EP,ST): auction(A) & number_of_requests(NR) & threshold(T) & NR < T
																			<- addPassenger(N,P,SP,EP,ST,A);
																				.print("has added a passenger's request");
																				.send(N,tell,request_status("accepted"));
																				-number_of_requests(NR);
																				+number_of_requests(NR + 1).

+!add_bus(N): auction(A) & number_of_bus_participants(NBP) <- addBus(N,A);
									.print("has added a bus's application");
									.send(N,tell,application_status("accepted"));
									-number_of_bus_participants(NBP);
									+number_of_bus_participants(NBP+1).

+number_of_requests(NR): threshold(T) & NR == T <- .print("has achieved the threshold");
													writeNotice("The collection of requests has been finished.");
													!collect_applications.
													
+!collect_applications <- writeNotice("The collection of applications has been started.");
							.wait(2000);
							writeNotice("The collection of applications has been finished.");
							!start_auction.

+!start_auction: auction(A) <- writeNotice("The auction has been started.");
								announceParticipants(A);
								writeNoticeRound;
								.print("is waiting for bids");
								.wait(2000);
								!end_round.
													
+!receive_reply: round_replies(RR) <- -round_replies(RR); +round_replies(RR+1).

+!end_round: auction(A) <- writeNoticeRoundEnd;
							countRoundResults(A);
							createNewListInRoundBidsList;							
							!launch_next_round.

																					
+!launch_next_round: number_of_requests(NR) & current_round(CR) & CR < NR <- writeNoticeRound;
																					.print("is waiting for bids");
																					.wait(2000);
																					!end_round.
													
+!launch_next_round: number_of_requests(NR) & current_round(CR) & CR == NR <- declareResults;
																				writeNoticeAuctionEnd.

+last_notice("Auction has been ended.") <- !launch_next_auction.

+!launch_next_auction: auction(A) & number_of_requests(NR) & round_replies(RR) & number_of_auctions(NA)
 		& number_of_bus_participants(NBP) <- -auction(A);
									 	-number_of_requests(NR);
									 	-round_replies(RR);
									 	-number_of_bus_participants(NBP);
										+number_of_requests(0);
										+number_of_bus_participants(0);
										+round_replies(0);
										-number_of_auctions(NA);
										+number_of_auctions(NA+1);
										.wait(4000);
										fixateLastResult;
										clearResults;
										clearProperties;
										!start_waiting.
						

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$moiseJar/asl/org-obedient.asl") }

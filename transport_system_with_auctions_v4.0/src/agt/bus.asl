// Agent bus in project transport_system_with_auctions

/* Initial beliefs and rules */

willingness(true).
number_of_passengers(0).
application_status("not submitted").
trust_score_from_passenger(0.9).
number_of_received_scores(1).
average_of_received_scores(0.9).

/* Initial goals */

!start_waiting.

/* Plans */

+!start_waiting: point(P) & .my_name(N)  <- .wait(200);
								createBus(N,P,B);
								+my_object(B);
								.print("is waiting for the start of an applications collection").

+last_notice("The collection of applications has been started."): 
							.my_name(N) & willingness(W) & W == true & number_of_passengers(NP) & capacity(C) & NP < C
																					<- .wait(math.random(1000));
																						.send(auctioneer,achieve,add_bus(N));
																						.print("has submitted an application").

+application_status("accepted") <- .print("participates in the auction").

+current_round(CR): point(P) & weight_a(WA) & weight_b(WB) & weight_g(WG) & CR == 1
					 & .my_name(N) & current_auction(CA) & application_status(AS)
					 & AS = "accepted" <- 
					 				.wait(math.random(1000));
					 				makeBids(P,WA,WB,WG,N,CA,BB);
					 				+bus_bids(BB);
					 				!reply.
					 				
+current_round(CR): point(P) & weight_a(WA) & weight_b(WB) & weight_g(WG) & CR > 1
					 & .my_name(N) & current_auction(CA) & application_status(AS)
					 & AS = "accepted" & bus_bids(BB) & capacity(C) & number_of_passengers(NP) <- 
					 				.wait(math.random(1000));
					 				findBestBidsCombination(P,WA,WB,WG,N,CA,C,NP);
					 				!reply.

+!reply <- .send(auctioneer,achieve,receive_reply).//;.print("has made bids").

+bus_bids(BB) <- fixateNewBids(BB).

+last_notice("Auction has been ended."): my_object(B) & current_auction(CA) & number_of_passengers(NP)
																 <- fixateStops(B,CA,NNP);
																 -number_of_passengers(NP);
																 +number_of_passengers(NNP);
																 !move.

+!move: point(P) & my_object(B) & number_of_passengers(NOP) & NOP > 0
									<- .wait(10000);
									moveToNextStop(B,NP,NNOP);
									-point(P);
									+point(NP);
									-number_of_passengers(NOP);
									+number_of_passengers(NNOP);
									.print(" has moved from ", P, " to ", NP).

+!move: point(P) & my_object(B) & number_of_passengers(NOP) & NOP <= 0
									<- .wait(0).

+!compute_trust(CT): trust_score_from_passenger(TSFP) & number_of_received_scores(NORC) <- .wait(5000);
                                                                                           -number_of_received_scores(NORC);
                                                                                           +number_of_received_scores(NORC + 1);
                                                                                           -trust_score_from_passenger(TSFP);
                                                                                           +trust_score_from_passenger(TSFP + CT);
                                                                                        +average_of_received_scores((TSFP + CT)/(NORC + 1));
                                                                        .print("Average of received trust scores=", (TSFP + CT)/(NORC + 1)). 

+last_notice("Working day has been ended.") : average_of_received_scores(AORS) <- .print("Average of received trust scores=", AORS).


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
//{ include("$moiseJar/asl/org-obedient.asl") }

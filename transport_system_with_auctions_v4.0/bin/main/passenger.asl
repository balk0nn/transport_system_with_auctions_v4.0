// Agent passenger in project transport_system_with_auctions

/* Initial beliefs and rules */

request_status("not sent").
assigned(false).

/* Initial goals */

!start_waiting.

/* Plans */

+!start_waiting <- .wait(300);
					.print("is waiting for the start of an requests collection").

+last_notice("The collection of requests has been started."): 
			.my_name(N) & price(P) & start_point(SP) & end_point(EP) & start_time(ST)
			& assigned(A) & A == false
			 			 <- .wait(math.random(1000000));
			 			 	.send(auctioneer,achieve,add_passenger(N,P,SP,EP,ST)).//;.print("has made a request").
			  			 	
+last_notice("The collection of requests has been started."): 
			.my_name(N) & price(P) & start_point(SP) & end_point(EP) & start_time(ST)
			& assigned(A) & A == true <- .wait(0).

+request_status("accepted") <- .print("participates in the auction"); 
								-assigned(false); +assigned(true).

+request_status("denied") <- .wait(0).//.print("waits for the next auction").				   					 
					   					 
//+last_notice("Auction has been ended."): assigned(A) & A == true <- .print("has been assigned").

+last_notice("Auction has been ended."): assigned(A) & A == false <- .wait(0).//!start_waiting.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
//{ include("$moiseJar/asl/org-obedient.asl") }

// Agent passenger in project transport_system_with_auctions

/* Initial beliefs and rules */

request_status("not sent").
assigned(false).
delivered(false).
weight_1(0.03).
weight_2(0.03).
weight_3(0.03).
weight_4(0.03).
weight_5(0.03).
weight_6(0.03).
weight_7(0.41).
weight_8(0.41).

threshold_trust(0.8).

bus1_trust_direct(0.9).
bus1_trust_indirect(0.9).
bus1_trust_third_party(0).
bus2_trust_direct(0.9).
bus2_trust_indirect(0.9).
bus2_trust_third_party(0).
bus3_trust_direct(0.9).
bus3_trust_indirect(0.9).
bus3_trust_third_party(0).
bus4_trust_direct(0.9).
bus4_trust_indirect(0.9).
bus4_trust_third_party(0).

/* Initial goals */
!to_know_data.

/* Plans */

+!to_know_data <-       
                        .send(bus1, askOne, benevolence(X)); 
			.send(bus1, askOne, safety(X));
			.send(bus1, askOne, comfort(X));
			.send(bus1, askOne, punctuality(X));
			.send(bus1, askOne, time_accuracy(X));
			.send(bus1, askOne, cleanliness(X));
			.send(bus2, askOne, benevolence(X)); 
			.send(bus2, askOne, safety(X));
			.send(bus2, askOne, comfort(X));
			.send(bus2, askOne, punctuality(X));
			.send(bus2, askOne, time_accuracy(X));
			.send(bus2, askOne, cleanliness(X));
			.send(bus3, askOne, benevolence(X)); 
			.send(bus3, askOne, safety(X));
			.send(bus3, askOne, comfort(X));
			.send(bus3, askOne, punctuality(X));
			.send(bus3, askOne, time_accuracy(X));
			.send(bus3, askOne, cleanliness(X));
			.send(bus4, askOne, benevolence(X)); 
			.send(bus4, askOne, safety(X));
			.send(bus4, askOne, comfort(X));
			.send(bus4, askOne, punctuality(X));
			.send(bus4, askOne, time_accuracy(X));
			.send(bus4, askOne, cleanliness(X));  
			.wait(math.random(12000));
			!to_compute_trust_third_party.
                   
+!to_compute_trust_third_party: weight_1(W1) & weight_2(W2) & weight_3(W3) & weight_4(W4) & weight_5(W5) & weight_6(W6) 
	& benevolence(B11)[source(bus1)] & benevolence(B12)[source(bus2)] & benevolence(B13)[source(bus3)] & benevolence(B14)[source(bus4)]
	& safety(B21)[source(bus1)] & safety(B22)[source(bus2)] & safety(B23)[source(bus3)] & safety(B24)[source(bus4)]
	& comfort(B31)[source(bus1)] & comfort(B32)[source(bus2)] & comfort(B33)[source(bus3)] & comfort(B34)[source(bus4)]
	& punctuality(B41)[source(bus1)] & punctuality(B42)[source(bus2)] & punctuality(B43)[source(bus3)] & punctuality(B44)[source(bus4)]
	& time_accuracy(B51)[source(bus1)] & time_accuracy(B52)[source(bus2)] & time_accuracy(B53)[source(bus3)] & time_accuracy(B54)[source(bus4)]
	& cleanliness(B61)[source(bus1)] & cleanliness(B62)[source(bus2)] & cleanliness(B63)[source(bus3)] & cleanliness(B64)[source(bus4)]
	<- 	.print("Computating trust scores based on information from third party:");
		TTPB1 = W1 * B11 + W2 * B21 + W3 * B31 + W4 * B41 + W5 * B51 + W6 * B61; 
		.print("Trust score (information from third party) for bus1 is ", TTPB1); +bus1_trust_third_party(TTPB1);
	  	TTPB2 = W1 * B12 + W2 * B22 + W3 * B32 + W4 * B42 + W5 * B52 + W6 * B62; 
		.print("Trust score (information from third party) for bus2 is ", TTPB2); +bus2_trust_third_party(TTPB2);
	   	TTPB3 = W1 * B13 + W2 * B23 + W3 * B33 + W4 * B43 + W5 * B53 + W6 * B63; 
		.print("Trust score (information from third party) for bus3 is ", TTPB3); +bus3_trust_third_party(TTPB3);
	   	TTPB4 = W1 * B14 + W2 * B24 + W3 * B34 + W4 * B44 + W5 * B54 + W6 * B64; 
		.print("Trust score (information from third party) for bus4 is ", TTPB4); +bus4_trust_third_party(TTPB4);
		!to_compute_trust_initial.
	
+!to_compute_trust_initial: bus1_trust_third_party(TTPB1) & bus2_trust_third_party(TTPB2) & bus3_trust_third_party(TTPB3) 
	& bus4_trust_third_party(TTPB4) & weight_7(W7) & weight_8(W8) & bus1_trust_direct(TDB1) & bus2_trust_direct(TDB2) 
	& bus3_trust_direct(TDB3) & bus4_trust_direct(TDB4) & bus1_trust_indirect(TIB1) & bus2_trust_indirect(TIB2) 
	& bus3_trust_indirect(TIB3) & bus4_trust_indirect(TIB4)
	<-      .print("Computating total trust scores:");
		TOTALTB1 = TTPB1 + W7 * TIB1 + W8 * TDB1; +bus1_total_trust(TOTALTB1);
		.print("Total trust score for bus1 is ", TOTALTB1);
		TOTALTB2 = TTPB2 + W7 * TIB2 + W8 * TDB2; +bus2_total_trust(TOTALTB2);
		.print("Total trust score for bus2 is ", TOTALTB2);
		TOTALTB3 = TTPB3 + W7 * TIB3 + W8 * TDB3; +bus3_total_trust(TOTALTB3);
		.print("Total trust score for bus3 is ", TOTALTB3);
		TOTALTB4 = TTPB4 + W7 * TIB4 + W8 * TDB4; +bus4_total_trust(TOTALTB4);
		.print("Total trust score for bus4 is ", TOTALTB4).

!start_waiting.

+!start_waiting <- .wait(100);
					.print("is waiting for the start of an requests collection").

+last_notice("The collection of requests has been started."): 
			number(I) & .my_name(N) & price(P) & start_point(SP) & end_point(EP) & start_time(ST)
			& assigned(A) & A == false
			 			 <- .wait(I * 100);
			 			 	.send(auctioneer,achieve,add_passenger(N,P,SP,EP,ST)). //;.print("has made a request").
			  			 	
+last_notice("The collection of requests has been started."): 
			.my_name(N) & price(P) & start_point(SP) & end_point(EP) & start_time(ST)
			& assigned(A) & A == true <- .wait(0).

+request_status("accepted") <- .print("participates in the auction"); 
								-assigned(false); +assigned(true).

+request_status("denied") <- .wait(0).//.print("waits for the next auction").				   					 
					   					 
+last_notice("Auction has been ended."): assigned(A) & A == true & delivered(F) & F == false <- !to_know_new_trust_data; !check_trust_bus. 

+last_notice("Auction has been ended."): assigned(A) & A == false <- !to_know_new_trust_data; .wait(0).//!start_waiting.



+!check_trust_bus : assigned(A) & A == true & delivered(F) & F == false <- L = math.random(10);
					if (L < 2.5) {!check_trust_bus1};
					if (L >= 2.5 & L < 5) {!check_trust_bus2};
					if (L >= 5 & L < 7.5) {!check_trust_bus3};
					if (L >= 7.5 & L < 10) {!check_trust_bus4}.   



+!check_trust_bus1: price(P) & threshold_trust(TT) & bus1_total_trust(TOTALTB1) & delivered(F) & F == false 
				<- if (TOTALTB1 >= TT) {.print("has been confirmed trip"); !get_ride_bus1};
				   if (TOTALTB1 < TT) {.print("has not been confirmed trip"); 
				   -delivered(false); +delivered(true); 
				   .wait(math.random(4000)); .send(auctioneer,achieve,add_penalty(P))}.

+!check_trust_bus2: price(P) & threshold_trust(TT) & bus2_total_trust(TOTALTB2) & delivered(F) & F == false 
				<- if (TOTALTB2 >= TT) {.print("has been confirmed trip"); !get_ride_bus2};
				   if (TOTALTB2 < TT) {.print("has not been confirmed trip");  
				   -delivered(false); +delivered(true);
				   .wait(math.random(4000)); .send(auctioneer,achieve,add_penalty(P))}.

+!check_trust_bus3: price(P) & threshold_trust(TT) & bus3_total_trust(TOTALTB3) & delivered(F) & F == false 
				<- if (TOTALTB3 >= TT) {.print("has been confirmed trip"); !get_ride_bus3};
				   if (TOTALTB3 < TT) {.print("has not been confirmed trip");  
				   -delivered(false); +delivered(true);
				   .wait(math.random(4000)); .send(auctioneer,achieve,add_penalty(P))}.

+!check_trust_bus4: price(P) & threshold_trust(TT) & bus4_total_trust(TOTALTB4) & delivered(F) & F == false 
				<- if (TOTALTB4 >= TT) {.print("has been confirmed trip"); !get_ride_bus4};
				   if (TOTALTB4 < TT) {.print("has not been confirmed trip");  
				   -delivered(false); +delivered(true);
				   .wait(math.random(4000)); .send(auctioneer,achieve,add_penalty(P))}.
				   
				   
+!get_ride_bus1 : bus1_trust_direct(TDB1) <- Q = math.random(100);
		     .print("Trip has been started");
		     if (Q < 60) 
		{.print("Nothing happened in the trip"); .wait(math.random(4000)); 
		                                         .send(auctioneer,achieve,add_satisfaction(4))};
		     if (Q >= 60 & Q < 64) 
		{.print("Event rout_change happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(30));
		                                             -bus1_trust_direct(TDB1);
		                                             +bus1_trust_direct(TDB1 - 0.03)};
		     if (Q >= 64 & Q < 67) 
		{.print("Event fuel happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(50));
		                                             -bus1_trust_direct(TDB1);
		                                             +bus1_trust_direct(TDB1 - 0.05)};
		     if (Q >= 67 & Q < 72) 
		{.print("Event late happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(30));
		                                             -bus1_trust_direct(TDB1);
		                                             +bus1_trust_direct(TDB1 - 0.03)};
		     if (Q >= 72 & Q < 75) 
		{.print("Event stop happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(80));
		                                             -bus1_trust_direct(TDB1);
		                                             +bus1_trust_direct(TDB1 - 0.02)};
		     if (Q >= 75 & Q < 77) 
		{.print("Event rude happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(100));
		                                             -bus1_trust_direct(TDB1);
		                                             +bus1_trust_direct(TDB1 - 0.02)};
		     if (Q >= 77 & Q < 78) 
		{.print("Event price_change happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(150));
		                                             -bus1_trust_direct(TDB1);
		                                             +bus1_trust_direct(TDB1 - 0.1)};
		     if (Q >= 78 & Q < 79) 
		{.print("Event danger happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(250));
		                                             -bus1_trust_direct(TDB1);
		                                             +bus1_trust_direct(TDB1 - 0.1)};
		     if (Q >= 79 & Q < 86) 
		{.print("Event discomfort happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(40));
		                                             -bus1_trust_direct(TDB1);
		                                             +bus1_trust_direct(TDB1 - 0.02)};
		     if (Q >= 86 & Q < 90) 
		{.print("Event not_clean happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(60));
		                                             -bus1_trust_direct(TDB1);
		                                             +bus1_trust_direct(TDB1 - 0.02)};
		     if (Q >= 90 & Q < 100) 
		{.print("Event tips happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(5));
		                                             .send(auctioneer,achieve,add_penalty(-100));
		                                             -bus1_trust_direct(TDB1);
		                                             +bus1_trust_direct(TDB1 + 0.1)};
		 -delivered(false); +delivered(true);
		 !send_direct_trust_to_bus1.

+!get_ride_bus2 : bus2_trust_direct(TDB2) <- Q = math.random(100);
		     .print("Trip has been started");
		     if (Q < 60) 
		{.print("Nothing happened in the trip"); .wait(math.random(4000)); 
		                                         .send(auctioneer,achieve,add_satisfaction(4))};
		     if (Q >= 60 & Q < 64) 
		{.print("Event rout_change happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(30));
		                                             -bus2_trust_direct(TDB2);
		                                             +bus2_trust_direct(TDB2 - 0.03)};
		     if (Q >= 64 & Q < 67) 
		{.print("Event fuel happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(50));
		                                             -bus2_trust_direct(TDB2);
		                                             +bus2_trust_direct(TDB2 - 0.05)};
		     if (Q >= 67 & Q < 72) 
		{.print("Event late happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(30));
		                                             -bus2_trust_direct(TDB2);
		                                             +bus2_trust_direct(TDB2 - 0.03)};
		     if (Q >= 72 & Q < 75) 
		{.print("Event stop happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus2_trust_direct(TDB2);
		                                             +bus2_trust_direct(TDB2 - 0.02)};
		     if (Q >= 75 & Q < 77) 
		{.print("Event rude happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus2_trust_direct(TDB2);
		                                             +bus2_trust_direct(TDB2 - 0.02)};
		     if (Q >= 77 & Q < 78) 
		{.print("Event price_change happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(50));
		                                             -bus2_trust_direct(TDB2);
		                                             +bus2_trust_direct(TDB2 - 0.05)};
		     if (Q >= 78 & Q < 79) 
		{.print("Event danger happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(90));
		                                             -bus2_trust_direct(TDB2);
		                                             +bus2_trust_direct(TDB2 - 0.1)};
		     if (Q >= 79 & Q < 86) 
		{.print("Event discomfort happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus2_trust_direct(TDB2);
		                                             +bus2_trust_direct(TDB2 - 0.02)};
		     if (Q >= 86 & Q < 90) 
		{.print("Event not_clean happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus2_trust_direct(TDB2);
		                                             +bus2_trust_direct(TDB2 - 0.02)};
		     if (Q >= 90 & Q < 100) 
		{.print("Event tips happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(5));
		                                             .send(auctioneer,achieve,add_penalty(-50));
		                                             -bus2_trust_direct(TDB2);
		                                             +bus2_trust_direct(TDB2 + 0.1)};
		 -delivered(false); +delivered(true);
		 !send_direct_trust_to_bus2.

+!get_ride_bus3 : bus3_trust_direct(TDB3) <- Q = math.random(100);
		     .print("Trip has been started");
		     if (Q < 60) 
		{.print("Nothing happened in the trip"); .wait(math.random(4000)); 
		                                         .send(auctioneer,achieve,add_satisfaction(4))};
		     if (Q >= 60 & Q < 64) 
		{.print("Event rout_change happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(30));
		                                             -bus3_trust_direct(TDB3);
		                                             +bus3_trust_direct(TDB3 - 0.03)};
		     if (Q >= 64 & Q < 67) 
		{.print("Event fuel happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(50));
		                                             -bus3_trust_direct(TDB3);
		                                             +bus3_trust_direct(TDB3 - 0.05)};
		     if (Q >= 67 & Q < 72) 
		{.print("Event late happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(30));
		                                             -bus3_trust_direct(TDB3);
		                                             +bus3_trust_direct(TDB3 - 0.03)};
		     if (Q >= 72 & Q < 75) 
		{.print("Event stop happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus3_trust_direct(TDB3);
		                                             +bus3_trust_direct(TDB3 - 0.02)};
		     if (Q >= 75 & Q < 77) 
		{.print("Event rude happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus3_trust_direct(TDB3);
		                                             +bus3_trust_direct(TDB3 - 0.02)};
		     if (Q >= 77 & Q < 78) 
		{.print("Event price_change happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(50));
		                                             -bus3_trust_direct(TDB3);
		                                             +bus3_trust_direct(TDB3 - 0.05)};
		     if (Q >= 78 & Q < 79) 
		{.print("Event danger happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(90));
		                                             -bus3_trust_direct(TDB3);
		                                             +bus3_trust_direct(TDB3 - 0.1)};
		     if (Q >= 79 & Q < 86) 
		{.print("Event discomfort happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus3_trust_direct(TDB3);
		                                             +bus3_trust_direct(TDB3 - 0.02)};
		     if (Q >= 86 & Q < 90) 
		{.print("Event not_clean happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus3_trust_direct(TDB3);
		                                             +bus3_trust_direct(TDB3 - 0.02)};
		     if (Q >= 90 & Q < 100) 
		{.print("Event tips happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(5));
		                                             .send(auctioneer,achieve,add_penalty(-50));
		                                             -bus3_trust_direct(TDB3);
		                                             +bus3_trust_direct(TDB3 + 0.1)};
		 -delivered(false); +delivered(true);

		 !send_direct_trust_to_bus3.

+!get_ride_bus4 : bus4_trust_direct(TDB4) <- Q = math.random(100);
		     .print("Trip has been started");
		     if (Q < 60) 
		{.print("Nothing happened in the trip"); .wait(math.random(4000)); 
		                                         .send(auctioneer,achieve,add_satisfaction(4))};
		     if (Q >= 60 & Q < 64) 
		{.print("Event rout_change happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(30));
		                                             -bus4_trust_direct(TDB4);
		                                             +bus4_trust_direct(TDB4 - 0.03)};
		     if (Q >= 64 & Q < 67) 
		{.print("Event fuel happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(50));
		                                             -bus4_trust_direct(TDB4);
		                                             +bus4_trust_direct(TDB4 - 0.05)};
		     if (Q >= 67 & Q < 72) 
		{.print("Event late happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(30));
		                                             -bus4_trust_direct(TDB4);
		                                             +bus4_trust_direct(TDB4 - 0.03)};
		     if (Q >= 72 & Q < 75) 
		{.print("Event stop happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus4_trust_direct(TDB4);
		                                             +bus4_trust_direct(TDB4 - 0.02)};
		     if (Q >= 75 & Q < 77) 
		{.print("Event rude happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus4_trust_direct(TDB4);
		                                             +bus4_trust_direct(TDB4 - 0.02)};
		     if (Q >= 77 & Q < 78) 
		{.print("Event price_change happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(50));
		                                             -bus4_trust_direct(TDB4);
		                                             +bus4_trust_direct(TDB4 - 0.05)};
		     if (Q >= 78 & Q < 79) 
		{.print("Event danger happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(2));
		                                             .send(auctioneer,achieve,add_penalty(90));
		                                             -bus4_trust_direct(TDB4);
		                                             +bus4_trust_direct(TDB4 - 0.1)};
		     if (Q >= 79 & Q < 86) 
		{.print("Event discomfort happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus4_trust_direct(TDB4);
		                                             +bus4_trust_direct(TDB4 - 0.02)};
		     if (Q >= 86 & Q < 90) 
		{.print("Event not_clean happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(3));
		                                             .send(auctioneer,achieve,add_penalty(20));
		                                             -bus4_trust_direct(TDB4);
		                                             +bus4_trust_direct(TDB4 - 0.02)};
		     if (Q >= 90 & Q < 100) 
		{.print("Event tips happened in the trip"); .wait(math.random(4000)); 
		                                             .send(auctioneer,achieve,add_satisfaction(5));
		                                             .send(auctioneer,achieve,add_penalty(-50));
		                                             -bus4_trust_direct(TDB4);
		                                             +bus4_trust_direct(TDB4 + 0.1)};
		 -delivered(false); +delivered(true);
		 !send_direct_trust_to_bus4.



+!send_direct_trust_to_bus1 : bus1_trust_direct(TDB1) <- .wait(math.random(4000)); .send(bus1,achieve,compute_trust(TDB1)).    
+!send_direct_trust_to_bus2 : bus2_trust_direct(TDB2) <- .wait(math.random(4000)); .send(bus2,achieve,compute_trust(TDB2)). 
+!send_direct_trust_to_bus3 : bus3_trust_direct(TDB3) <- .wait(math.random(4000)); .send(bus3,achieve,compute_trust(TDB3)). 
+!send_direct_trust_to_bus4 : bus4_trust_direct(TDB4) <- .wait(math.random(4000)); .send(bus4,achieve,compute_trust(TDB4)).

+!to_know_new_trust_data <- .send(bus1, askOne, average_of_received_scores(X));
			    .send(bus2, askOne, average_of_received_scores(X));
			    .send(bus3, askOne, average_of_received_scores(X));
			    .send(bus4, askOne, average_of_received_scores(X))
                            .wait(math.random(2000));
			    !to_compute_trust_update. 

+!to_compute_trust_update: bus1_trust_third_party(TTPB1) & bus2_trust_third_party(TTPB2) & bus3_trust_third_party(TTPB3) 
	& bus4_trust_third_party(TTPB4) 
	& weight_7(W7) & weight_8(W8) 
	& bus1_trust_direct(TDB1) & bus2_trust_direct(TDB2) & bus3_trust_direct(TDB3) & bus4_trust_direct(TDB4) 
	& average_of_received_scores(TIB1)[source(bus1)] & average_of_received_scores(TIB2)[source(bus2)]	& average_of_received_scores(TIB3)[source(bus3)] & average_of_received_scores(TIB4)[source(bus4)]
	<-      .print("Computating update total trust scores:");
		TOTALTB1 = TTPB1 + W7 * TIB1 + W8 * TDB1; +bus1_total_trust(TOTALTB1);
		.print("Updated total trust score for bus1 is ", TOTALTB1);
		TOTALTB2 = TTPB2 + W7 * TIB2 + W8 * TDB2; +bus2_total_trust(TOTALTB2);
		.print("Updated total trust score for bus2 is ", TOTALTB2);
		TOTALTB3 = TTPB3 + W7 * TIB3 + W8 * TDB3; +bus3_total_trust(TOTALTB3);
		.print("Updated total trust score for bus3 is ", TOTALTB3);
		TOTALTB4 = TTPB4 + W7 * TIB4 + W8 * TDB4; +bus4_total_trust(TOTALTB4);
		.print("Updated total trust score for bus4 is ", TOTALTB4).

	                                             

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
//{ include("$moiseJar/asl/org-obedient.asl") }

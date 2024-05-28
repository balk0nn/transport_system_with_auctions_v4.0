package models;

import java.util.ArrayList;
import java.util.List;

public class Auction {
	
	private List<Passenger> passengersList = new ArrayList<>();
	private List<String> busesList = new ArrayList<>();
	
    public Auction() {
    }

    public List<Passenger> getPassengersList() {
        return passengersList;
    }

    public void setPassengersList(List<Passenger> passengersList) {
        this.passengersList = passengersList;
    }

    public List<String> getBusesList() {
        return busesList;
    }

    public void setBusesList(List<String> busesList) {
        this.busesList = busesList;
    }

}

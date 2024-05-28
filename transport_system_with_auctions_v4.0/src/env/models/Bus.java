package models;

import java.util.ArrayList;
import java.util.List;

public class Bus {
	
    private String name;	
	private String currentPoint;
	private List<String> nextStops;
	private int numberOfCompletedRides;
	
    public Bus(String name, String currentPoint) {
    	this.currentPoint = currentPoint;
        this.name = name;
        this.nextStops = new ArrayList<>();
        this.numberOfCompletedRides = 0;
    }
    
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCurrentPoint() {
        return currentPoint;
    }

    public void setCurrentPoint(String currentPoint) {
        this.currentPoint = currentPoint;
    }

    public List<String> getNextStops() {
        return nextStops;
    }

    public void setNextStops(List<String> nextStops) {
        this.nextStops = nextStops;
    }
    
    public int getNumberOfCompletedRides() {
        return numberOfCompletedRides;
    }

    public void setNumberOfCompletedRides(int numberOfCompletedRides) {
        this.numberOfCompletedRides = numberOfCompletedRides;
    }

}

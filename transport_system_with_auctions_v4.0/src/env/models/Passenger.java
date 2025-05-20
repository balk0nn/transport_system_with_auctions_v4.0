package models;

public class Passenger {
	
    private String name;	
	private double price;
	private String startPoint;
	private String endPoint;
	private String startTime;
	
    public Passenger(String name, double price, String startPoint, String endPoint, String startTime) {
    	this.name = name;
        this.price = price;
        this.startPoint = startPoint;
        this.endPoint = endPoint;
        this.startTime = startTime;
    }
    
    public String getName() {
    	return name;
    }

    public double getPrice() {
        return price;
    }

    public String getStartPoint() {
        return startPoint;
    }

    public String getEndPoint() {
        return endPoint;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setStartPoint(String startPoint) {
        this.startPoint = startPoint;
    }

    public void setEndPoint(String endPoint) {
        this.endPoint = endPoint;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }
    
    @Override
    public String toString() {
    	return "Passenger: " + name + ", Price of trip = " + price 
    				+ ", Start point = " + startPoint 
    				+ ", End point = " + endPoint;
    }
    
}

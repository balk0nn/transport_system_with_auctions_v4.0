package models;


public class Bid {

	private int id;
	private String passengerName;
	private String busName;
	private double busBid;
	
	public Bid(int id, String passengerName, String busName, double busBid) {
        this.id = id;
        this.passengerName = passengerName;
        this.busName = busName;
        this.busBid = busBid;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPassengerName() {
        return passengerName;
    }

    public void setPassengerName(String passengerName) {
        this.passengerName = passengerName;
    }

    public String getBusName() {
        return busName;
    }

    public void setBusName(String busName) {
        this.busName = busName;
    }

    public double getBusBid() {
        return busBid;
    }

    public void setBusBid(double busBid) {
        this.busBid = busBid;
    }
    
    @Override
    public String toString() {
    	return "Bid: " + busBid + " \n(" + passengerName + "; "+ busName + ")";
    }
	
}

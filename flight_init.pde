class Flight{
  int flightDate;
  String carrierCode;
  int flightNumber;
  String origin;
  String originCity;
  String originState;
  int originWAC;
  String destination;
  String destCityName;
  String destState;
  int destWAC;
  int scheduleDepTime;
  int actualDepTime;
  int scheduleArrTime;
  int actualArrTime;
  boolean cancelled;
  boolean diverted;
  int distance;
   
  Flight(int flightDate, String carrierCode, int flightNumber,
    String origin, String originCity, String originState, int originWAC,
    String destination, String destCityName, String destState, int destWAC,
    int scheduleDepTime, int actualDepTime, int scheduleArrTime, int actualArrTime,
    boolean cancelled, boolean diverted, int distance){
    
    this.flightDate = flightDate;
    this.carrierCode = carrierCode;
    this.flightNumber = flightNumber;
    this.origin = origin;
    this.originCity = originCity;
    this.originState = originState;
    this.originWAC = originWAC;
    this.destination = destination;
    this.destCityName = destCityName;
    this.destState = destState;
    this.destWAC = destWAC;
    this.scheduleDepTime = scheduleDepTime;
    this.actualDepTime = actualDepTime;
    this.scheduleArrTime = scheduleArrTime;
    this.actualArrTime = actualArrTime;
    this.cancelled = cancelled;
    this.diverted = diverted;
    this.distance = distance;      
  }
}

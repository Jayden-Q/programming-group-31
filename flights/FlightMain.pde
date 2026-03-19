Table table;
ArrayList<Flight> flights = new ArrayList<Flight>();

PFont widgetFont;
float scrollY = 0;
float targetScroll = 0;
float lineHeight = 20;
float scrollSpeed = 20;
boolean upPressed = false;
boolean downPressed = false;

class Flight {
  int FL_DATE;
  String MKT_CARRIER;
  int MKT_CARRIER_FL_NUM;
  String ORIGIN;
  String ORIGIN_CITY_NAME;
  String ORIGIN_STATE_ABR;
  int ORIGIN_WAC;
  String DEST;
  String DEST_CITY_NAME;
  String DEST_STATE_ABR;
  int DEST_WAC;
  int CRS_DEP_TIME;
  int DEP_TIME;
  int CRS_ARR_TIME;
  int ARR_TIME;
  boolean CANCELLED;
  boolean DIVERTED;
  int DISTANCE;
   
  Flight(int FL_DATE, String MKT_CARRIER, int MKT_CARRIER_FL_NUM,
    String ORIGIN, String ORIGIN_CITY_NAME, String ORIGIN_STATE_ABR, int ORIGIN_WAC,
    String DEST, String DEST_CITY_NAME, String DEST_STATE_ABR, int DEST_WAC,
    int CRS_DEP_TIME, int DEP_TIME, int CRS_ARR_TIME, int ARR_TIME,
    boolean CANCELLED, boolean DIVERTED, int DISTANCE) {
    
    this.FL_DATE = FL_DATE;
    this.MKT_CARRIER = MKT_CARRIER;
    this.MKT_CARRIER_FL_NUM = MKT_CARRIER_FL_NUM;
    this.ORIGIN = ORIGIN;
    this.ORIGIN_CITY_NAME = ORIGIN_CITY_NAME;
    this.ORIGIN_STATE_ABR = ORIGIN_STATE_ABR;
    this.ORIGIN_WAC = ORIGIN_WAC;
    this.DEST = DEST;
    this.DEST_CITY_NAME = DEST_CITY_NAME;
    this.DEST_STATE_ABR = DEST_STATE_ABR;
    this.DEST_WAC = DEST_WAC;
    this.CRS_DEP_TIME = CRS_DEP_TIME;
    this.DEP_TIME = DEP_TIME;
    this.CRS_ARR_TIME = CRS_ARR_TIME;
    this.ARR_TIME = ARR_TIME;
    this.CANCELLED = CANCELLED;
    this.DIVERTED = DIVERTED;
    this.DISTANCE = DISTANCE;      
  }
}

void setup() {
  size(1200, 800);
  widgetFont = createFont("Arial", 14);
  textFont(widgetFont);
  
  // Load CSV file
  table = loadTable("flights2k.csv", "header");
  
  // Parse flights 
  for (TableRow row : table.rows()) {
    try {
      int fl_date = row.getInt("FL_DATE");
      String carrier = row.getString("MKT_CARRIER");
      int flight_num = row.getInt("MKT_CARRIER_FL_NUM");
      String origin = row.getString("ORIGIN");
      String origin_city = row.getString("ORIGIN_CITY_NAME");
      String origin_state = row.getString("ORIGIN_STATE_ABR");
      int origin_wac = row.getInt("ORIGIN_WAC");
      String dest = row.getString("DEST");
      String dest_city = row.getString("DEST_CITY_NAME");
      String dest_state = row.getString("DEST_STATE_ABR");
      int dest_wac = row.getInt("DEST_WAC");
      int crs_dep = row.getInt("CRS_DEP_TIME");
      int dep_time = row.getInt("DEP_TIME");
      int crs_arr = row.getInt("CRS_ARR_TIME");
      int arr_time = row.getInt("ARR_TIME");
      boolean cancelled = row.getInt("CANCELLED") == 1;
      boolean diverted = row.getInt("DIVERTED") == 1;
      int distance = row.getInt("DISTANCE");
      
      Flight f = new Flight(fl_date, carrier, flight_num, origin, origin_city, 
                           origin_state, origin_wac, dest, dest_city, dest_state, 
                           dest_wac, crs_dep, dep_time, crs_arr, arr_time, 
                           cancelled, diverted, distance);
      flights.add(f);
    } catch (Exception e) {
      println("Error parsing row: " + e.getMessage());
    }
  }
  
  println(flights.size() + " flights");
}

boolean showText = true;
void draw() {
  background(255);
  
  if (showChart) {
    drawChart();
  }
  
  if (upPressed) {
    targetScroll += scrollSpeed;  // Scroll up
  }
  
  if (downPressed) {
    targetScroll -= scrollSpeed;  // Scroll down
  }
  
  scrollY += (targetScroll - scrollY) * 0.2;
  
  float maxScroll = 50;
  float minScroll = -flights.size() * lineHeight + height - 50;
  scrollY = constrain(scrollY, minScroll, maxScroll);
  targetScroll = constrain(targetScroll, minScroll, maxScroll);
  
  if(showText){
  // Calculate visible range
  int startRow = max(0, floor((-scrollY) / lineHeight));
  int endRow = min(flights.size(), startRow + ceil(height / lineHeight) + 1);
  
  // Draw visible flights
  pushMatrix();
  translate(0, scrollY);
  
  for (int i = startRow; i < endRow; i++) {
    Flight f = flights.get(i);
    float y = 50 + i * lineHeight;
    
    //data
    fill(0); 
    text(f.ORIGIN_CITY_NAME + " → " + f.DEST_CITY_NAME + " (" + f.MKT_CARRIER + f.MKT_CARRIER_FL_NUM + ")", 50, y);
  }
  
  popMatrix();
  
  //info
  fill(0);
  text("Total flights: " + flights.size() + " | Showing rows " + (startRow + 1) + " to " + endRow + " of " + flights.size(), 50, 30);
  }
}

//Charts
boolean showChart = false;
int chartX = 100;
int chartY = 150;
int chartWidth = 600;
int chartHeight = 300;
String chartType = "flights";

void drawChart() {
  //chart title
  fill(0);
  textAlign(CENTER);
  if (chartType.equals("flights")) {
    text("Flights per Carrier", chartX + chartWidth/2, chartY - 10);
  } else if (chartType.equals("")) {
    text("", chartX + chartWidth/2, chartY - 10);
  }
  textAlign(LEFT);
  
  if (chartType.equals("flights")) {
    drawCarrierChart();
  } else if (chartType.equals("")) {
   
  }
}

// Draw flights per carrier chart
void drawCarrierChart() {
  //chart background
  fill(240);
  stroke(0);
  rect(chartX, chartY, chartWidth, chartHeight);
  // Count flights per carrier
  HashMap<String, Integer> carrierCounts = new HashMap<String, Integer>();
  
  for (Flight f : flights) {
    String carrier = f.MKT_CARRIER;
    if (carrierCounts.containsKey(carrier)) {
      carrierCounts.put(carrier, carrierCounts.get(carrier) + 1);
    } else {
      carrierCounts.put(carrier, 1);
    }
  }
  
  int numCarriers = carrierCounts.size();
  float barWidth = (chartWidth - 100) / numCarriers;
  
  int maxCount = 0;
  for (int count : carrierCounts.values()) {
    if (count > maxCount) {
      maxCount = count;
    }
  }
  
  int index = 0;
  for (String carrier : carrierCounts.keySet()) {
    int count = carrierCounts.get(carrier);
    float barHeight = map(count, 0, maxCount, 0, chartHeight - 50);
    float x = chartX + 50 + index * barWidth;
    float y = chartY + chartHeight - 30 - barHeight;
    
    fill(color(100 + index * 30 % 155, 150, 200));
    rect(x, y, barWidth - 5, barHeight);
    
    // Carrier label
    fill(0);
    textSize(12);
    text(carrier, x + barWidth/2 - 10, y - 10);
    
    // Count label
    text(count, x + barWidth/2 - 5, y - 25);
    
    index++;
  }
  
  // Axis labels
  fill(0);
  text("Carrier", chartX + chartWidth/2, chartY + chartHeight - 5);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      upPressed = true;
    } else if (keyCode == DOWN) {
      downPressed = true;
    }
  } else 
    if (key == 'c' || key == 'C') {
      showChart = !showChart;  
      showText = !showText;
    } else if (key == 'd' || key == 'D') {
      chartType = "";
      showChart = true;
     
    } else if (key == 'f' || key == 'F') {
      if(!showText){
      chartType = "flights";
      showChart = true;
      }
    }
  }

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      upPressed = false;
    } else if (keyCode == DOWN) {
      downPressed = false;
    }
  }
}

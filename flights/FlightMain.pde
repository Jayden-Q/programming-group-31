Table table;
ArrayList<Flight> flights = new ArrayList<Flight>();
float scrollY = 0;
float targetScroll = 0;
float lineHeight = 20;
float scrollSpeed = 20;
PFont widgetFont;
boolean upPressed = false;
boolean downPressed = false;

void setup() {
  size(800, 600);
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
  
  drawScrollbar();
  
  //info
  fill(0);
  text("Total flights: " + flights.size() + " | Showing rows " + (startRow + 1) + " to " + endRow + " of " + flights.size(), 50, 30);
}

boolean showChart = false;
int chartX = 100;
int chartY = 150;
int chartWidth = 600;
int chartHeight = 300;
String chartType = "distance";

void drawChart() {
  //chart background
  fill(240);
  stroke(0);
  rect(chartX, chartY, chartWidth, chartHeight);
  
  //chart title
  fill(0);
  textAlign(CENTER);
  if (chartType.equals("distance")) {
    text("Flight Distances (First 20 flights)", chartX + chartWidth/2, chartY - 10);
  } else if (chartType.equals("flights")) {
    text("Flights per Carrier", chartX + chartWidth/2, chartY - 10);
  }
  textAlign(LEFT);
  
  if (chartType.equals("distance")) {
    drawDistanceChart();
  } else if (chartType.equals("flights")) {
    drawCarrierChart();
  }
}

//Chart
void drawDistanceChart() {
  int numBars = min(19, flights.size());
  float barWidth = (chartWidth - 50) / numBars * 0.7;
   float gap = 10;
   
  int maxDistance = 0;
  for (int i = 0; i < numBars; i++) {
    Flight f = flights.get(i);
    if (f.DISTANCE > maxDistance) {
      maxDistance = f.DISTANCE;
    }
  }
  
  for (int i = 0; i < numBars; i++) {
    Flight f = flights.get(i);
    float barHeight = map(f.DISTANCE, 0, maxDistance, 0, chartHeight - 50);
    float x = chartX + 25 + i * (barWidth+gap);
    float y = chartY + chartHeight - 30 - barHeight;
    
    fill(100, 150, 255);
    rect(x, y, barWidth - 2, barHeight);
    
    //distance label
    fill(0);
    textSize(10);
    pushMatrix();
    translate(x + barWidth/2, y - 5);
    //rotate(radians(45));
    text(f.DISTANCE, 0, 0);
    popMatrix();
  }
  
  // Axis labels
  fill(0);
  textSize(12);
  text("Distance (miles)", chartX + chartWidth/2, chartY + chartHeight - 5);
}

// Draw flights per carrier chart
void drawCarrierChart() {
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
      println("Chart toggled: " + showChart);
    } else if (key == 'd' || key == 'D') {
      chartType = "distance";
      showChart = true;
      println("Showing distance chart");
    } else if (key == 'f' || key == 'F') {
      chartType = "flights";
      showChart = true;
      println("Showing flights per carrier chart");
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

void drawScrollbar() {
  float totalHeight = flights.size() * lineHeight;
  float visibleRatio = height / totalHeight;
  
  if (visibleRatio < 1) {
    float barHeight = height * visibleRatio;
    float barY = map(scrollY, -totalHeight + height, 50, 0, height - barHeight);
    
    fill(100, 100, 100, 150);
    rect(width - 20, barY, 10, barHeight);
  }
}

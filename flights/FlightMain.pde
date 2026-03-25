Table table;
ArrayList<Flight> flights = new ArrayList<Flight>();

PFont widgetFont;
float scrollY = 0;
float targetScroll = 0;
float lineHeight = 20;
float scrollSpeed = 20;
boolean upPressed = false;
boolean downPressed = false;

// Input objects
TextInput citySearch;

//Input 
class Input {
  String label;
  String defaultValue;
  Object value;
  float x, y;
  float w, h;
  boolean isActive = false;
  boolean isHovered = false;
  boolean isVisible = true;
  PFont inputFont;
  
  Input(String label, String defaultValue, float x, float y, float w, float h) {
    this.label = label;
    this.defaultValue = defaultValue;
    this.value = defaultValue;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.inputFont = createFont("Arial", 14);
  }
  
  Object getValue() {
    return this.value;
  }
  
  void setValue(Object newValue) {
    this.value = newValue;
    onChange();
  }
  
  void reset() {
    this.value = defaultValue;
    onChange();
  }
  
  void onChange() {
    // To be overridden 
  }
  
  void update() {
    this.isHovered = mouseX > this.x && mouseX < this.x + this.w &&
                    mouseY > this.y && mouseY < this.y + this.h;
  }
  
  void mousePressed() {
    this.isActive = this.isHovered;
  }
  
  void draw() {
    if (!this.isVisible) return;
    
    textFont(inputFont);
    
    // Draw label
    fill(0);
    textAlign(LEFT);
    text(this.label, this.x, this.y - 5);
    
    // Draw input background
    stroke(0);
    if (this.isActive) {
      fill(255, 255, 200);
    } else {
      fill(255);
    }
    rect(this.x, this.y, this.w, this.h);
    
    // Draw value text
    fill(0);
    textAlign(LEFT);
    if (this.value != null) {
      text(this.value.toString(), this.x + 5, this.y + this.h - 7);
    }
    
    textAlign(LEFT);
  }
  
  void keyPressed(char key) {
    // To be overridden 
  }
}

// TextInput 
class TextInput extends Input {
  TextInput(String label, String defaultValue, float x, float y, float w, float h) {
    super(label, defaultValue, x, y, w, h);
  }
  
  @Override
  void keyPressed(char key) {
    if (!isActive) return;
    
    if (key == BACKSPACE) {
      String current = (String)this.value;
      if (current.length() > 0) {
        this.value = current.substring(0, current.length() - 1);
        onChange();
      }
    } 
    else if (key == ENTER || key == RETURN) {
      isActive = false;
    }
    else if (key != CODED && key != BACKSPACE && key != ENTER && key != TAB) {
      this.value = (String)this.value + key;
      onChange();
    }
  }
  
  String getText() {
    return (String)this.value;
  }

  @Override
  void onChange() {
    // redraw when text changes
  }
}

// Flight class
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

// Setup
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
  
  // Create input field
  citySearch = new TextInput("Search City:", "", 50, 80, 250, 30);
  
  println(flights.size() + " flights");
}

boolean showText = true;
boolean showChart = false;
int chartX = 100;
int chartY = 150;
int chartWidth = 600;
int chartHeight = 300;
String chartType = "flights";

// Draw
void draw() {
  background(255);
  
  // Update and draw input field
  citySearch.update();
  citySearch.draw();
  
  // Draw charts
  if (showChart) {
    drawChart();
  }
  
  if (upPressed) {
    targetScroll += scrollSpeed;
  }
  
  if (downPressed) {
    targetScroll -= scrollSpeed;
  }
  
  scrollY += (targetScroll - scrollY) * 0.2;
  
  float maxScroll = 50;
  float minScroll = -flights.size() * lineHeight + height - 50;
  scrollY = constrain(scrollY, minScroll, maxScroll);
  targetScroll = constrain(targetScroll, minScroll, maxScroll);
  
  // Get filter value
  String searchCity = citySearch.getText();
  
  if(showText){
    // Filter flights based on search
    ArrayList<Flight> filteredFlights = new ArrayList<Flight>();
    for (Flight f : flights) {
      boolean matches = true;
      
      // City filter (searches both origin and destination)
      if (!searchCity.equals("")) {
        if (!f.ORIGIN_CITY_NAME.toLowerCase().contains(searchCity.toLowerCase()) &&
            !f.DEST_CITY_NAME.toLowerCase().contains(searchCity.toLowerCase())) {
          matches = false;
        }
      }
      
      if (matches) {
        filteredFlights.add(f);
      }
    }
    
    // Calculate visible range for filtered flights
    int startRow = max(0, floor((-scrollY) / lineHeight));
    int endRow = min(filteredFlights.size(), startRow + ceil(height / lineHeight) + 1);
    
    // Draw visible flights
    pushMatrix();
    translate(0, scrollY);
    
    for (int i = startRow; i < endRow; i++) {
      Flight f = filteredFlights.get(i);
      float y = 130 + i * lineHeight;
      
      // Alternate row colors for better readability
      if (i % 2 == 0) {
        fill(0);
      } else {
        fill(80);
      }
      
      text(f.ORIGIN_CITY_NAME + " → " + f.DEST_CITY_NAME + " (" + f.MKT_CARRIER + f.MKT_CARRIER_FL_NUM + ")", 50, y);
//Distance
      String distanceText = f.DISTANCE + " miles"; 
      text(distanceText, 350, y);
    }
    
    popMatrix();
    
    // Info
    fill(100);
    text("Total flights: " + flights.size() + " | Showing: " + filteredFlights.size() + 
         " matching | Rows " + startRow  + " to " + endRow, 50, 50);
  }
}

//Chart 
void drawChart() {
  //chart background
  fill(240);
  stroke(0);
  rect(chartX, chartY, chartWidth, chartHeight);
  
  //chart title
  fill(0);
  textAlign(CENTER);
  if (chartType.equals("flights")) {
    text("Flights per Carrier", chartX + chartWidth/2, chartY - 10);
  }
  textAlign(LEFT);
  
  if (chartType.equals("flights")) {
    drawCarrierChart();
  }
}

// Draw bar chart with filters (textInput)
void drawCarrierChart() {
  // Get filter value
  String searchCity = citySearch.getText();
  
  // Count flights per carrier with filters applied
  HashMap<String, Integer> carrierCounts = new HashMap<String, Integer>();
  
  for (Flight f : flights) {
    boolean matches = true;
    
    // City filter
    if (!searchCity.equals("")) {
      if (!f.ORIGIN_CITY_NAME.toLowerCase().contains(searchCity.toLowerCase()) &&
          !f.DEST_CITY_NAME.toLowerCase().contains(searchCity.toLowerCase())) {
        matches = false;
      }
    }
    
    if (matches) {
      String carrier = f.MKT_CARRIER;
      if (carrierCounts.containsKey(carrier)) {
        carrierCounts.put(carrier, carrierCounts.get(carrier) + 1);
      } else {
        carrierCounts.put(carrier, 1);
      }
    }
  }
  
  int numCarriers = carrierCounts.size();
  if (numCarriers == 0) {
    fill(0);
    text("No flights match the current filters", chartX + chartWidth/3, chartY + chartHeight/2);
    return;
  }
  
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
  // Handle input field
  citySearch.keyPressed(key);
  
  if (key == CODED) {
    if (keyCode == UP) {
      upPressed = true;
    } else if (keyCode == DOWN) {
      downPressed = true;
    }
  } else {
    if (key == 'c' || key == 'C') {
      showChart = !showChart;  
      showText = !showText;
    } else if (key == 'f' || key == 'F') {
      if(!showText){
        chartType = "flights";
        showChart = true;
      }
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

void mousePressed() {
  citySearch.mousePressed();
}

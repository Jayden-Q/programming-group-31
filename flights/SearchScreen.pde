class SearchScreen {
  float scrollY = 0;
  float targetScroll = 0;
  float lineHeight = 20;
  float scrollSpeed = 20;
  boolean upPressed = false;
  boolean downPressed = false;
  
  int chartX = 550;
  int chartY = 300;
  int chartWidth = 600;
  int chartHeight = 300;
  String chartType = "flights";

  
  TextInput citySearch;
  
  SearchScreen() {
    //26/03/2026 Xianren - added citySearch for text input
    // Create input field
    citySearch = new TextInput("Search City:", 50, 80, 250, 30);
    citySearch.setDefaultValue("");
  }
  
  void update() {}
  
  //12/03/2026 Abdul, scroll
  void draw() {
    // Update and draw input field
    citySearch.update();
    citySearch.draw();
    
    // Draw chart
    drawChart();
    
    if (upPressed) {
      targetScroll += scrollSpeed;
    }
    
    if (downPressed) {
      targetScroll -= scrollSpeed;
    }
    
    scrollY += (targetScroll - scrollY) * 0.2;
    
    float maxScroll = 50;
    float minScroll = -flightsData.flights.size() * lineHeight + height - 50;
    scrollY = constrain(scrollY, minScroll, maxScroll);
    targetScroll = constrain(targetScroll, minScroll, maxScroll);
    
    // Get filter value
    String searchCity = (String) citySearch.getValue();
    
    // Filter flights based on search
    ArrayList<Flight> filteredFlights = new ArrayList<Flight>();
    for (Flight f : flightsData.flights) {
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
    text("Total flights: " + flightsData.flights.size() + " | Showing: " + filteredFlights.size() + 
         " matching | Rows " + startRow  + " to " + endRow, 350, 100);
  }
  
  //19/03/2026: Xianren, outline and bar chart
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
    drawCarrierChart();
  }
  
  // Draw bar chart with filters (textInput)
  void drawCarrierChart() {
    // Get filter value
    String searchCity = (String) citySearch.getValue();
    
    // Count flights per carrier with filters applied
    HashMap<String, Integer> carrierCounts = new HashMap<String, Integer>();
    
    for (Flight f : flightsData.flights) {
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
}

class BarChartsScreen {
  HashMap<String, Integer> airportCounts = new HashMap<String, Integer>();
  
  BarChartsScreen() {
    this.countAirports();
  }
  
  void countAirports() {
    for (Flight row : flightsData.flights) {
      String origin = row.ORIGIN;
      String dest = row.DEST;
  
      addCount(origin);
      addCount(dest);
    }
  }
  
  void addCount(String airport) {
    if (airport == null || airport.equals("")) return;
  
    if (airportCounts.containsKey(airport)) {
      airportCounts.put(airport, airportCounts.get(airport) + 1);
    } else {
      airportCounts.put(airport, 1);
    }
  }
  
  void draw() {
    ArrayList<String> airports = new ArrayList<String>(airportCounts.keySet());
    airports.sort((a, b) -> airportCounts.get(b) - airportCounts.get(a));
  
    int topN = min(10, airports.size());
  
    int margin = 100;
    int chartHeight = height - 2 * margin;
    int chartWidth = width - 2 * margin;
  
    int barWidth = 50;
    int spacing = (chartWidth - (topN * barWidth)) / (topN - 1);
  
    int maxVal = airportCounts.get(airports.get(0));
  
    // Grid lines
    stroke(220);
    for (int i = 0; i <= 5; i++) {
      float y = map(i, 0, 5, height - margin, margin);
      line(margin, y, width - margin, y);
    }
  
    // Axes
    stroke(0);
    line(margin, margin, margin, height - margin);
    line(margin, height - margin, width - margin, height - margin);
  
    // Title
    fill(0);
    textAlign(CENTER);
    textSize(22);
    text("Top 10 Airports (Flights In and Out)", width/2, 50);
  
    // Axis labels
    textSize(16);
    text("Airports", width/2, height - 40);
  
    pushMatrix();
    translate(40, height/2);
    rotate(-HALF_PI);
    text("Number of Flights", 0, 0);
    popMatrix();
  
    // Y-axis numbers
    textSize(12);
    for (int i = 0; i <= 5; i++) {
      int val = int(map(i, 0, 5, 0, maxVal));
      float y = map(i, 0, 5, height - margin, margin);
      text(val, margin - 30, y);
    }
  
    // Bars
    for (int i = 0; i < topN; i++) {
      String airport = airports.get(i);
      int count = airportCounts.get(airport);
  
      float barHeight = map(count, 0, maxVal, 0, chartHeight);
  
      int x = margin + i * (barWidth + spacing);
      int y = height - margin;
  
      fill(100, 150, 255);
      rect(x, y - barHeight, barWidth, barHeight);
  
      fill(0);
      textSize(12);
      text(airport, x + barWidth/2, y + 15);
      text(count, x + barWidth/2, y - barHeight - 10);
    }
  }
  void keyPressed() {
    // Handle key presses for bar chart screen if needed
  }
  
  void mousePressed() {
    // Handle mouse clicks for bar chart screen if needed
  }
  
  void mouseReleased() {
    // Handle mouse release for bar chart screen if needed
  }
   void mouseWheel(MouseEvent event) {
    // Handle mouse wheel scrolling for bar chart screen if needed
  }
}

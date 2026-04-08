//abdul bar chart screen
class BarChartsScreen {

  // Stores number of flights per airport
  HashMap<String, Integer> flightCounts = new HashMap<String, Integer>();

  // Stores total miles per airporrt
  HashMap<String, Float> mileCounts = new HashMap<String, Float>();

   
  ArrayList<String> sortedByFlights = new ArrayList<String>();
  ArrayList<String> sortedByMiles = new ArrayList<String>();


  int topN = 10;


  boolean showMiles = false;

  Flights flightsData;
  
  boolean draggingSlider = false;

  // colors for each bar 
  color[] barColors = {
    color(231, 76, 60),
    color(52, 152, 219),
    color(46, 204, 113),
    color(241, 196, 15),
    color(155, 89, 182),
    color(230, 126, 34),
    color(26, 188, 156),
    color(149, 165, 166),
    color(243, 156, 18),
    color(192, 57, 43)
  };


  BarChartsScreen(Flights flightsData) {
    this.flightsData = flightsData;
    
    countData();              // count flights + miles
    rebuildSortedLists();    // sort results
  }

  // Loops through all flights 
  void countData() {
    flightCounts.clear();    // reset counts
    mileCounts.clear();

    
    if (flightsData == null || flightsData.flights == null) return;

    for (Flight f : flightsData.flights) {

      // Count flights for origin nd destination
      addFlight(f.ORIGIN);
      addFlight(f.DEST);

      // Add distance for both airports
      addMiles(f.ORIGIN, f.DISTANCE);
      addMiles(f.DEST, f.DISTANCE);
    }
  }

  // Adds +1 flight to an airport
  void addFlight(String airport) {
    if (airport == null || airport.equals("")) return;

    if (flightCounts.containsKey(airport)) {
      flightCounts.put(airport, flightCounts.get(airport) + 1);
    } else {
      flightCounts.put(airport, 1);
    }
  }

  // Adds distance
  void addMiles(String airport, float dist) {
    if (airport == null || airport.equals("")) return;

    if (mileCounts.containsKey(airport)) {
      mileCounts.put(airport, mileCounts.get(airport) + dist);
    } else {
      mileCounts.put(airport, dist);
    }
  }

  // Sorts airports from highestto lowest
  void rebuildSortedLists() {

    // Sort by number of flights
    sortedByFlights = new ArrayList<String>(flightCounts.keySet());
    Collections.sort(sortedByFlights, new Comparator<String>() {
      public int compare(String a, String b) {
        return flightCounts.get(b) - flightCounts.get(a); // descending order
      }
    });

    // Sort by miles travelled
    sortedByMiles = new ArrayList<String>(mileCounts.keySet());
    Collections.sort(sortedByMiles, new Comparator<String>() {
      public int compare(String a, String b) {
        return Float.compare(mileCounts.get(b), mileCounts.get(a)); // descending
      }
    });
  }

  // Returns correct list 
  ArrayList<String> getCurrentSortedAirports() {
    return showMiles ? sortedByMiles : sortedByFlights;
  }

  // Main draw function
  void draw() {
    ArrayList<String> airports = getCurrentSortedAirports();

    fill(0);
    textAlign(CENTER, CENTER);

  

    // Chart layout values
    int margin = 100;
    int chartBottom = height - 130;
    int chartTop = 120;
    int chartHeight = chartBottom - chartTop;

    int barsToDraw = min(topN, airports.size());
    int barWidth = 45;
    int spacing = 18;

    // Find max valeu 
    float maxVal = 0;
    for (int i = 0; i < barsToDraw; i++) {
      String airport = airports.get(i);
      float v = showMiles ? mileCounts.get(airport) : flightCounts.get(airport);
      if (v > maxVal) maxVal = v;
    }

  
    if (maxVal <= 0) {
      textSize(18);
      text("No data available", width / 2, height / 2);
      return;
    }

    // Title
    textSize(22);
    text(
      showMiles ? "Airports with Most Flight Miles (In + Out)" : "Airports with Most Flights (In + Out)",
      width / 2, 50
    );

    // Axes
    stroke(0);
    line(margin, chartBottom, width - 100, chartBottom); // x-axis
    line(margin, chartBottom, margin, chartTop);         // y-axis

    // X-axi
    fill(0);
    textSize(14);
    text("Airports", width / 2, height - 50);

    // Y-axis 
    pushMatrix();
    translate(35, height / 2);
    rotate(-HALF_PI);
    text(showMiles ? "Total Miles" : "Number of Flights", 0, 0);
    popMatrix();

    textSize(12);

    // Draw each bar
    for (int i = 0; i < barsToDraw; i++) {
      String airport = airports.get(i);
    
   
      float value = showMiles ? mileCounts.get(airport) : flightCounts.get(airport);

     
      float barHeight = map(value, 0, maxVal, 0, chartHeight);

      int x = margin + i * (barWidth + spacing);
      int y = chartBottom;

      // diff colour diff bar
      fill(barColors[i % barColors.length]);
      noStroke();
      rect(x, y - barHeight, barWidth, barHeight);

      // Labels
      fill(0);
      text(airport, x + barWidth / 2, y + 15);                 // airport code
      text(nf(value, 0, 0), x + barWidth / 2, y - barHeight - 10); // value
    }

    
    drawControls();
  }

 
  void drawControls() {
    fill(0);
    textAlign(LEFT, CENTER);
    textSize(14);

   
    text("Top Airports: " + topN, 700, 100);

   
    stroke(0);
    line(700, 120, 900, 120);

    
    float knobX = map(topN, 1, 10, 700, 900);
    fill(255);
    ellipse(knobX, 120, 15, 15);

    fill(0);
    text("Mode: " + (showMiles ? "Miles" : "Flights"), 700, 180);

    // Toggle button
    fill(0);
    rect(700, 200, 200, 30);

    fill(255);
    textAlign(CENTER, CENTER);
    text(showMiles ? "Switch to Flights" : "Switch to Miles", 800, 215);
  }

  void mousePressed() {

    // Start dragging slider
    if (mouseX > 700 && mouseX < 900 && mouseY > 110 && mouseY < 130) {
      draggingSlider = true;
      updateTopNFromMouse();
    }

    // Toggle between modes
    if (mouseX > 700 && mouseX < 900 && mouseY > 200 && mouseY < 230) {
      showMiles = !showMiles;
    }
  }

  // Update slider while movin
  void mouseDragged() {
    if (draggingSlider) {
      updateTopNFromMouse();
    }
  }

  void mouseReleased() {
    draggingSlider = false;
  }

  void updateTopNFromMouse() {
    topN = int(map(mouseX, 700, 900, 1, 10));
    topN = constrain(topN, 1, 10);
  }

  void keyPressed() { }
  void mouseWheel(MouseEvent event) { }
}

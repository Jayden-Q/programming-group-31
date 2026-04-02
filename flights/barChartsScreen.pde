//abdul bar chart screen
class BarChartsScreen {
  HashMap<String, Integer> flightCounts = new HashMap<String, Integer>();
  HashMap<String, Float> mileCounts = new HashMap<String, Float>();

  ArrayList<String> sortedByFlights = new ArrayList<String>();
  ArrayList<String> sortedByMiles = new ArrayList<String>();

  int topN = 10;
  boolean showMiles = false;
  boolean draggingSlider = false;

  BarChartsScreen() {
    countData();
    rebuildSortedLists();
  }

  void countData() {
    flightCounts.clear();
    mileCounts.clear();

    if (flightsData == null || flightsData.flights == null) return;

    for (Flight f : flightsData.flights) {
      addFlight(f.ORIGIN);
      addFlight(f.DEST);

      addMiles(f.ORIGIN, f.DISTANCE);
      addMiles(f.DEST, f.DISTANCE);
    }
  }

  void addFlight(String airport) {
    if (airport == null || airport.equals("")) return;

    if (flightCounts.containsKey(airport)) {
      flightCounts.put(airport, flightCounts.get(airport) + 1);
    } else {
      flightCounts.put(airport, 1);
    }
  }

  void addMiles(String airport, float dist) {
    if (airport == null || airport.equals("")) return;

    if (mileCounts.containsKey(airport)) {
      mileCounts.put(airport, mileCounts.get(airport) + dist);
    } else {
      mileCounts.put(airport, dist);
    }
  }

  void rebuildSortedLists() {
    sortedByFlights = new ArrayList<String>(flightCounts.keySet());
    Collections.sort(sortedByFlights, new Comparator<String>() {
      public int compare(String a, String b) {
        return flightCounts.get(b) - flightCounts.get(a);
      }
    });

    sortedByMiles = new ArrayList<String>(mileCounts.keySet());
    Collections.sort(sortedByMiles, new Comparator<String>() {
      public int compare(String a, String b) {
        return Float.compare(mileCounts.get(b), mileCounts.get(a));
      }
    });
  }

  ArrayList<String> getCurrentSortedAirports() {
    return showMiles ? sortedByMiles : sortedByFlights;
  }

  void draw() {
    ArrayList<String> airports = getCurrentSortedAirports();

    fill(0);
    textAlign(CENTER, CENTER);

    if (airports == null || airports.size() == 0) {
      textSize(20);
      text("No data loaded", width / 2, height / 2);
      return;
    }

    int margin = 100;
    int chartBottom = height - 130;
    int chartTop = 120;
    int chartHeight = chartBottom - chartTop;

    int barsToDraw = min(topN, airports.size());
    int barWidth = 45;
    int spacing = 18;

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

    textSize(22);
    text(
      showMiles ? "Airports with Most Flight Miles (In + Out)" : "Airports with Most Flights (In + Out)",
      width / 2, 50
    );

    stroke(0);
    line(margin, chartBottom, width - 100, chartBottom);
    line(margin, chartBottom, margin, chartTop);

    fill(0);
    textSize(14);
    text("Airports", width / 2, height - 50);

    pushMatrix();
    translate(35, height / 2);
    rotate(-HALF_PI);
    text(showMiles ? "Total Miles" : "Number of Flights", 0, 0);
    popMatrix();

    textSize(12);

    for (int i = 0; i < barsToDraw; i++) {
      String airport = airports.get(i);
      float value = showMiles ? mileCounts.get(airport) : flightCounts.get(airport);

      float barHeight = map(value, 0, maxVal, 0, chartHeight);
      int x = margin + i * (barWidth + spacing);
      int y = chartBottom;

      fill(100, 150, 255);
      rect(x, y - barHeight, barWidth, barHeight);

      fill(0);
      text(airport, x + barWidth / 2, y + 15);
      text(nf(value, 0, 0), x + barWidth / 2, y - barHeight - 10);
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
    stroke(0);
    ellipse(knobX, 120, 15, 15);

    fill(0);
    text("Mode: " + (showMiles ? "Miles" : "Flights"), 700, 180);

    fill(0);
    rect(700, 200, 200, 30);

    fill(255);
    textAlign(CENTER, CENTER);
    text(showMiles ? "Switch to Flights" : "Switch to Miles", 800, 215);
  }

  void mousePressed() {
    if (mouseX > 700 && mouseX < 900 && mouseY > 110 && mouseY < 130) {
      draggingSlider = true;
      updateTopNFromMouse();
    }

    if (mouseX > 700 && mouseX < 900 && mouseY > 200 && mouseY < 230) {
      showMiles = !showMiles;
    }
  }

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

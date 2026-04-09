//abdul bar chart screen
class BarChartsScreen {
  
  //created a class called barchartsscreen to handle the data processing etc

  // Stores number of flights per airport 
  //To store data Used 2 hash maps. Each airport code is the key and the value is flight or dist
  HashMap<String, Integer> flightCounts = new HashMap<String, Integer>();

  // Stores total miles per airport 
  HashMap<String, Float> mileCounts = new HashMap<String, Float>();

  // Lists used to store sorted airport codes
  //Sorting - stored airpot codes in array list and sorted using collection.sort and using comparator filter by highest to lowest
  ArrayList<String> sortedByFlights = new ArrayList<String>(); 
  ArrayList<String> sortedByMiles = new ArrayList<String>();

  int topN = 10;    // show top 10 airports on chart

  boolean showMiles = false; //Toggle between flights and miles using boolean -showmiles

  boolean draggingSlider = false; // tracks if user is dragging slider

  int mode = 2; // 0 = incoming, 1 = outgoing, 2 = both
  //To process data, (the count data function loops through all flights and update hash map )i implemented a mode system - 0 incoming flights-dest 1 origin 2 both Allows us to see analyse traffic both ways
  
  Flights flightsData; // holds all flight data

  // colors for each bar 
  //Added diff colours to bars and labels for clarity
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

  // Constructor - saves flight data so other func can use
  BarChartsScreen(Flights flightsData) {
    this.flightsData = flightsData;
    
    countData();              // count flights + miles
    rebuildSortedLists();    // sort results
  }

  // Loops through all flights and counts data
  void countData() {
    flightCounts.clear();    // reset counts
    mileCounts.clear();

    // if cant read data it stops running
    if (flightsData == null || flightsData.flights == null) return;

    for (Flight f : flightsData.flights) {

      // mode controls what data we count

      if (mode == 0) {
        // incoming flights only (destination airport)
        addFlight(f.DEST);
        addMiles(f.DEST, f.DISTANCE);
      } 
      else if (mode == 1) {
        // outgoing flights only (origin airport)
        addFlight(f.ORIGIN);
        addMiles(f.ORIGIN, f.DISTANCE);
      } 
      else {
        // both incoming and outgoing flights
        addFlight(f.ORIGIN);
        addFlight(f.DEST);

        addMiles(f.ORIGIN, f.DISTANCE);
        addMiles(f.DEST, f.DISTANCE);
      }
    }
  }

  // Adds +1 flight to an airport
  void addFlight(String airport) {
    if (airport == null || airport.equals("")) return;

    // if airport already exists increase count
    if (flightCounts.containsKey(airport)) {
      flightCounts.put(airport, flightCounts.get(airport) + 1);
    } else {
      // otherwise start count at 1
      flightCounts.put(airport, 1);
    }
  }

  // Adds distance to an airport
  void addMiles(String airport, float dist) {
    if (airport == null || airport.equals("")) return;

    // if airport exists add distance
    if (mileCounts.containsKey(airport)) {
      mileCounts.put(airport, mileCounts.get(airport) + dist);
    } else {
      // otherwise set initial distance
      mileCounts.put(airport, dist);
    }
  }

  // Sorts airports from highest to lowest
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

  // Returns correct list depending on mode (flights or miles)
  ArrayList<String> getCurrentSortedAirports() {
    if (showMiles) {
      return sortedByMiles;
    } else {
      return sortedByFlights;
    }
  }

  // Main draw function 
  //Draw the chart- setup colours, margins and used loop to draw each bar using rect(). Used map function to fit the bars proportional
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

    // Find max value for scaling bars
    float maxVal = 0;
    for (int i = 0; i < barsToDraw; i++) {
      String airport = airports.get(i);
      float v;
      if (showMiles) {
        v = mileCounts.get(airport);
      } else {
        v = flightCounts.get(airport);
      }
      if (v > maxVal) maxVal = v;
    }

    // If no data, display message
    if (maxVal <= 0) {
      textSize(18);
      text("No data available", width / 2, height / 2);
      return;
    }

    // Title
    textSize(22);
    if (showMiles) {
      text("Airports with Most Flight Miles", width / 2, 50);
    } else {
      text("Airports with Most Flights", width / 2, 50);
    }

    // Axes
    //Added x axe using line() and text() for y i used pushmatrix translate and roate to roate the text vertically
    stroke(0);
    line(margin, chartBottom, width - 100, chartBottom); 
    line(margin, chartBottom, margin, chartTop);         

    // xaxis label
    fill(0);
    textSize(14);
    text("Airports", width / 2, height - 50);

    // yaxis label 
    pushMatrix();  
    translate(35, height / 2);
    rotate(-HALF_PI);
    if (showMiles) {
      text("Total Miles", 0, 0);
    } else {
      text("Number of Flights", 0, 0);
    }
    popMatrix();

    textSize(12);

    // Draw each bar
    for (int i = 0; i < barsToDraw; i++) {
      String airport = airports.get(i);
    
      float value;
      if (showMiles) {
        value = mileCounts.get(airport);
      } else {
        value = flightCounts.get(airport);
      }

      // convert data to fit scale for bar
      float barHeight = map(value, 0, maxVal, 0, chartHeight);

      int x = margin + i * (barWidth + spacing);
      int y = chartBottom;

      // draw bar
      fill(barColors[i % barColors.length]);
      noStroke();
      rect(x, y - barHeight, barWidth, barHeight);

      // Labels
      fill(0);
      text(airport, x + barWidth / 2, y + 15);                 
      text(nf(value, 0, 0), x + barWidth / 2, y - barHeight - 10); 
    }

    drawControls(); 
  }

  // drawcontrols
  //Implemented a slider using mouseX and map() func to allow user how many airport displayed. Used contrain() to keep within the valid limits
  //added buttons to filter flights. each button sets mode variable, when clicked rebuildsortedlist func and count data func updates chart
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
    if (showMiles) {
      text("Mode: Miles", 700, 180);
    } else {
      text("Mode: Flights", 700, 180);
    }

    fill(0);
    rect(700, 200, 200, 30);

    fill(255);
    textAlign(CENTER, CENTER);
    if (showMiles) {
      text("Switch to Flights", 800, 215);
    } else {
      text("Switch to Miles", 800, 215);
    }

    fill(0);
    rect(700, 250, 200, 30);
    fill(255);
    text("Incoming", 800, 265);

    fill(0);
    rect(700, 290, 200, 30);
    fill(255);
    text("Outgoing", 800, 305);

    fill(0);
    rect(700, 330, 200, 30);
    fill(255);
    text("Incoming + Outgoing", 800, 345);
  }

  // Handle mouse clicks
  //for user interaction , mouse pressed for clicks, mousedragged for slider and mouserelease to stop dragging
  void mousePressed() {

    if (mouseX > 700 && mouseX < 900 && mouseY > 110 && mouseY < 130) {
      draggingSlider = true;
      updateTopNFromMouse();
    }

    if (mouseX > 700 && mouseX < 900 && mouseY > 200 && mouseY < 230) {
      showMiles = !showMiles;
    }

    if (mouseX > 700 && mouseX < 900 && mouseY > 250 && mouseY < 280) {
      mode = 0;
      countData();
      rebuildSortedLists();
    }

    if (mouseX > 700 && mouseX < 900 && mouseY > 290 && mouseY < 320) {
      mode = 1;
      countData();
      rebuildSortedLists();
    }

    if (mouseX > 700 && mouseX < 900 && mouseY > 330 && mouseY < 360) {
      mode = 2;
      countData();
      rebuildSortedLists();
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
 
 //palceholder
 void keyPressed() { } 
 void mouseWheel(MouseEvent event) { } 
}

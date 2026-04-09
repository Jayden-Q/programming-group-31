// 24/03/26: Jayden, Pie Charts Screen
class PieChartsScreen {
  LinkedHashMap<String, PieChart> pieCharts = new LinkedHashMap<String, PieChart>();
  LinkedHashMap<String, Input> inputs = new LinkedHashMap<String, Input>();
  
  Carousel carousel;
  
  Flights flightsData;
  
  PieChartsScreen(Flights flightsData) {
    this.flightsData = flightsData;
    
    Chart mostFlightsChart = createChart("mostFlights", "Airports with Most Flights (Departures)", 200, 150, 600, 600, flightsData.topNOrigins(flightsData.flights, 5));
    mostFlightsChart.addText(950, 600, "Total flights: ", "totalFlights");
    mostFlightsChart.addText(950, 640, "Airport with most flights: ", "mostFlights");
    mostFlightsChart.addText(950, 680, "Average flights per airport: ", "averageFlights");
    
    PieChart leastFlightsChart = createChart("leastFlights", "Airports with Least Flights (Departures)", 200, 150, 600, 600, flightsData.bottomNOrigins(flightsData.flights, 5));
    leastFlightsChart.setReverse(true);
    leastFlightsChart.setMaxVisualPercent(70);
    leastFlightsChart.addText(950, 600, "Total flights: ", "totalFlights");
    leastFlightsChart.addText(950, 640, "Airport with least flights: ", "leastFlights");
    leastFlightsChart.addText(950, 680, "Average flights per airport: ", "averageFlights");
    
    Chart flightCancellationChart = createChart("flightCancellations", "Flight Cancellations", 200, 150, 600, 600, flightsData.cancellationData(flightsData.flights));
    flightCancellationChart.addText(950, 600, "Highest cancellation airport: ", "highestCancellation");
    flightCancellationChart.addText(950, 640, "Lowest cancellation airport", "lowestCancellation");
    
    PieChart topCarriersChart = createChart("topCarriers", "Carriers with Most Flights", 200, 150, 600, 600, flightsData.topNCarriers(flightsData.flights, 5));
    topCarriersChart.setMaxSlices(8);
    
    this.carousel = new Carousel(200, 150, 600, 600);
    
    for (Chart chart : this.pieCharts.values()) {
      this.carousel.addSlide(chart);
    }
    
    ////////////
    // SLIDER //
    ////////////
    Slider airportsToShowSlider = new Slider(950, 200, 400, 20, "Airports to show", 1, flightsData.getAirports(flightsData.flights).length - 1);
    airportsToShowSlider.setValue(5);
    airportsToShowSlider.setUnit(" airports");
    airportsToShowSlider.setDataType(Input.TYPE_INT);
    
    // Only update chart when the slider changes
    airportsToShowSlider.onChange(new Callback() {
      @Override
      public void call() {
        updateCharts();
      }
    });
    
    Slider sectionsSlider = new Slider(950, 200, 400, 20, "Sections to show", 1, 10);
    sectionsSlider.setValue(5);
    sectionsSlider.setUnit(" sections");
    sectionsSlider.setDataType(Input.TYPE_INT);
    
    sectionsSlider.onChange(new Callback() {
      @Override
      public void call() {
        updateCharts();
      }
    });
    
    
    //////////////////
    // Range Slider //
    //////////////////
    RangeSlider distanceSlider = new RangeSlider(950, 300, 400, 20, "Distance",
      flightsData.getMinDistance(flightsData.flights), flightsData.getMaxDistance(flightsData.flights));
    distanceSlider.setUnit("mi");
    distanceSlider.setLowValue(flightsData.getMinDistance(flightsData.flights));
    distanceSlider.setHighValue(flightsData.getMaxDistance(flightsData.flights));
    distanceSlider.setDataType(Input.TYPE_INT);
    
    distanceSlider.onChange(new Callback() {
      @Override
      public void call() {
        updateCharts(); 
      }
    });
    
    //////////////    
    // Dropdown //
    //////////////
    //String[] airports = {
    //  "origin",
    //  "destination",
    //};
    
    String[] carriers = flightsData.getFlightCarriers(flightsData.flights);
    
    //Dropdown carrierDropdown = new Dropdown(900, 400, 220, 30, "Carrier", carriers, 0);
    //carrierDropdown.setMaxVisibleItems(3);
    
    //carrierDropdown.onChange(new Callback() {
    //  @Override
    //  public void call() {
    //    updateCharts();
    //  }
    //});
    
    
    MultiSelectDropdown carrierDropdown = new MultiSelectDropdown(950, 400, 220, 30, "Carriers", carriers);
    carrierDropdown.setMaxVisibleItems(5);
    
    carrierDropdown.onChange(new Callback() {
      @Override
      public void call() {
        updateCharts();
      }
    });
    
    Button resetCarriersDropdownBtn = new Button(1180, 400, 80, 30, "Reset");
    resetCarriersDropdownBtn.onChange(new Callback() {
      @Override
      public void call() {
        carrierDropdown.clearSelections();
        updateCharts();
      }
    });
    
    // Add all inputs to hashmap
    this.inputs.put("airportsToShowSlider", airportsToShowSlider);
    this.inputs.put("distanceSlider", distanceSlider);
    this.inputs.put("carrierDropdown", carrierDropdown);
    this.inputs.put("resetCarriersDropdownBtn", resetCarriersDropdownBtn);
    this.inputs.put("sectionsSlider", sectionsSlider);
    
    updateCharts();
  }
  
  PieChart createChart(String name, String title, float x, float y, float w, float h, ChartData data) {
    PieChart chart = new PieChart(title, x, y, w, h, data.labels, data.values);
    chart.setMaxSlices(10);
    this.pieCharts.put(name, chart);
    return chart;
  }
  
  //void changeDataset(Flights flightsData) {
  //  this.flightsData = flightsData;
    
  //  Slider airportsToShowSlider = (Slider) this.inputs.get("airportsToShowSlider");
  //  RangeSlider distanceSlider = (RangeSlider) this.inputs.get("distanceSlider");
    
  //  // Update min/max values for max sections slider
  //  airportsToShowSlider.setMinValue(1);
  //  airportsToShowSlider.setMaxValue(flightsData.flights.size());
    
  //  // Update min/max values for distance slider
  //  distanceSlider.setMinValue(flightsData.getMinDistance(flightsData.flights));
  //  distanceSlider.setMaxValue(flightsData.getMaxDistance(flightsData.flights));
    
  //  updateCharts();
  //}
  
  void updateCharts() {
    Slider airportsToShowSlider = (Slider) this.inputs.get("airportsToShowSlider");
    Dropdown carrierDropdown = (Dropdown) this.inputs.get("carrierDropdown");
    RangeSlider distanceSlider = (RangeSlider) this.inputs.get("distanceSlider");
    Slider sectionsToShowSlider = (Slider) this.inputs.get("sectionsSlider");
    
    int airportsToShow = constrain((int) airportsToShowSlider.value, (int)airportsToShowSlider.minV, (int)airportsToShowSlider.maxV);
    airportsToShowSlider.setValue(airportsToShow);
    
    float minDistance = (float) distanceSlider.getLowValue();
    float maxDistance = (float) distanceSlider.getHighValue();
    
    int sectionsToShow = constrain((int) sectionsToShowSlider.value, (int)sectionsToShowSlider.minV, (int)sectionsToShowSlider.maxV);
    sectionsToShowSlider.setValue(sectionsToShow);
    
    String[] carriers = (String[]) carrierDropdown.getValue();
    
    ArrayList<Flight> filteredFlights = flightsData.flights;
    
    if (carriers.length != 0) {
        filteredFlights = flightsData.filterByCarriers(filteredFlights, carriers);
    }
    filteredFlights = flightsData.filterByDistance(filteredFlights, minDistance, maxDistance);
        
    ChartData topOriginsData = flightsData.topNOrigins(filteredFlights, airportsToShow);
    pieCharts.get("mostFlights").setData(topOriginsData.labels, topOriginsData.values);
    
    ChartData bottomOriginsData = flightsData.bottomNOrigins(filteredFlights, airportsToShow);
    pieCharts.get("leastFlights").setData(bottomOriginsData.labels, bottomOriginsData.values);
    
    ChartData cancellationsData = flightsData.cancellationData(filteredFlights);
    pieCharts.get("flightCancellations").setData(cancellationsData.labels, cancellationsData.values);
    
    ChartData carriersData = flightsData.topNCarriers(filteredFlights, sectionsToShow);
    pieCharts.get("topCarriers").setData(carriersData.labels, carriersData.values);
    
    ChartData topCancellationsData = flightsData.topNCancellationOrigins(filteredFlights, flightsData.flights.size());
    
    
    // METRICS
    PieChart mostFlightsChart = pieCharts.get("mostFlights");
    PieChart leastFlightsChart = pieCharts.get("leastFlights");
    PieChart flightCancellationChart = pieCharts.get("flightCancellations");
    
    // NO. AIRPORTS DISPLAYED
    int totalFlightsDisplayedMostFlights = 0;
    for (float v : topOriginsData.values) {
      totalFlightsDisplayedMostFlights += v;
    }
    
    int totalFlightsDisplayedLeastFlights = 0;
    for (float v : bottomOriginsData.values) {
      totalFlightsDisplayedLeastFlights += v;
    }
    
    mostFlightsChart.updateText("totalFlights", "Displaying: " + totalFlightsDisplayedMostFlights + "/" + str(flightsData.flights.size()) + " flights");
    leastFlightsChart.updateText("totalFlights", "Displaying: " + totalFlightsDisplayedLeastFlights + "/" + str(flightsData.flights.size()) + " flights");
    
    // AIRPORT WITH MOST/LEAST FLIGHTS
    if (topOriginsData.labels.length > 0) {
      mostFlightsChart.updateText("mostFlights",
        "Airport with most flights: " +
        topOriginsData.labels[0] +
        " (" + nf(topOriginsData.values[0], 0, 0) + " flights, " +  nf((topOriginsData.values[0] / mostFlightsChart.total) * 100.0, 2, 2) + "%)");
    }
    
    if (bottomOriginsData.labels.length > 0) {
      leastFlightsChart.updateText("leastFlights",
        "Airport with least flights: " +
        bottomOriginsData.labels[0] +
        " (" + nf(bottomOriginsData.values[0], 0, 0) + " flights, " +  nf((bottomOriginsData.values[0] / leastFlightsChart.total) * 100.0, 2, 2) + "%)");
    }
    
    // AVERAGE FLIGHTS PER AIRPORT
    mostFlightsChart.updateText("averageFlights", "Average flights per airport: " + totalFlightsDisplayedMostFlights / airportsToShow);
    leastFlightsChart.updateText("averageFlights", "Average flights per airport: " + totalFlightsDisplayedLeastFlights / airportsToShow);
    
    // AIRPORT WITH MOST CANCELLATIONS
    if (topCancellationsData.labels.length > 0) {
      flightCancellationChart.updateText("highestCancellation", "Airport with most flight cancellations: " +
        topCancellationsData.labels[0] + " (" + (int)topCancellationsData.values[0] + ")");
      flightCancellationChart.updateText("lowestCancellation", "Airport with least flight cancellations: " +
        topCancellationsData.labels[topCancellationsData.labels.length - 1] + " (" + (int)topCancellationsData.values[topCancellationsData.values.length - 1] + ")");
    }
  }
  
  void setVisibility(boolean isVisible) {
    for (Input input: this.inputs.values()) {
      input.isVisible = isVisible;      
    }
  }
  
  void update() {
    switch (this.carousel.selectedIndex) {
      case 2:
        this.inputs.get("airportsToShowSlider").isVisible = false;
        this.inputs.get("sectionsSlider").isVisible = false;
        break;
      case 3:
        this.inputs.get("airportsToShowSlider").isVisible = false;
        this.inputs.get("sectionsSlider").isVisible = true;
        break;
      default:
        this.inputs.get("airportsToShowSlider").isVisible = true;
        this.inputs.get("sectionsSlider").isVisible = false;
    }
  }
  
  void draw() {
    background(#eeeeee);
    
    int currentCursor = ARROW;
    
    this.carousel.update();
    this.carousel.draw();
    
    for (Input input : this.inputs.values()) {
      input.update();
      
      if (input.isVisible && input.isHovered) {
        currentCursor = input.getCursorType();
      }
      
      input.draw();
    }
    
    if (this.carousel.overLeftArrow(mouseX, mouseY) || this.carousel.overRightArrow(mouseX, mouseY)) {
      currentCursor = HAND;
    }
    
    cursor(currentCursor);
  }
    
  
  // EVENTS
  void keyPressed() {}
  
  void mousePressed() {
    for (Input input : this.inputs.values()) {
      input.mousePressed();
    }
    
    this.carousel.mousePressed();
  }
  
  void mouseReleased() {
    for (Input input : this.inputs.values()) {
      input.mouseReleased();
    }
  }
  
  void mouseWheel(MouseEvent event) {
    for (Input input : this.inputs.values()) {
      input.mouseWheel(event.getCount());
    }
  }
}

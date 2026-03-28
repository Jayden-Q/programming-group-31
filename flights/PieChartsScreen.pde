// 24/03/26: Pie Charts Screen
class PieChartsScreen {
  LinkedHashMap<String, PieChart> pieCharts = new LinkedHashMap<String, PieChart>();
  HashMap<String, Input> inputs = new HashMap<String, Input>();
  
  Carousel carousel;
  
  PieChartsScreen() {
    createChart("mostFlights", "Airports with Most Flights", 200, 150, 600, 600, flightsData.topNOrigins(flightsData.flights, 5));
    createChart("leastFlights", "Airports with Least Flights", 200, 150, 600, 600, flightsData.bottomNOrigins(flightsData.flights, 5));
    
    createChart("flightCancellations", "Flight Cancellations", 200, 150, 600, 600, flightsData.cancellationData(flightsData.flights));
    createChart("topCarriers", "Carriers with Most Flights", 200, 150, 600, 600, flightsData.topNCarriers(flightsData.flights, 5));
    
    this.carousel = new Carousel(200, 150, 600, 600);
    
    for (Chart chart : this.pieCharts.values()) {
      this.carousel.addSlide(chart);
    }
    
    ////////////
    // SLIDER //
    ////////////
    Slider sectionsSlider = new Slider(1000, 100, 250, 20, "Sections to show", 1, flightsData.flights.size());
    sectionsSlider.setValue(5);
    sectionsSlider.setUnit(" airports");
    sectionsSlider.setDataType(Input.TYPE_INT);
    
    // Only update chart when the slider changes
    sectionsSlider.onChange(new Callback() {
      @Override
      public void call() {
        updateCharts();
      }
    });
    
    //////////////    
    // Dropdown //
    //////////////
    String[] airports = {
      "origin",
      "destination",
    };
    
    Dropdown originOrDestDropdown = new Dropdown(1000, 200, 220, 30, "Airport", airports, 0);
    originOrDestDropdown.setMaxVisibleItems(5);
    
    originOrDestDropdown.onChange(new Callback() {
      @Override
      public void call() {
        updateCharts();
      }
    });
    
    
    //////////////////
    // Range Slider //
    //////////////////
    RangeSlider distanceSlider = new RangeSlider(1000, 300, 250, 20, "Distance",
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
    
    
    // Add all inputs to hashmap
    this.inputs.put("sectionsSlider", sectionsSlider);
    this.inputs.put("originOrDestDropdown", originOrDestDropdown);
    this.inputs.put("distanceSlider", distanceSlider);
  }
  
  PieChart createChart(String name, String title, float x, float y, float w, float h, ChartData data) {
    PieChart chart = new PieChart(title, x, y, w, h, data.labels, data.values);
    this.pieCharts.put(name, chart);
    return chart;
  }
  
  void updateCharts() {
    Slider sectionsSlider = (Slider) this.inputs.get("sectionsSlider");
    Dropdown originOrDestDropdown = (Dropdown) this.inputs.get("originOrDestDropdown");
    RangeSlider distanceSlider = (RangeSlider) this.inputs.get("distanceSlider");
    
    int sections = (int) sectionsSlider.value;
    float minDistance = (float) distanceSlider.getLowValue();
    float maxDistance = (float) distanceSlider.getHighValue();
  
    ArrayList<Flight> filteredFlights = flightsData.filterByDistance(flightsData.flights, minDistance, maxDistance);
    
    if (originOrDestDropdown.getValue() == "origin") {
      ChartData topOriginsData = flightsData.topNOrigins(filteredFlights, sections);
      pieCharts.get("mostFlights").setData(topOriginsData.labels, topOriginsData.values);
      
      ChartData bottomOriginsData = flightsData.bottomNOrigins(filteredFlights, sections);
      pieCharts.get("leastFlights").setData(bottomOriginsData.labels, bottomOriginsData.values);
      
    } else if (originOrDestDropdown.getValue() == "destination") {
      ChartData topDestinationsData = flightsData.topNDestinations(filteredFlights, sections);
      pieCharts.get("mostFlights").setData(topDestinationsData.labels, topDestinationsData.values);
      
      ChartData bottomDestinationsData = flightsData.bottomNDestinations(filteredFlights, sections);
      pieCharts.get("leastFlights").setData(bottomDestinationsData.labels, bottomDestinationsData.values);
    }
    
    ChartData cancellationsData = flightsData.cancellationData(filteredFlights);
    pieCharts.get("flightCancellations").setData(cancellationsData.labels, cancellationsData.values);
    
    ChartData carriersData = flightsData.topNCarriers(filteredFlights, sections);
    pieCharts.get("topCarriers").setData(carriersData.labels, carriersData.values);
  }
  
  void update() {}
  
  void draw() {
    background(#eeeeee);
    
    this.carousel.update();
    this.carousel.draw();
    
    for (Input input : this.inputs.values()) {
      input.update();
      input.draw();
    }    
  }
  
  
  // EVENTS
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

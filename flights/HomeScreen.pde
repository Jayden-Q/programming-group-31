// 24/03/26: Jayden, Home Screen
class HomeScreen {
  HashMap<String, Input> inputs = new HashMap<String, Input>();
  
  HomeScreen() {
    Button pieChartsScreenBtn = new Button(50, 50, 200, 40, "Pie Charts");
    Button searchScreenBtn = new Button(300, 50, 200, 40, "Flights");
    Button barChartsScreenBtn = new Button(550, 50, 200, 40, "Bar Charts");
    
    pieChartsScreenBtn.onChange(new Callback() {
      @Override
      void call() {
        screenToRenderIndex = 0;
      }
    });
    
    searchScreenBtn.onChange(new Callback() {
      @Override
      void call() {
        screenToRenderIndex = 1;
      }
    });
    
    barChartsScreenBtn.onChange(new Callback() {
      @Override
      void call() {
        screenToRenderIndex = 2;
      }
    });
    
    this.inputs.put("pieChartsScreenBtn", pieChartsScreenBtn);
    this.inputs.put("searchScreenBtn", searchScreenBtn);
    this.inputs.put("barChartsScreenBtn", barChartsScreenBtn);
  }
  
  void setVisibility(boolean isVisible) {
    for (Input input: this.inputs.values()) {
      input.isVisible = isVisible;
    }
  }
  
  void update() {}
  
  void draw() {
    background(#eeeeee);
    
    int currentCursor = ARROW;
    
    for (Input input : this.inputs.values()) {
      input.update();
      
      if (input.isVisible && input.isHovered) {
        currentCursor = input.getCursorType();
      }
      
      input.draw();
    }
    
    cursor(currentCursor);
  }
  
  
  // EVENTS
  void mousePressed() {
    for (Input input : this.inputs.values()) {
      input.mousePressed();
    }
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

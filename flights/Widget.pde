// 27/03/26: Jayden, Widget class, Carousel class
class Widget {
  float x, y;
  float w, h;
  
  Callback callback;
  
  Widget(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void onChange(Callback callback) {
    this.callback = callback;  
  }
  
  void mousePressed() {}
  void mouseReleased() {}
  void mouseWheel() {}
  
  void update() {}
  
  void draw() {}
}



class Carousel extends Widget {
  ArrayList<Chart> chartsList = new ArrayList<Chart>();
  int selectedIndex = 0;
  
  float arrowSize = 20;
  float arrowOffset = 10;
  
  Carousel(float x, float y, float w, float h) {
    super(x, y, w, h);
  }
  
  void addSlide(Chart chart) {
    this.chartsList.add(chart);
  }
  
  void mousePressed() {
    if (this.chartsList != null && this.chartsList.size() == 0) return;
    
    if (overLeftArrow(mouseX, mouseY)) {
      this.selectedIndex--;
      
      if (this.selectedIndex < 0) {
        this.selectedIndex = this.chartsList.size() - 1;
      }
    } else if (overRightArrow(mouseX, mouseY)) {
      this.selectedIndex++;
      
      if (this.selectedIndex >= this.chartsList.size()) {
        this.selectedIndex = 0;
      }
    }
  }
  
  void update() {}
  
  void draw() {
    if (this.chartsList != null && this.chartsList.size() > 0) {
      this.chartsList.get(this.selectedIndex).update();
      this.chartsList.get(this.selectedIndex).draw();
    }
    
    drawLeftArrow();
    drawRightArrow();
  }
  
  void drawLeftArrow() {
    float arrowX = this.x + arrowOffset;
    float arrowY = this.y + this.h + this.arrowOffset * 4;
    
    fill(0);
    noStroke();
    
    triangle(
      arrowX + arrowSize * 0.3, arrowY - arrowSize * 0.6,
      arrowX + arrowSize * 0.3, arrowY + arrowSize * 0.6,
      arrowX - arrowSize * 0.5, arrowY
    );
  }
  
  void drawRightArrow() {
    float arrowX = this.x + this.w - arrowOffset;
    float arrowY = this.y + this.h + this.arrowOffset * 4;
    
    fill(0);
    noStroke();
    
    triangle(
      arrowX - arrowSize * 0.3, arrowY - arrowSize * 0.6,
      arrowX - arrowSize * 0.3, arrowY + arrowSize * 0.6,
      arrowX + arrowSize * 0.5, arrowY
    );
  }
  
  boolean overLeftArrow(float px, float py) {
    float arrowX = this.x + arrowOffset;
    float arrowY = this.y + this.h + this.arrowOffset * 4;
    return px >= arrowX - arrowSize &&
           px <= arrowX + arrowSize &&
           py >= arrowY - arrowSize &&
           py <= arrowY + arrowSize;
  }
  
  boolean overRightArrow(float px, float py) {
    float arrowX = this.x + this.w - arrowOffset;
    float arrowY = this.y + this.h + this.arrowOffset * 4;
    return px >= arrowX - arrowSize &&
           px <= arrowX + arrowSize &&
           py >= arrowY - arrowSize &&
           py <= arrowY + arrowSize;
  }
}

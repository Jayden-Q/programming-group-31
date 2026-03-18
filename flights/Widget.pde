class Widget {
  int x, y;
  int w, h;
  
  String label;
  
  color widgetColor;
  color labelColor;
  
  color strokeColor;
  color strokeBaseColor;
  color strokeHoverColor;
  
  PFont widgetFont;
  
  int event;
  
  Widget(int x, int y, int w, int h, String label, color widgetColor, PFont widgetFont, int event) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    this.label = label;
    this.widgetColor = widgetColor;
    this.widgetFont = widgetFont;
    this.event = event;
    
    this.labelColor = color(0);
    this.strokeBaseColor = color(0);
    this.strokeHoverColor = color(255);
    this.strokeColor = this.strokeBaseColor;
  }
  
  void draw() {
    stroke(this.strokeColor);
    fill(this.widgetColor);
    rect(this.x, this.y, this.w, this.h);
    fill(this.labelColor);
    textFont(this.widgetFont);
    text(this.label, this.x + GAP, this.y + this.h - GAP);
  }
  
  int getEvent(int mX, int mY) {
    if (
      mX > this.x && mX < this.x + this.w &&
      mY > this.y && mY < this.y + this.h
    ) {
      return this.event;
    }
    
    return EVENT_NULL;
  }
}

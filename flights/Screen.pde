class Screen {
  ArrayList<Widget> widgets;
  
  color backgroundColor;
  
  Screen() {
    this.widgets = new ArrayList<Widget>();
    this.backgroundColor = color(255);
  }
  
  void setBackground(color c) {
    this.backgroundColor = c;
  }
  
  int getEvent(int mX, int mY) {
    for (int i = 0; i < this.widgets.size(); i++) {
      Widget widget = this.widgets.get(i);
      int event = widget.getEvent(mX, mY);
      if (event != EVENT_NULL) return event;
    }
    
    return EVENT_NULL;
  }
  
  void addWidget(int x, int y, int w, int h, String label, color widgetColor, PFont widgetFont, int event) {
    Widget widget = new Widget(x, y, w, h, label, widgetColor, widgetFont, event);
    this.widgets.add(widget);
  }
  
  void draw() {
    background(this.backgroundColor);
    
    for (int i = 0; i < this.widgets.size(); i++) {
      Widget widget = this.widgets.get(i);
      widget.draw();
    }
  }
}
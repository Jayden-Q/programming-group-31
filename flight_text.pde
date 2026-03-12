final int EVENT_NULL = 0;
final int GAP = 10;

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

class Flight{
  int FL_DATE;
  String MKT_CARRIER;
  int MKT_CARRIER_FL_NUM;
  String ORIGIN;
  String ORIGIN_CITY_NAME;
  String ORIGIN_STATE_ABR;
  int ORIGIN_WAC;
  String DEST;
  String DEST_CITY_NAME;
  String DEST_STATE_ABR;
  int DEST_WAC;
  int CRS_DEP_TIME;
  int DEP_TIME;
  int CRS_ARR_TIME;
  int ARR_TIME;
  boolean CANCELLED;
  boolean DIVERTED;
  int DISTANCE;
   
  Flight(int FL_DATE, String MKT_CARRIER, int MKT_CARRIER_FL_NUM,
    String ORIGIN, String ORIGIN_CITY_NAME, String ORIGIN_STATE_ABR, int ORIGIN_WAC,
    String DEST, String DEST_CITY_NAME, String DEST_STATE_ABR, int DEST_WAC,
    int CRS_DEP_TIME, int DEP_TIME, int CRS_ARR_TIME, int ARR_TIME,
    boolean CANCELLED, boolean DIVERTED, int DISTANCE) {
    
    this.FL_DATE = FL_DATE;
    this.MKT_CARRIER = MKT_CARRIER;
    this.MKT_CARRIER_FL_NUM = MKT_CARRIER_FL_NUM;
    this.ORIGIN = ORIGIN;
    this.ORIGIN_CITY_NAME = ORIGIN_CITY_NAME;
    this.ORIGIN_STATE_ABR = ORIGIN_STATE_ABR;
    this.ORIGIN_WAC = ORIGIN_WAC;
    this.DEST = DEST;
    this.DEST_CITY_NAME = DEST_CITY_NAME;
    this.DEST_STATE_ABR = DEST_STATE_ABR;
    this.DEST_WAC = DEST_WAC;
    this.CRS_DEP_TIME = CRS_DEP_TIME;
    this.DEP_TIME = DEP_TIME;
    this.CRS_ARR_TIME = CRS_ARR_TIME;
    this.ARR_TIME = ARR_TIME;
    this.CANCELLED = CANCELLED;
    this.DIVERTED = DIVERTED;
    this.DISTANCE = DISTANCE;      
  }
}

Table table;
int x = 0;
int y = 0;
void setup() {
  table = loadTable("flights2k.csv", "header");
  
  for (TableRow row : table.rows()) {
    String name = row.getString("ORIGIN_CITY_NAME");
    println(name);
    fill(0);
    text(name, x, y);
    y += 15;
  }
  
  size(800, 600);
}

void draw() {

}

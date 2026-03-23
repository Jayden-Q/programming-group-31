class Chart {
  String title;
  float x, y;
  float w, h;
  
  Chart(String title, float x, float y, float w, float h) {
    this.title = title;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void update() {}
  
  void draw() {}
}

class BarChart extends Chart {
  BarChart(String title, float x, float y, float w, float h, String xAxisTitle, String yAxisTitle) {
    super(title, x, y, w, h);
    
    
  }
}

//class PieChart extends Chart {

//  }

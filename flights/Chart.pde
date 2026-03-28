// 24/03/26: Jayden, ChartData class
class ChartData {
  String[] labels;
  float[] values;
  
  ChartData(String[] labels, float[] values) {
    this.labels = labels;
    this.values = values;
  } 
}

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

class PieChart extends Chart {
  String[] labels;
  float[] values;
  color[] colours;
 
  float total;
  
  PieChart(String title, float x, float y, float w, float h, String[] labels, float[] values) {
    super(title, x, y, w, h);
    this.labels = labels;
    this.values = values;
    
    this.colours = new color[values.length];
    generateColours();
    update();
  }
  
  void setData(String[] labels, float[] values) {
    this.labels = labels;
    this.values = values;
    
    if (this.colours == null || this.colours.length != values.length) {
      this.colours = new color[values.length];
      generateColours();
    }
    
    update();
  }
  
  void generateColours() {
    color[] palette = {
      #3498D8,
      #2ECC71,
      #9B59B6,
      #F1C40F,
      #E67E22,
      #1ABC9C,
      #E74C3C,
      #95A5A6
    };
    
    for (int i = 0; i < this.colours.length; i++) {
      this.colours[i] = palette[i % palette.length];
    }
  }
  
  void update() {
    this.total = 0;
    for (int i = 0; i < this.values.length; i++) {
      total += this.values[i];
    }
  }
  
  void draw() {
    if (this.values == null || this.values.length == 0 || this.total <= 0) return;
    
    float cx = this.x + this.w / 2.0;
    float cy = this.y + this.h / 2.0;
    float diameter = min(this.w, this.h);
    float radius = diameter / 2.0;
    
    // Title
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(this.title, cx, this.y - 60);
    
    float startAngle = -HALF_PI; // start at top
    
    for (int i = 0; i < this.values.length; i++) {
      float angle = TWO_PI * (this.values[i] / this.total);
      float midAngle = startAngle + angle / 2.0;
      
      // Draw slice
      fill(colours[i]);
      stroke(255);
      strokeWeight(2);
      arc(cx, cy, diameter, diameter, startAngle, startAngle + angle, PIE);
      
      // Draw value + percentage inside of slice
      float innerTextRadius = radius * 0.55;
      float tx = cx + cos(midAngle) * innerTextRadius;
      float ty = cy + sin(midAngle) * innerTextRadius;
      
      float percent = (this.values[i] / this.total) * 100.0;
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(12);
      text(nf(this.values[i], 0, 1) + "\n" + nf(percent, 0, 1) + "%", tx, ty);
      
      // Draw label outside pie
      float labelRadius = radius + 30;
      float lx = cx + cos(midAngle) * labelRadius;
      float ly = cy + sin(midAngle) * labelRadius;
            
      fill(0);
      noStroke();
      textSize(14);
      
      if (cos(midAngle) >= 0) {
        textAlign(LEFT, CENTER);
      } else {
        textAlign(RIGHT, CENTER);
      }
      
      text(labels[i], lx, ly);
      
      startAngle += angle;
    }
  }
}

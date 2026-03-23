class Input {
  String label;
  float x, y;
  float w, h;
  boolean isActive = false;
  boolean isHovered = false;
  boolean isVisible = true;
  Object value;
  
  Input(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  void setValue(Object value) {
    this.value = value;
  }
  
  Object getValue() {
    return this.value;
  }
  
  void setLabel(String l) {
    this.label = l;
  }
  
  void mousePressed() {
    isActive = this.isHovered;
  }
  
  void update() {
    this.isHovered =
      mouseX > this.x && mouseX < this.x + this.w &&
      mouseY > this.y && mouseY < this.y + this.h;
  }
 
  void draw() {
    if (!this.isVisible) return;
    
    stroke(0);
    fill(this.isActive ? 200 : 100);
    rect(this.x, this.y, this.w, this.h);
    
    fill(0);
    text(this.label, this.x, this.y - 5);
  }
}

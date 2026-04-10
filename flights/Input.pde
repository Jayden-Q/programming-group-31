// 24/03/26: Jayden, Input, Slider, RangeSlider
class Input {
  static final int TYPE_STRING = 0;
  static final int TYPE_INT = 1;
  static final int TYPE_FLOAT = 2;
  static final int TYPE_BOOL = 3;

  int dataType = TYPE_STRING;

  String label;
  float x, y;
  float w, h;
  boolean isActive = false;
  boolean isHovered = false;
  boolean isVisible = true;
  Object value;
  Object defaultValue;

  Callback callback;

  Input(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  void setDefaultValue(Object value) {
    this.value = value;
  }

  void setValue(Object value) {
    this.value = value;
    this.triggerCallback();
  }

  Object getValue() {
    return this.value;
  }

  void setLabel(String l) {
    this.label = l;
  }
  
  void reset() {
    this.value = this.defaultValue;
    this.triggerCallback();
  }

  void setDataType(int type) {
    switch (type) {
      case TYPE_STRING:
        this.dataType = TYPE_STRING;
        break;
      case TYPE_INT:
        this.dataType = TYPE_INT;
        break;
      case TYPE_FLOAT:
        this.dataType = TYPE_FLOAT;
        break;
      case TYPE_BOOL:
        this.dataType = TYPE_BOOL;
        break;
      default:
        this.dataType = TYPE_STRING;
    }
  }

  String getDisplayValue(Object value) {
    if (value == null) return "";

    switch (dataType) {
    case TYPE_STRING:
      return (String) value;

    case TYPE_INT:
      if (value instanceof Number) {
        return str(((Number) value).intValue());
      }
      return (String) value;

    case TYPE_FLOAT:
      if (value instanceof Number) {
        return nf(((Number) value).floatValue(), 1, 2);
      }
      return (String) value;

    case TYPE_BOOL:
      if (value instanceof Boolean) {
        return ((Boolean) value) ? "true" : "false";
      }
      return (String) value;

    default:
      return (String) value;
    }
  }

  void mousePressed() {
    isActive = isMouseHovering();
  }

  void mouseReleased() {}

  void mouseWheel(float e) {}
  
  void keyPressed(char Key) {}

  boolean isMouseHovering() {
    return mouseX > this.x && mouseX < this.x + this.w &&
      mouseY > this.y && mouseY < this.y + this.h;
  }

  void onChange(Callback callback) {
    this.callback = callback;
  }

  // Called when a user event occurs (clicking, draggin, typing, etc.)
  void triggerCallback() {
    if (this.callback != null && this.isVisible) {
      this.callback.call();
    }
  }

  // What the cursor should look like when the user hovers/focuses/etc. on this Input
  int getCursorType() {
    return ARROW;
  }

  // Always check if the user is hovering over this Input
  void update() {
    this.isHovered = isMouseHovering() && this.isVisible;
  }

  void draw() {
    if (!this.isVisible) return;

    // Label
    fill(0);
    text(this.label, this.x, this.y - 5);
    
    // Draw input background
    stroke(0);
    if (this.isActive) {
      fill(255, 255, 200);
    } else {
      fill(255);
    }
    rect(this.x, this.y, this.w, this.h);
    
    // Draw value text
    fill(0);
    textAlign(LEFT);
    if (this.value != null) {
      text(this.value.toString(), this.x + 5, this.y + this.h - 7);
    }
  }
}


////////////////////////////////////
///////////////Slider///////////////
////////////////////////////////////
class Slider extends Input {
  float value;
  float minV, maxV;
  boolean isDragging = false;
  String unit = "";

  Slider(float x, float y, float w, float h, String label, float minV, float maxV) {
    super(x, y, w, h, label);

    this.minV = minV;
    this.maxV = maxV;
    this.value = (maxV + minV) / 2;
  }

  void setValue(Object value) {
    if (value instanceof Number) {
      this.value = constrain(((Number)value).floatValue(), minV, maxV);
    }
  }

  Object getValue() {
    return this.value;
  }

  void setUnit(String unit) {
    this.unit = unit;
  }
  
  void setMinValue(Object value) {
    if (value instanceof Number) {
      this.minV = ((Number)value).floatValue();
    }
  }
  
  void setMaxValue(Object value) {
    if (value instanceof Number) {
      this.maxV = ((Number)value).floatValue();
    }
  }

  void mousePressed() {
    if (isMouseHovering()) {
      this.isDragging = true;
      this.isActive = true;
    } else {
      this.isActive = false;
    }
  }

  void mouseReleased() {
    this.isDragging = false;
    this.isActive = false;
  }
  
  int getCursorType() {
    return HAND;
  }

  void update() {
    super.update();

    // Dragging logic
    if (this.isDragging) {
      float t = constrain((mouseX - this.x) / this.w, 0, 1); // Normalize mouse position to a value between 0 and 1
      this.value = lerp(this.minV, this.maxV, t);
      this.triggerCallback();
    }
  }

  void draw() {
    if (!this.isVisible) return;

    stroke(0);
    fill(100);
    rect(this.x, this.y + this.h / 2 - 2, this.w, 4);

    // handle position
    float t = (this.value - this.minV) / (this.maxV - this.minV);
    float handleX = this.x + t * this.w;

    // handle
    fill(this.isActive ? 50 : 100);
    ellipse(handleX, this.y + this.h / 2, this.h, this.h);

    // label + value
    textSize(16);
    textAlign(LEFT);
    fill(0);
    text(this.label + ": " + getDisplayValue(this.value) + this.unit, this.x, this.y - 10);
  }
}



//////////////////////////////////////////
///////////////Range Slider///////////////
//////////////////////////////////////////
class RangeSlider extends Slider {
  float lowValue;
  float highValue;

  boolean draggingLow = false;
  boolean draggingHigh = false;

  RangeSlider(float x, float y, float w, float h, String label, float minV, float maxV) {
    super(x, y, w, h, label, minV, maxV);

    // Default values for both handles
    this.lowValue = minV + (maxV - minV) * 0.25;
    this.highValue = minV + (maxV - minV) * 0.75;
  }

  // Convert value to an x screen position
  float valueToX(float v) {
    float t = (v - minV) / (maxV - minV); // Normalize
    return x + t * w;
  }

  // Convert x screen position to a value
  float xToValue(float mx) {
    float t = constrain((mx - x) / w, 0, 1); // Normalize
    return lerp(minV, maxV, t);
  }

  float getLowValue() {
    return lowValue;
  }

  float getHighValue() {
    return highValue;
  }

  void setLowValue(float v) {
    lowValue = constrain(v, minV, highValue);
  }

  void setHighValue(float v) {
    highValue = constrain(v, lowValue, maxV);
  }

  void mousePressed() {
    float lowX = valueToX(lowValue);
    float highX = valueToX(highValue);
    float cy = y + h / 2.0;
    float r = h / 2.0;

    boolean overLow = dist(mouseX, mouseY, lowX, cy) <= r;
    boolean overHigh = dist(mouseX, mouseY, highX, cy) <= r;

    // Failsafe in case mouse overlaps both handles
    if (overLow && overHigh) {
      
      // Pick the closest handle
      if (abs(mouseX - lowX) <= abs(mouseX - highX)) {
        draggingLow = true;
      } else {
        draggingHigh = true;
      }
      isActive = true;
    } else if (overLow) {
      draggingLow = true;
      isActive = true;
    } else if (overHigh) {
      draggingHigh = true;
      isActive = true;
    } else if (isMouseHovering()) { // If clicked somewhere on the slider track
      float mouseValue = xToValue(mouseX);
      
      // Move closest handle to the click position
      if (abs(mouseValue - lowValue) <= abs(mouseValue - highValue)) {
        lowValue = constrain(mouseValue, minV, highValue);
        draggingLow = true;
      } else {
        highValue = constrain(mouseValue, lowValue, maxV);
        draggingHigh = true;
      }
      isActive = true;
    } else {
      isActive = false;
    }
  }

  void mouseReleased() {
    draggingLow = false;
    draggingHigh = false;
  }
  
  int getCursorType() {
    return HAND;
  }

  void update() {
    super.update();

    float lowX = valueToX(lowValue);
    float highX = valueToX(highValue);
    float cy = y + h / 2.0;
    float r = h / 2.0;

    boolean overLow = dist(mouseX, mouseY, lowX, cy) <= r;
    boolean overHigh = dist(mouseX, mouseY, highX, cy) <= r;

    this.isHovered = (overLow || overHigh || draggingLow || draggingHigh || this.isMouseHovering()) && this.isVisible;

    if (draggingLow) {
      float mouseValue = xToValue(mouseX);
      lowValue = constrain(mouseValue, minV, highValue);
      this.triggerCallback();
    }

    if (draggingHigh) {
      float mouseValue = xToValue(mouseX);
      highValue = constrain(mouseValue, lowValue, maxV);
      this.triggerCallback();
    }
  }

  void draw() {
    if (!isVisible) return;

    float cy = y + h / 2.0;
    float lowX = valueToX(lowValue);
    float highX = valueToX(highValue);

    // full track
    stroke(0);
    fill(120);
    rect(x, cy - 2, w, 4);

    // selected range
    fill(#038cfc);
    rect(lowX, cy - 3, highX - lowX, 6);

    // handles
    fill(draggingLow ? 40 : 100);
    ellipse(lowX, cy, h, h);

    fill(draggingHigh ? 40 : 100);
    ellipse(highX, cy, h, h);

    // label
    textSize(16);
    textAlign(LEFT);
    fill(0);
    text(label + ": " + getDisplayValue(this.lowValue) + this.unit + " - " + getDisplayValue(this.highValue) + this.unit, this.x, this.y - 10);
  }
}


//////////////////////////////////////
///////////////Dropdown///////////////
//////////////////////////////////////
class Dropdown extends Input {
  // List of selectable options
  String[] options;
  int selectedIndex = 0;

  boolean isOpen = false;

  int maxVisibleItems = 5; // Max number of items displayed on list before scrolling
  int scrollOffset = 0;

  float itemHeight; // Height of each item in dropdown list

  Dropdown(float x, float y, float w, float h, String label, String[] options, int defaultIndex) {
    super(x, y, w, h, label);

    this.options = options;
    this.itemHeight = h;

    if (options == null || options.length == 0) {
      // if empty options list provided
      this.options = new String[]{"(empty)"};
      this.selectedIndex = 0;
    } else {
      // Set default value selected to index provided
      setSelectedIndex(defaultIndex);
    }

    // Get the value at the default index
    this.setDataType(TYPE_STRING);
  }

  void setMaxVisibleItems(int n) {
    this.maxVisibleItems = max(1, n); // Make sure n >= 1
    clampScroll();
  }

  void setValue(Object value) {
    if (value == null) return;

    String s = (String) value;

    for (int i = 0; i < this.options.length; i++) {
      if (this.options[i].equals(s)) {
        this.selectedIndex = i;
        this.value = this.options[i];
        clampScroll();
        return;
      }
    }
  }

  Object getValue() {
    return options[selectedIndex];
  }

  String getSelectedValue() {
    return options[selectedIndex];
  }

  int getSelectedIndex() {
    return selectedIndex;
  }

  void setSelectedIndex(int i) {
    if (options == null || options.length == 0) return;

    selectedIndex = constrain(i, 0, options.length - 1);
    this.value = options[selectedIndex];

    checkSelectedVisible();
  }

  void mousePressed() {
    if (!this.isVisible) return;

    if (isOverClosedBox()) {
      this.isOpen = !this.isOpen;
      this.isActive = this.isOpen;
      return;
    }

    if (this.isOpen && isOverList()) {
      int clickedIndex = getHoveredItemIndex();

      if (clickedIndex != -1) {
        setSelectedIndex(clickedIndex);
        this.triggerCallback();
      }

      this.isOpen = false;
      this.isActive = false;

      return;
    }

    this.isOpen = false;
    this.isActive = false;
  }

  void mouseWheel(float e) {
    if (!this.isVisible) return;
    if (!this.isOpen) return;
    if (!isOverList()) return;

    if (this.options.length > this.maxVisibleItems) {
      if (e > 0) {
        this.scrollOffset++;
      } else if (e < 0) {
        this.scrollOffset--;
      }

      clampScroll();
    }
  }

  boolean isOverClosedBox() {
    return mouseX > this.x && mouseX < this.x + this.w &&
      mouseY > this.y && mouseY < this.y + this.h;
  }

  boolean isOverList() {
    if (!this.isOpen) return false;

    int visibleCount = min(this.maxVisibleItems, this.options.length);
    float listY = this.y + this.h;
    float listH = visibleCount * this.itemHeight;

    return mouseX > this.x && mouseX < this.x + this.w &&
      mouseY > listY && mouseY < listY + listH;
  }

  int getHoveredItemIndex() {
    if (!this.isOpen || !isOverList()) return -1;

    float listY = this.y + this.h;
    int localIndex = int((mouseY - listY) / this.itemHeight);
    int actualIndex = this.scrollOffset + localIndex;

    if (actualIndex >= 0 && actualIndex < this.options.length) {
      return actualIndex;
    }
    return -1;
  }

  void clampScroll() {
    int maxScroll = max(0, this.options.length - this.maxVisibleItems);
    this.scrollOffset = constrain(this.scrollOffset, 0, maxScroll);
  }

  void checkSelectedVisible() {
    if (this.selectedIndex < this.scrollOffset) {
      this.scrollOffset = this.selectedIndex;
    } else if (this.selectedIndex >= this.scrollOffset + this.maxVisibleItems) {
      this.scrollOffset = this.selectedIndex - this.maxVisibleItems + 1;
    }
    clampScroll();
  }

  void update() {
    this.isHovered = (isOverClosedBox() || (this.isOpen && isOverList())) && this.isVisible;
  }
  
  int getCursorType() {
    return HAND;
  }

  void draw() {
    if (!this.isVisible) return;

    textAlign(LEFT);
    textSize(16);

    fill(0);
    text(this.label, this.x, this.y - 10);

    // main dropdown box
    noStroke();
    fill(this.isActive ? 220 : 255);
    rect(this.x, this.y, this.w, this.h);

    // selected value
    fill(0);
    String selectedText = options[selectedIndex];
    text(selectedText, this.x + 8, this.y + this.h * 0.65);

    // dropdown arrow
    float arrowX = this.x + this.w - 18;
    float arrowY = this.y + this.h / 2.0;

    fill(0);
    if (this.isOpen) {
      triangle(arrowX - 6, arrowY + 3, arrowX + 6, arrowY + 3, arrowX, arrowY - 4);
    } else {
      triangle(arrowX - 6, arrowY - 3, arrowX + 6, arrowY - 3, arrowX, arrowY + 4);
    }

    if (this.isOpen) {
      drawList();
    }
  }

  void drawList() {
    int visibleCount = min(this.maxVisibleItems, this.options.length);
    float listY = this.y + this.h;
    float listH = visibleCount * this.itemHeight;

    // list background
    noStroke();
    fill(255);
    rect(this.x, listY, this.w, listH);

    int hoveredIndex = getHoveredItemIndex();

    for (int i = 0; i < visibleCount; i++) {
      int optionIndex = this.scrollOffset + i;
      if (optionIndex >= this.options.length) break;

      float itemY = listY + i * this.itemHeight;

      if (optionIndex == hoveredIndex) {
        fill(230);
        noStroke();
        rect(this.x, itemY, this.w, this.itemHeight);
        stroke(0);
      } else if (optionIndex == this.selectedIndex) {
        fill(210, 230, 255);
        noStroke();
        rect(this.x, itemY, this.w, this.itemHeight);
        stroke(0);
      }

      fill(0);
      text(this.options[optionIndex], this.x + 8, itemY + this.itemHeight * 0.65);

      stroke(200);
      line(this.x, itemY + this.itemHeight, this.x + this.w, itemY + this.itemHeight);
      stroke(0);
    }

    // scrollbar
    if (this.options.length > this.maxVisibleItems) {
      float barW = 8;
      float trackX = this.x + this.w - barW - 2;
      float trackY = listY + 2;
      float trackH = listH - 4;

      fill(240);
      noStroke();
      rect(trackX, trackY, barW, trackH);

      float thumbH = max(20, trackH * ((float) this.maxVisibleItems / this.options.length));
      float maxScroll = this.options.length - this.maxVisibleItems;
      float thumbY = trackY;

      if (maxScroll > 0) {
        thumbY = trackY + (trackH - thumbH) * (this.scrollOffset / maxScroll);
      }

      fill(140);
      rect(trackX, thumbY, barW, thumbH);
      stroke(0);
    }
  }
}



//26/03/2026 Xianren - text input extension for input and exiting the search box
// TextInput 
class TextInput extends Input {
  TextInput(String label, float x, float y, float w, float h) {
    super(x, y, w, h, label);
  }
  
  @Override
  void keyPressed(char key) {
    if (!isActive) return;
    
    if (key == BACKSPACE) {
      String current = (String)this.value;
      if (current.length() > 0) {
        this.value = current.substring(0, current.length() - 1);
        triggerCallback();
      }
    } 
    else if (key == ENTER || key == RETURN) {
      isActive = false;
    }
    else if (key != CODED && key != BACKSPACE && key != ENTER && key != TAB) {
      this.value = (String)this.value + key;
      triggerCallback();
    }
  }
  
  int getCursorType() {
    return TEXT;
  }
}



// 28/03/26: Jayden, Button class, Multi-select dropdown
class Button extends Input {

  Button(float x, float y, float w, float h, String label) {
    super(x, y, w, h, label);
  }
  
  boolean isMouseHovering() {
    return mouseX > this.x && mouseX < this.x + this.w &&
      mouseY > this.y && mouseY < this.y + this.h;
  }
  
  void mousePressed() {
    this.isActive = isMouseHovering();
  }
  
  void mouseReleased() {
    if (this.isActive) {
      this.triggerCallback();
      
      this.isActive = false;
    }
  }
  
  void update() {
    this.isHovered = isMouseHovering() && this.isVisible;
  }
  
  int getCursorType() {
    return HAND;
  }
  
  void draw() {
    if (!this.isVisible) return;
    
    // Draw button background
    //stroke(0);
    noStroke();
    
    if (this.isActive) {
      fill(255, 255, 200);
    } else {
      if (this.isHovered) {
        fill(#f2f6fa);
      } else {
        fill(255);
      }
    }
    
    rect(this.x, this.y, this.w, this.h);
    
    // Label
    fill(0);
    textAlign(CENTER, CENTER);
    text(this.label, this.x + this.w / 2, this.y + this.h / 2);
  }
}


////////////////////////////////////////
/////////Multi-Select Dropdown//////////
////////////////////////////////////////
class MultiSelectDropdown extends Dropdown {
  boolean[] selected;
  String emptyDisplayText = "Select...";
  color selectedCircleColor = color(50, 180, 80);

  MultiSelectDropdown(float x, float y, float w, float h, String label, String[] options) {
    super(x, y, w, h, label, options, 0);

    this.selected = new boolean[this.options.length];

    this.selectedIndex = -1;
    updateValue();
  }

  MultiSelectDropdown(float x, float y, float w, float h, String label, String[] options, int[] defaultSelectedIndices) {
    super(x, y, w, h, label, options, 0);

    this.selected = new boolean[this.options.length];
    this.selectedIndex = -1;

    if (defaultSelectedIndices != null) {
      for (int i = 0; i < defaultSelectedIndices.length; i++) {
        int idx = defaultSelectedIndices[i];
        if (idx >= 0 && idx < this.selected.length) {
          this.selected[idx] = true;
        }
      }
    }

    updateValue();
  }

  void setValue(Object value) {
    if (value == null) return;

    for (int i = 0; i < this.selected.length; i++) {
      this.selected[i] = false;
    }

    if (value instanceof String[]) {
      String[] values = (String[]) value;

      for (int i = 0; i < values.length; i++) {
        for (int j = 0; j < this.options.length; j++) {
          if (this.options[j].equals(values[i])) {
            this.selected[j] = true;
            break;
          }
        }
      }
    } else if (value instanceof String) {
      String s = (String) value;

      for (int i = 0; i < this.options.length; i++) {
        if (this.options[i].equals(s)) {
          this.selected[i] = true;
          break;
        }
      }
    }

    updateValue();
  }

  Object getValue() {
    return getSelectedValues();
  }

  String[] getSelectedValues() {
    int count = 0;
    for (int i = 0; i < this.selected.length; i++) {
      if (this.selected[i]) count++;
    }

    String[] result = new String[count];
    int index = 0;

    for (int i = 0; i < this.selected.length; i++) {
      if (this.selected[i]) {
        result[index++] = this.options[i];
      }
    }

    return result;
  }

  IntList getSelectedIndices() {
    IntList indices = new IntList();

    for (int i = 0; i < this.selected.length; i++) {
      if (this.selected[i]) {
        indices.append(i);
      }
    }

    return indices;
  }

  boolean isSelected(int i) {
    if (i < 0 || i >= this.selected.length) return false;
    return this.selected[i];
  }

  void setSelected(int i, boolean state) {
    if (i < 0 || i >= this.selected.length) return;
    this.selected[i] = state;
    updateValue();
  }

  void toggleSelected(int i) {
    if (i < 0 || i >= this.selected.length) return;
    this.selected[i] = !this.selected[i];
    updateValue();
  }

  void clearSelections() {
    for (int i = 0; i < this.selected.length; i++) {
      this.selected[i] = false;
    }
    updateValue();
  }

  void selectAll() {
    for (int i = 0; i < this.selected.length; i++) {
      this.selected[i] = true;
    }
    updateValue();
  }

  void updateValue() {
    this.value = getSelectedValues();
  }

  String getDisplayText() {
    String[] values = getSelectedValues();

    if (values.length == 0) return emptyDisplayText;

    String result = "";
    for (int i = 0; i < values.length; i++) {
      result += values[i];
      if (i < values.length - 1) result += ", ";
    }

    return result;
  }

  void mousePressed() {
    if (!this.isVisible) return;

    if (isOverClosedBox()) {
      if (!this.isOpen) {
        this.isOpen = true;
        this.isActive = true;
      }
      return;
    }

    if (this.isOpen && isOverList()) {
      int clickedIndex = getHoveredItemIndex();

      if (clickedIndex != -1) {
        toggleSelected(clickedIndex);
        this.triggerCallback();
      }

      this.isActive = true;
      return;
    }

    this.isOpen = false;
    this.isActive = false;
  }

  void draw() {
    if (!this.isVisible) return;

    textAlign(LEFT);
    textSize(16);

    fill(0);
    text(this.label, this.x, this.y - 10);

    // main dropdown box
    noStroke();
    fill(this.isActive ? 220 : 255);
    rect(this.x, this.y, this.w, this.h);

    // selected values text
    fill(0);
    String selectedText = getDisplayText();

    float maxTextWidth = this.w - 32;
    while (textWidth(selectedText) > maxTextWidth && selectedText.length() > 3) {
      selectedText = selectedText.substring(0, selectedText.length() - 4) + "...";
    }

    text(selectedText, this.x + 8, this.y + this.h * 0.65);

    // dropdown arrow
    float arrowX = this.x + this.w - 18;
    float arrowY = this.y + this.h / 2.0;

    fill(0);
    if (this.isOpen) {
      triangle(arrowX - 6, arrowY + 3, arrowX + 6, arrowY + 3, arrowX, arrowY - 4);
    } else {
      triangle(arrowX - 6, arrowY - 3, arrowX + 6, arrowY - 3, arrowX, arrowY + 4);
    }

    if (this.isOpen) {
      drawList();
    }
  }

  void drawList() {
    int visibleCount = min(this.maxVisibleItems, this.options.length);
    float listY = this.y + this.h;
    float listH = visibleCount * this.itemHeight;

    // list background
    noStroke();
    fill(255);
    rect(this.x, listY, this.w, listH);

    int hoveredIndex = getHoveredItemIndex();

    for (int i = 0; i < visibleCount; i++) {
      int optionIndex = this.scrollOffset + i;
      if (optionIndex >= this.options.length) break;

      float itemY = listY + i * this.itemHeight;

      // hover highlight
      if (optionIndex == hoveredIndex) {
        fill(230);
        noStroke();
        rect(this.x, itemY, this.w, this.itemHeight);
      }

      // selection indicator circle
      float circleX = this.x + 12;
      float circleY = itemY + this.itemHeight * 0.5;
      float circleSize = 10;

      stroke(120);
      strokeWeight(1);

      if (this.selected[optionIndex]) {
        fill(selectedCircleColor);
      } else {
        fill(255);
      }
      ellipse(circleX, circleY, circleSize, circleSize);

      fill(0);
      text(this.options[optionIndex], this.x + 24, itemY + this.itemHeight * 0.65);
      
      stroke(200);
      line(this.x, itemY + this.itemHeight, this.x + this.w, itemY + this.itemHeight);
    }

    // scrollbar
    if (this.options.length > this.maxVisibleItems) {
      float barW = 8;
      float trackX = this.x + this.w - barW - 2;
      float trackY = listY + 2;
      float trackH = listH - 4;

      fill(240);
      noStroke();
      rect(trackX, trackY, barW, trackH);

      float thumbH = max(20, trackH * ((float)this.maxVisibleItems / this.options.length));
      float maxScroll = this.options.length - this.maxVisibleItems;
      float thumbY = trackY;

      if (maxScroll > 0) {
        thumbY = trackY + (trackH - thumbH) * (this.scrollOffset / maxScroll);
      }

      fill(140);
      rect(trackX, thumbY, barW, thumbH);
    }

    strokeWeight(1);
    stroke(0);
  }
}

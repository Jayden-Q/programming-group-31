// 24/03/26: Jayden, ChartData class
class ChartData {
  String[] labels;
  float[] values;
  
  ChartData(String[] labels, float[] values) {
    this.labels = labels;
    this.values = values;
  } 
}

// Used for metrics/additional information for the charts
class Text {
  String text;
  
  float x, y;
  
  Text(String text, float x, float y) {
    this.text = text;
    this.x = x;
    this.y = y;
  }
}

class Chart {
  String title;
  float x, y;
  float w, h;
  
  // Stores all text so it can be accessed later
  HashMap<String, Text> texts = new HashMap<String, Text>();
  
  Chart(String title, float x, float y, float w, float h) {
    this.title = title;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void addText(float x, float y, String text, String id) {
    this.texts.put(id, new Text(text, x, y));
  }
  
  // Change the text content by ID
  void updateText(String id, String text) {
    Text t = this.texts.get(id);
    if (t != null) {
      t.text = text;
    }
  }
  
  // Get the content of a Text by ID
  String getText(String id) {
    return this.texts.get(id).text;
  }
  
  void update() {}
  
  // Draws all the text
  void draw() {
    fill(0);
    textSize(16);
    for (Text text : this.texts.values()) {
      text(text.text, text.x, text.y);
    }
  }
}

class PieChart extends Chart {
  String[] labels;
  float[] values;
  color[] colours; // Colour for each slice
 
  float total; // total of all values in the chart
  
  String[] displayLabels;
  float[] displayValues;
  color[] displayColours;
  float displayTotal;
  
  // Values to draw the pie chart slices to maintain ideal sizes (slices can't be too small or too big)
  float[] visualValues;
  float visualTotal;
  
  // Settings for controlling the chart's behaviour
  boolean groupSmallSlicesIntoOther = true;
  int maxSlices = 6;
  String otherLabel = "Other";
  boolean reverseOrder = false;
  boolean limitVisualSlicePercent = false;
  float maxVisualPercent = 40;
 
  PieChart(String title, float x, float y, float w, float h, String[] labels, float[] values) {
    super(title, x, y, w, h);
    this.labels = labels;
    this.values = values;
    
    this.colours = new color[values.length];
    generateColours();
    update();
  }
  
  // Replaces the chart data and updates everything
  void setData(String[] labels, float[] values) {
    this.labels = labels;
    this.values = values;
    
    if (this.colours == null || this.colours.length != values.length) {
      this.colours = new color[values.length];
      generateColours();
    }
    
    update();
  }
  
  // Sets the maximum number of visible slices before the smallest slices compress to form "Other"
  void setMaxSlices(int maxSlices) {
    this.maxSlices = max(1, maxSlices);
    update();
  }
  
  // Sets whether to draw the data ascending or descending
  void setReverse(boolean reverse) {
    this.reverseOrder = reverse;
    update();
  }
  
  // Sets the max percent size of the pie chart a slice can take up
  void setMaxVisualPercent(float percent) {
    this.maxVisualPercent = constrain(percent, 0.1, 100);
    this.limitVisualSlicePercent = true;
    update();
  }
  
  void setLimitVisualSlicePercent(boolean enabled) {
    this.limitVisualSlicePercent = enabled;
    update();
  }
  
  // Creates repeating colour palette for pie chart slices
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
    if (this.values != null) {
      for (int i = 0; i < this.values.length; i++) {
        total += this.values[i];
      }
    }
    buildDisplayData();
    buildVisualData();
  }
  
  void buildDisplayData() {
    // Failsafe that creates empty arrays if the data is not valid
    if (this.labels == null || this.values == null || this.labels.length == 0) {
      this.displayLabels = new String[0];
      this.displayValues = new float[0];
      this.displayColours = new color[0];
      this.displayTotal = 0;
      return;
    }
    
    int n = min(this.labels.length, this.values.length);
    
    // Calculate total of display values
    this.displayTotal = 0;
    for (int i = 0; i < n; i++) {
      if (this.values[i] > 0) this.displayTotal += this.values[i];
    }
    
    // If the number of slices < maxSlices, then draw the pie chart normally
    if (!this.groupSmallSlicesIntoOther || n <= this.maxSlices) {
      this.displayLabels = new String[n];
      this.displayValues = new float[n];
      this.displayColours = new color[n];
      
      for (int i = 0; i < n; i++) {
        this.displayLabels[i] = this.labels[i];
        this.displayValues[i] = this.values[i];
        this.displayColours[i] = this.colours[i % this.colours.length];
      }
      return;
    }
    
    int[] sorted = sortIndicesByValueDesc(this.values, n);
    
    // Keep maxSlices = -1 to save one for "Other"
    int keepCount = max(1, this.maxSlices - 1);
    keepCount = min(keepCount, n);
    
    int resultSize = keepCount + 1;
    this.displayLabels = new String[resultSize];
    this.displayValues = new float[resultSize];
    this.displayColours = new color[resultSize];
    
    float otherTotal = 0;
    
    if (!reverseOrder) {
      // Keep largest slices individually
      for (int i = 0; i < keepCount; i++) {
        int idx = sorted[i];
        this.displayLabels[i] = this.labels[idx];
        this.displayValues[i] = this.values[idx];
        this.displayColours[i] = this.colours[idx % this.colours.length];
      }
      
      // Add smaller slices into "Other"
      for (int i = keepCount; i < n; i++) {
        int idx = sorted[i];
        otherTotal += this.values[idx];
      }
    } else {
      for (int i = 0; i < keepCount; i++) {
        int idx = sorted[n - keepCount + i];
        this.displayLabels[i] = this.labels[idx];
        this.displayValues[i] = this.values[idx];
        this.displayColours[i] = this.colours[idx % this.colours.length];
      }
      
      for (int i = 0; i < n - keepCount; i++) {
        int idx = sorted[i];
        otherTotal += this.values[idx];
      }
    }
    
    // Add the "Other" slice
    this.displayLabels[keepCount] = this.otherLabel;
    this.displayValues[keepCount] = otherTotal;
    this.displayColours[keepCount] = color(180);
    
    // If the "Other" slice has no value then remove it
    if (otherTotal <= 0) {
      this.displayLabels = subset(this.displayLabels, 0, keepCount);
      this.displayValues = subset(this.displayValues, 0, keepCount);
      this.displayColours = subset(this.displayColours, 0, keepCount);
    }
  }
  
  // Values used will only be for specifically drawing the chart
  void buildVisualData() {
    if (this.displayValues == null || this.displayValues.length == 0 || this.displayTotal <= 0) {
      this.visualValues = new float[0];
      this.visualTotal = 0;
      return;
    }
    
    int n = this.displayValues.length;
    this.visualValues = new float[n];
    
    if (!this.limitVisualSlicePercent || this.maxVisualPercent >= 100) {
      this.visualTotal = 0;
      for (int i = 0; i < n; i++) {
        this.visualValues[i] = this.displayValues[i];
        this.visualTotal += this.visualValues[i];
      }
      return;
    }
    
    // Calculate each slice's original share
    float cap = this.maxVisualPercent / 100.0;
    float[] baseShares = new float[n];
    float[] resultShares = new float[n];
    boolean[] active = new boolean[n];
    
    int activeCount = 0;
    for (int i = 0; i < n; i++) {
      if (this.displayValues[i] > 0) {
        baseShares[i] = this.displayValues[i] / this.displayTotal;
        active[i] = true;
        activeCount++;
      }
    }
    
    float assigned = 0;
    
    // Loop until all slices have been assigned a final share
    while (activeCount > 0) {
      float activeBaseTotal = 0;
      for (int i = 0; i < n; i++) {
        if (active[i]) activeBaseTotal += baseShares[i];
      }
      
      if (activeBaseTotal <= 0) break;
      
      float remaining = 1.0 - assigned;
      boolean changed = false;
      
      for (int i = 0; i < n; i++) {
        if (!active[i]) continue;
        
        float share = remaining * (baseShares[i] / activeBaseTotal);
        if (share > cap) {
          resultShares[i] = cap;
          assigned += cap;
          active[i] = false;
          activeCount--;
          changed = true;
        }
      }
      
      if (!changed) {
        for (int i = 0; i < n; i++) {
          if (active[i]) {
            resultShares[i] = remaining * (baseShares[i] / activeBaseTotal);
            active[i] = false;
            activeCount--;
          }
        }
      }
    }
    
    this.visualTotal = 0;
    for (int i = 0; i < n; i++) {
      this.visualValues[i] = resultShares[i];
      this.visualTotal += this.visualValues[i];
    }
  }
  
  // Helper methods
  int[] sortIndicesByValueDesc(float[] arr, int count) {
    int[] indices = new int[count];
    int[] temp = new int[count];
    
    for (int i = 0; i < count; i++) {
      indices[i] = i;
    }
    
    mergeSortIndices(arr, indices, temp, 0, count - 1);
    return indices;
  }
  
  void mergeSortIndices(float[] arr, int[] indices, int[] temp, int left, int right) {
    if (left >= right) return;
    
    int mid = (left + right) / 2;
    mergeSortIndices(arr, indices, temp, left, mid);
    mergeSortIndices(arr, indices, temp, mid + 1, right);
    mergeIndices(arr, indices, temp, left, mid, right);
  }
  
  void mergeIndices(float[] arr, int[] indices, int[] temp, int left, int mid, int right) {
    int i = left;
    int j = mid + 1;
    int k = left;
    
    while (i <= mid && j <= right) {
      if (arr[indices[i]] >= arr[indices[j]]) {
        temp[k++] = indices[i++];
      } else {
        temp[k++] = indices[j++];
      }
    }
    
    while (i <= mid) {
      temp[k++] = indices[i++];
    }
    
    while (j <= right) {
      temp[k++] = indices[j++];
    }
    
    for (int p = left; p <= right; p++) {
      indices[p] = temp[p];
    }
  }
  
  void draw() {
    // Show "No data" if there is the data is not valid
    if (this.displayValues == null || this.displayValues.length == 0 || this.displayTotal <= 0 || this.visualValues == null || this.visualValues.length == 0 || this.visualTotal <= 0) {
      fill(0);
      textAlign(CENTER);
      textSize(20);
      text("No data", this.x + (this.w / 2), this.y + (this.h / 2));
      
      return;
    };
    
    // Draw the metrics text
    super.draw();
    
    // Pie chart values
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
    
    for (int i = 0; i < this.displayValues.length; i++) {
      if (this.displayValues[i] <= 0 || this.visualValues[i] <= 0) continue;
      
      float angle = TWO_PI * (this.visualValues[i] / this.visualTotal);
      float midAngle = startAngle + angle / 2.0;
      
      // Draw slice
      fill(this.displayColours[i]);
      stroke(255);
      strokeWeight(2);
      arc(cx, cy, diameter, diameter, startAngle, startAngle + angle, PIE);
      
      // Draw value + percentage inside of slice
      float percent = (this.displayValues[i] / this.displayTotal) * 100.0;
      
      float innerTextRadius = radius * 0.55;
      float tx = cx + cos(midAngle) * innerTextRadius;
      float ty = cy + sin(midAngle) * innerTextRadius;
      
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(12);
      text(nf(this.displayValues[i], 0, 0) + "\n" + nf(percent, 0, 1) + "%", tx, ty);
      
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
      
      text(this.displayLabels[i], lx, ly);
      
      startAngle += angle;
    }
  }
}

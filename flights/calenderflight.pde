//abdul
String dateInput = "";
String yearInput = "";

int selectedMonth = 0;

boolean typingDate = false;
boolean typingYear = false;

String flightDate = "";

String[] months = {
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
};

void setup() {
  size(500, 300);
  textAlign(CENTER, CENTER);
  textSize(20);
}

void draw() {
  background(245);

  fill(0);
  textSize(26);
  text("Flight Date Input", width/2, 40);

  textSize(20);

  // DATE
  drawBox(120, 120, dateInput, "DATE", typingDate);

  // MONTH (click to cycle)
  drawBox(250, 120, months[selectedMonth], "MONTH", false);

  // YEAR
  drawBox(380, 120, yearInput, "YEAR", typingYear);

  // ENTER button
  fill(180, 220, 180);
  rect(width/2 - 60, 180, 120, 40, 10);
  fill(0);
  text("ENTER", width/2, 200);

  // Output
  fill(0);
  textSize(18);
  text("FlightDate: " + flightDate, width/2, 260);
}

void drawBox(int x, int y, String value, String label, boolean active) {
  if (active) fill(200, 230, 255);
  else fill(255);

  stroke(0);
  rect(x - 50, y - 30, 100, 60, 8);

  fill(0);
  text(value, x, y);

  textSize(12);
  text(label, x, y - 40);
  textSize(20);
}

void mousePressed() {
  // DATE
  if (overBox(120, 120)) {
    typingDate = true;
    typingYear = false;
  }

  // MONTH (cycle)
  else if (overBox(250, 120)) {
    selectedMonth = (selectedMonth + 1) % 12;
    typingDate = false;
    typingYear = false;
  }

  // YEAR
  else if (overBox(380, 120)) {
    typingYear = true;
    typingDate = false;
  }

  // ENTER
  else if (mouseX > width/2 - 60 && mouseX < width/2 + 60 &&
           mouseY > 180 && mouseY < 220) {

    if (!dateInput.equals("") && !yearInput.equals("")) {
      flightDate = formatFlightDate();
    }
  }
}

boolean overBox(int x, int y) {
  return mouseX > x - 50 && mouseX < x + 50 &&
         mouseY > y - 30 && mouseY < y + 30;
}

void keyPressed() {
  if (typingDate) {
    if (key >= '0' && key <= '9' && dateInput.length() < 2) {
      dateInput += key;
    } else if (key == BACKSPACE && dateInput.length() > 0) {
      dateInput = dateInput.substring(0, dateInput.length() - 1);
    }
  }

  if (typingYear) {
    if (key >= '0' && key <= '9' && yearInput.length() < 4) {
      yearInput += key;
    } else if (key == BACKSPACE && yearInput.length() > 0) {
      yearInput = yearInput.substring(0, yearInput.length() - 1);
    }
  }
}

// Convert to yyyymmdd
String formatFlightDate() {
  String day = dateInput.length() == 1 ? "0" + dateInput : dateInput;
  String month = (selectedMonth + 1 < 10) ? "0" + (selectedMonth + 1) : str(selectedMonth + 1);
  return yearInput + month + day;
}

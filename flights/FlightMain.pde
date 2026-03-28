import java.util.*;
import processing.event.*;

// Base font
PFont widgetFont;

// Management class for flights
Flights flightsData;

// Screens
PieChartsScreen pieChartsScreen;
SearchScreen searchScreen;
BarChartsScreen barChartsScreen;

// 12/03/2026: Jayden, setup
void setup() {
  // Screen size
  size(1400, 900);
  
  // Font
  widgetFont = createFont("Arial", 14);
  textFont(widgetFont);
  
  // Load CSV file
  Table table = loadTable("flights2k.csv", "header");
  flightsData = new Flights(table);
  
  // Initialize screens
  pieChartsScreen = new PieChartsScreen();
  searchScreen = new SearchScreen();
  barChartsScreen = new BarChartsScreen();
}


int screenToRenderIndex = 1;

void draw() {
  switch (screenToRenderIndex) {
    case 0:
      pieChartsScreen.draw();
      break;
    case 1:
      searchScreen.draw();
      break;
    case 2:
      barChartsScreen.draw();
      break;
    default:
      searchScreen.draw();
  }
}

void keyPressed() {
  // TEMPORARY: Press 'l' to switch screens
  if (key == 'l') screenToRenderIndex = ++screenToRenderIndex % 3;
  
  searchScreen.keyPressed();
}

//12/03/2026 Abdul - scrolling using up and down key
void keyReleased() {
  searchScreen.keyReleased();
}

// 24/03/26: Jayden, mouse events
void mousePressed() {
  pieChartsScreen.mousePressed();
  searchScreen.mousePressed();
}

void mouseReleased() {
  pieChartsScreen.mouseReleased();
}

void mouseWheel(MouseEvent event) {
  pieChartsScreen.mouseWheel(event);
}

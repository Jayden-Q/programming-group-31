import java.util.*;
import processing.event.*;

// Navigation object
Navigation nav;

// Base font
PFont widgetFont;

// Management class for flights
Flights flightsData;

// Screens
PieChartsScreen pieChartsScreen;
SearchScreen searchScreen;
BarChartsScreen barChartsScreen;

int screenToRenderIndex = 1;

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
  
  // Initialize navigation
  nav = new Navigation(50, 20, 120, 40);
  nav.addButton("Pie Chart", 0);
  nav.addButton("Search city", 1);
  nav.addButton("Bar Chart", 2);
}

void draw() {
  background(#eeeeee);
  // Update and draw button
  nav.update();
  nav.draw();
  
  // Get current screen from button
  screenToRenderIndex = nav.getCurrentScreen();
      
  // Draw current screen
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
  // Pass key press to active screen
  if (screenToRenderIndex == 0) {
    pieChartsScreen.keyPressed();
  } else if (screenToRenderIndex == 1) {
    searchScreen.keyPressed();
  } else if (screenToRenderIndex == 2) {
    barChartsScreen.keyPressed();
  }
}

void keyReleased() {
  // Pass key release to search screen for scrolling
  if (screenToRenderIndex == 1) {
    searchScreen.keyReleased();
  }
}

void mousePressed() {
  // Check navigation buttons first
  int newScreen = nav.checkClick();
  if (newScreen != nav.getCurrentScreen()) {
    // Screen changed by button click
    return;
  }
  
  // Pass mouse press to active screen
  if (screenToRenderIndex == 0) {
    pieChartsScreen.mousePressed();
  } else if (screenToRenderIndex == 1) {
    searchScreen.mousePressed();
  } else if (screenToRenderIndex == 2) {
    barChartsScreen.mousePressed();
  }
}

void mouseReleased() {
  // Pass mouse release to active screen
  if (screenToRenderIndex == 0) {
    pieChartsScreen.mouseReleased();
  } else if (screenToRenderIndex == 2) {
    barChartsScreen.mouseReleased();
  }
}

void mouseWheel(MouseEvent event) {
  // Pass mouse wheel to screens that need it
  if (screenToRenderIndex == 0) {
    pieChartsScreen.mouseWheel(event);
  } else if (screenToRenderIndex == 2) {
    barChartsScreen.mouseWheel(event);
  }
}

//02/04/2026 Xianren - changes in relation to screen switching feature
//02/04/2026 Xianren - attempted a dataset changing feature(discarded)
import java.util.*;
import processing.event.*;
Table table, table2, table3, table4;

// Navigation object
Navigation nav;

// Base font
PFont widgetFont;

Flights flightsData;

//02/04/2026 Xianren - changes in relation to screen switching feature
// Screens
PieChartsScreen pieChartsScreen;
SearchScreen searchScreen;
BarChartsScreen barChartsScreen;

int screenToRenderIndex = 1;
boolean cursorBusy = false;

// 12/03/2026: Jayden, setup
void setup() {
  // Screen size
  size(1400, 900);
  
  // Font
  widgetFont = createFont("Arial", 14);
  textFont(widgetFont);
  
  // Load CSV file
  table = loadTable("flights2k.csv", "header");

  flightsData = new Flights(table);
  
  // Initialize screens
  pieChartsScreen = new PieChartsScreen(flightsData);
  searchScreen = new SearchScreen(flightsData);
  barChartsScreen = new BarChartsScreen(flightsData);

  //02/04/2026 Xianren - changes in relation to screen switching feature
  // Initialize navigation
  nav = new Navigation(50, 20, 120, 40);
  nav.addButton("Pie Chart", 0);
  nav.addButton("Search city", 1);
  nav.addButton("Bar Chart", 2);
}

void draw() {
  background(#eeeeee);
 
  // Get current screen from button
  screenToRenderIndex = nav.getCurrentScreen();
      
  // Draw current screen
  switch (screenToRenderIndex) {
    case 0:
      pieChartsScreen.update();
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

  //02/04/2026 Xianren - changes in relation to screen switching feature
  // Update and draw button
  nav.update();
  nav.draw();
}

//02/04/2026 Xianren - changes in relation to screen switching feature
void keyPressed() {
  // Pass key press to active screen
  if (screenToRenderIndex == 0) {
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

//02/04/2026 Xianren - changes in relation to screen switching feature
void mousePressed() {
  // Check navigation buttons first
  int newScreen = nav.checkClick();
  if (newScreen != nav.getCurrentScreen()) {
    // Screen changed by button click
    return;
  }
  

  //02/04/2026 Xianren - changes in relation to screen switching feature
  // Pass mouse press to active screen
  if (screenToRenderIndex == 0) {
    pieChartsScreen.mousePressed();
  } else if (screenToRenderIndex == 1) {
    searchScreen.mousePressed();
  } else if (screenToRenderIndex == 2) {
    barChartsScreen.mousePressed();
  }

  //02/04/2026 Xianren - attempted a dataset changing feature(discarded)
  if (key == 'z' || key == 'Z') {
         flightsData = new Flights(table);
  } else if (key == 'x' || key == 'X') {
         flightsData = new Flights(table2);
  }
}

void mouseReleased() {
  //02/04/2026 Xianren - changes in relation to screen switching feature
  // Pass mouse release to active screen
  if (screenToRenderIndex == 0) {
    pieChartsScreen.mouseReleased();
  } else if (screenToRenderIndex == 2) {
    barChartsScreen.mouseReleased();
  }
}

//02/04/2026 Xianren - changes in relation to screen switching feature
void mouseWheel(MouseEvent event) {
  // Pass mouse wheel to screens that need it
  if (screenToRenderIndex == 0) {
    pieChartsScreen.mouseWheel(event);
  } else if (screenToRenderIndex == 2) {
    barChartsScreen.mouseWheel(event);
  }
}

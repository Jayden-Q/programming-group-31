import java.util.*;
import processing.event.*;
Table table, table2, table3, table4;

// Navigation object
Navigation nav;

// Dropdown for selecting dataset
Dropdown datasetDropdown;

// Base font
PFont widgetFont;

// Management class for flights
//Flights flightsData2k;
//Flights flightsData10k;
//Flights flightsData100k;
//Flights flightsDataAll;

Flights flightsData;

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
  //table2 = loadTable("flights10k.csv", "header");
  //table3 = loadTable("flights100k.csv", "header");
  //table4 = loadTable("flights_full.csv", "header");

  flightsData = new Flights(table);
  
  // Initialize screens
  pieChartsScreen = new PieChartsScreen(flightsData);
  searchScreen = new SearchScreen(flightsData);
  barChartsScreen = new BarChartsScreen(flightsData);
  
  // Initialize navigation
  nav = new Navigation(50, 20, 120, 40);
  nav.addButton("Pie Chart", 0);
  nav.addButton("Search city", 1);
  nav.addButton("Bar Chart", 2);
  
  // Initialize dataset dropdown
  //String[] datasetOptions = {
  //  "2k",
  //  "10k",
  //  "100k",
  //  "all"
  //};
  //datasetDropdown = new Dropdown(width - 250, 40, 200, 40, "Dataset", datasetOptions, 0);
  //datasetDropdown.setMaxVisibleItems(2);
  
  //datasetDropdown.onChange(new Callback() {
  //  @Override
  //  void call() {
  //    switch ((String) datasetDropdown.value) {
  //      case "2k":
  //        selectedDataset = flightsData2k;
  //        pieChartsScreen.changeDataset(selectedDataset);
  //        break;
  //      case "10k":
  //        selectedDataset = flightsData10k;
  //        pieChartsScreen.changeDataset(selectedDataset);
  //        break;
  //      case "100k":
  //        selectedDataset = flightsData100k;
  //        break;
  //      case "all":
  //        selectedDataset = flightsData100k;
  //        break;
  //    }
  //  }
  //});
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
  
  // Update and draw button
  nav.update();
  nav.draw();
  
//  datasetDropdown.update();
//  datasetDropdown.draw();
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
  
  //datasetDropdown.mousePressed();
  
  // Pass mouse press to active screen
  if (screenToRenderIndex == 0) {
    pieChartsScreen.mousePressed();
  } else if (screenToRenderIndex == 1) {
    searchScreen.mousePressed();
  } else if (screenToRenderIndex == 2) {
    barChartsScreen.mousePressed();
  }
  
  if (key == 'z' || key == 'Z') {
         flightsData = new Flights(table);
  } else if (key == 'x' || key == 'X') {
         flightsData = new Flights(table2);
  }
}

void mouseReleased() {
  //datasetDropdown.mouseReleased();
  
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
  
  //datasetDropdown.mouseWheel(event.getCount());
}

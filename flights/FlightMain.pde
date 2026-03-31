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
HomeScreen homeScreen;
int screenToRenderIndex = 3;

boolean cursorBusy = false;



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
  homeScreen = new HomeScreen();
}

/* 31/03/26: Jayden
  - Added buttons to navigate to different screens, fixed bug 
  - Fixed bug where inputs on one screen were still interactable when under a different screen
*/
void draw() {
  switch (screenToRenderIndex) {
    case 0:
      homeScreen.setVisibility(false);
      pieChartsScreen.setVisibility(true);
      searchScreen.setVisibility(false);
      barChartsScreen.setVisibility(false);
      
      pieChartsScreen.draw();
      break;
    case 1:
      homeScreen.setVisibility(false);
      pieChartsScreen.setVisibility(false);
      searchScreen.setVisibility(true);
      barChartsScreen.setVisibility(false);
      
      searchScreen.draw();
      break;
    case 2:
      homeScreen.setVisibility(false);
      pieChartsScreen.setVisibility(false);
      searchScreen.setVisibility(false);
      barChartsScreen.setVisibility(true);
      
      barChartsScreen.draw();
      break;
    case 3:
      homeScreen.setVisibility(true);
      pieChartsScreen.setVisibility(false);
      searchScreen.setVisibility(false);
      barChartsScreen.setVisibility(false);
      
      homeScreen.draw();
      break; 
  }
}

void keyPressed() {
  // TEMPORARY: Press 'l' to switch screens
  if (!cursorBusy) {
    if (key == 'l') screenToRenderIndex = ++screenToRenderIndex % 4;
    if (key == 'k') screenToRenderIndex = 3;
  }
  
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
  homeScreen.mousePressed();
}

void mouseReleased() {
  pieChartsScreen.mouseReleased();
  homeScreen.mouseReleased();
}

void mouseWheel(MouseEvent event) {
  pieChartsScreen.mouseWheel(event);
}

void mousePressed() {
  citySearch.mousePressed();
}

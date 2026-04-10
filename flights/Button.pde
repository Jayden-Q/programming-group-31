//02/04/2026 Xianren - navbutton class for single button creation
// Navigation button class
class NavButton {
  float x, y, w, h;          
  String label;               
  int targetScreen;           
  boolean isActive;          
  color normalColor;          
  color hoverColor;           
  color activeColor;          
  boolean isHovered;          
  
  NavButton(float x, float y, float w, float h, String label, int targetScreen) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.targetScreen = targetScreen;
    this.isActive = false;

    this.normalColor = color(200);          
    this.hoverColor = color(220);            
    this.activeColor = color(100, 150, 255); 
    this.isHovered = false;
  }
  
  // Check if mouse is hovering
  void update() {
    isHovered = mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
  
  // Draw the button on screen
  void draw() {
    if (isActive) {
      fill(activeColor);      // Blue - active
    } else if (isHovered) {
      fill(hoverColor);       // Light gray - mouse hovering
    } else {
      fill(normalColor);      // Gray - normal 
    }
    
    stroke(0);    
    strokeWeight(2);
    rect(x, y, w, h);         
    
    // Draw button text
    fill(0);                   
    textAlign(CENTER, CENTER); 
    textSize(14);
    text(label, x + w/2, y + h/2);
    textAlign(LEFT);           
  }
  
  // Check if button was clicked
  boolean isPressed() {
    return isHovered && mousePressed;  
  }
  
  void setActive(boolean active) {
    this.isActive = active;
  }
}

//02/04/2026 Xianren - navgation class for multiple buttons (adding and updating)
//all buttons and screen switching
class Navigation {
  ArrayList<NavButton> buttons;  
  int currentScreen;             
  float buttonY;                
  int buttonWidth;               
  int buttonHeight;            
  float startX;                  
  
  // Constructor - creates empty navigation system
  Navigation(float startX, float buttonY, int buttonWidth, int buttonHeight) {
    this.startX = startX;
    this.buttons = new ArrayList<NavButton>();
    this.currentScreen = 0;      // Start with search city screen (1)
    this.buttonY = buttonY;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
  }
  
  // Add a new button to the navigation bar
  void addButton(String label, int targetScreen) {
    float x = startX + buttons.size() * (buttonWidth + 10);
    // Create new button
    NavButton btn = new NavButton(x, buttonY, buttonWidth, buttonHeight, label, targetScreen);
    buttons.add(btn);  
  }
  
  // Update all buttons (mouse hover)
  void update() {
    for (NavButton btn : buttons) {
      btn.update();
    }
  }
  
  // Draw all buttons 
  void draw() {
    for (NavButton btn : buttons) {
      // Highlight button if current screen
      btn.setActive(btn.targetScreen == currentScreen);
      btn.draw();
    }
  }
  
  // Check if any button was clicked 
  int checkClick() {
    for (NavButton btn : buttons) {
      if (btn.isPressed()) {
        currentScreen = btn.targetScreen;  // Switch to this button's screen
        return currentScreen;              // Return new screen number
      }
    }
    return currentScreen;  //  return current screen
  }
  
  // Get the current screen number
  int getCurrentScreen() {
    return currentScreen;
  }
  
  //Manually set the current screen
  void setCurrentScreen(int screen) {
    currentScreen = screen;
  }
}

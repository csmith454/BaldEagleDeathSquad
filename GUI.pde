class GUI {
  // font can be found here https://www.fontsquirrel.com/fonts/sh-pinscher
  // the font's license can be found here https://www.fontsquirrel.com/license/sh-pinscher
  PFont shPinscherReg;
  // start and end screen display
  String title;
  String nextLevel;
  String endLevel;
  //String highScores;
  RectButton startButton;
  //RectButton settings;
  //RectButton classSelector;
  
  // HUD display 
  String zCount;
  String oneControls;
  String twoControls;
  String threeControls;
  
  GUI() {
    textAlign(CENTER);
    shPinscherReg = createFont("SHPinscher-Regular.otf",32);
    textFont(shPinscherReg);
  }
  
  void display(int gameState) {
    if (gameState == 0) {
      // display start screen
      
    }
    else if (gameState > 0 && gameState < 10) {
      // display HUD for in-game
    }
    else if (gameState == 10) {
      // display endscreen and check if level success or fail
    }
  }
}

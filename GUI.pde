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
    
    // create strings
    title = "THE HIVE";
    credits = "BALD EAGLE DEATH SQUAD STUDIOS";
    nextLevel = "Well done.\nSelect a power-up to move to the next level.\nYou're going to need it.";
    endLevel = "Good try.\nYou'll need to do better to defeat\nTHE HIVE";
    congrats = "You beat all three levels!\nCongratulations!";
    controls = "Use WASD to navigate your player around the map.\nClick Left Mouse Button to use your selected ability.\nSelect different abilities with the '1', '2', '3'.\nKeep in mind that you will only have one ability until you beat level 1.\nUse Spacebar to DO A FLIP!";
    
    //create buttons
    level1Select = new RectButton(1.5*width/10,3*height/5,color(137,43,51),"Level 1",false,80,90);
    level2Select = new RectButton(3*width/10,3*height/5,color(242,205,71),"Level 2",true,80,90);
    level3Select = new RectButton(4.5*width/10,3*height/5,color(11,188,116),"Level 3",true,80,90);
    mute = new RectButton(4.5*width/5,0.5*height/5,color(100),"Mute",false,90,100);
    PUChoice1 = new RectButton(3*width/10,2.5*height/5,color(50,100,200),"Option 1",false,200,200);
    PUChoice2 = new RectButton(7*width/10,2.5*height/5,color(50,100,200),"Option 2",false,200,200);
    PUChoice3 = new RectButton(3*width/10,2.5*height/5,color(50,100,200),"Option 1-1",false,200,200);
    PUChoice4 = new RectButton(7*width/10,2.5*height/5,color(50,100,200),"Option 2-2",false,200,200);
    returnToMenu = new RectButton(width/2,4*height/5,color(50,100,200),"Return to main menu",false,200,250);
    controlsB = new RectButton(3.9*width/5,0.5*height/5,color(100),"Controls",false,90,100);
    
    healthBarHeight = 50;
    rectMode(CENTER);
    healthBar = createShape(RECT,0,0,5,50);
    healthBar.setStroke(0);
    healthBar.setFill(color(255,50,50));
    healthOutline = createShape(RECT,0,0,5,50);
    healthOutline.setStroke(3);
    healthOutline.setFill(color(0));
    abilityDeck = createShape(RECT,0,0,75,25);
    abilityDeck.setFill(color(214,89,76));
    rectMode(CORNER);
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

class GUI {
  // font can be found here https://www.fontsquirrel.com/fonts/sh-pinscher
  // the font's license can be found here https://www.fontsquirrel.com/license/sh-pinscher
  PFont shPinscherReg;
  // start and end screen display
  String title;
  String nextLevel;
  String endLevel;
  String credits;
  String congrats;
  
  //String highScores;
  RectButton level1Select;
  RectButton level2Select;
  RectButton level3Select;
  RectButton mute;
  RectButton PUChoice1;
  RectButton PUChoice2;
  RectButton PUChoice3;
  RectButton PUChoice4;
  RectButton returnToMenu;
  RectButton controlsB;
  
  // HUD display 
  int zCount;
  String controls;
  int startTime;
  int runTime;
  int endTime;
  PShape healthOutline;
  PShape healthBar;
  int healthBarHeight;
  PShape abilityDeck;
  
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
      background(0);
      textAlign(CENTER);
      textSize(80);
      text(title,3*width/10,2.5*height/5);
      textSize(16);
      text(credits,3*width/10,2.65*height/5);
      textSize(32);
      level1Select.display();
      level1Select.animateButton();
      level2Select.display();
      level2Select.animateButton();
      level3Select.display();
      level3Select.animateButton();
      mute.display();
      mute.animateButton();
      controlsB.display();
      controlsB.animateButton();
    }
    else if (gameState == 10) {   // success screen
      background(0);
      String endTime = getTimeFormat(runTime);
      startTime = millis();
      // display endscreen
      textAlign(CENTER);
      textSize(42);
      text(nextLevel,width/2,1*height/5);
      textSize(32);
      text("Time elapsed: ",1*width/10,0.5*height/5);
      text(endTime,2*width/10,0.5*height/5);
      // present selection for next power up
      if (level2Select.locked == true) {
        PUChoice1.display();
        PUChoice1.animateButton();
        PUChoice2.display();
        PUChoice2.animateButton();
      }
      else {
        PUChoice3.display();
        PUChoice3.animateButton();
        PUChoice4.display();
        PUChoice4.animateButton();
      }
    }
    else if (gameState == 11){        // fail screen
      background(0);
      String endTime = getTimeFormat(runTime);
      startTime = millis();
      // display endscreen
      textAlign(CENTER);
      text(zCount,width/2,1.5*height/5);
      text(endLevel,width/2,2*height/5);
      text("Time elapsed: ",1*width/10,0.5*height/5);
      text(endTime,2*width/10,0.5*height/5);
      // present button to return to main menu
      returnToMenu.display();
      returnToMenu.animateButton();
    }
    else if (gameState == 12) {    // completed all levels
      background(0);
      textSize(54);
      text(congrats,width/2,2*height/5);
      returnToMenu.display();
      returnToMenu.animateButton();
    }
    else if (gameState == 13) {    // controls explanation
      background(0);
      textSize(54);
      text(title,width/2,1*height/5);
      textSize(28);
      text(controls,width/2,2*height/5);
      returnToMenu.display();
      returnToMenu.animateButton();
    }
 }   
 
 void displayHUD(int gameState, PVector playerPos) {
   // display HUD for in-game
   if (gameState > 0 && gameState < 10) {
     runTime = millis() - startTime;
     //zCount = "Zombies left: " + str(ZombiesArray.size());
     zCount = 50;
     textAlign(LEFT);
     textSize(12);
     fill(255);
     text(zCount,-playerPos.x-120,-playerPos.y-75);
     text("Time elapsed: ",-playerPos.x-120,-playerPos.y-85);
     text(getTimeFormat(runTime),-playerPos.x-60,-playerPos.y-85);
     shape(healthOutline,-playerPos.x-120,-playerPos.y);
     shape(healthBar,-playerPos.x-120,-playerPos.y);
     
     shape(abilityDeck,-playerPos.x,-playerPos.y+75);
     // display ability icons
     
   }
 }
 String getTimeFormat(int runTime) {
    String formatted;
    String secStr = str((runTime/1000) % 60);
    String minStr = str((runTime/1000) / 60);
    
    if (secStr.length() < 2) {
      secStr = "0" + secStr;
    }
    
    formatted = minStr + ":" + secStr;
    return formatted;
  }
  
  void mousePressed() {
    if (gameState == 0) {
      if (level1Select.isPressed()) {
      gameState = 1;
      }
      else if (level2Select.isPressed()) {
        gameState = 2;
      }
      else if (level3Select.isPressed()) {
        gameState = 3;
      }  
      if (controlsB.isPressed()) {
        gameState = 13;
      }
      if (mute.isPressed()) {
      // stop sound
      }
    }
    if (gameState > 10) {
      if (returnToMenu.isPressed()) {
      gameState = 0;
      }
    }
    
    if (gameState == 10) {
      if (level2Select.locked == true) {
        if (PUChoice1.isPressed()) {
          level2Select.locked = false;
          // add new ability
          gameState = 2;
        }
        else if (PUChoice2.isPressed()) {
          level2Select.locked = false;
          // add new ability
          gameState = 2;
        }
      }
      else {
        if (PUChoice3.isPressed()) {
          level3Select.locked = false;
          // add new ability
          gameState = 3;
        }  
        else if (PUChoice4.isPressed()) {
          level3Select.locked = false;
          // add new ability
          gameState = 3;
        }
      }
    }
  }
}

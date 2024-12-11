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
  PShape textBox;
  
  RectButton begin;
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
  String zCount;
  String controls;
  int startTime;
  int runTime;
  int endTime1;
  int endTime2;
  int endTime3;
  int totalTime;
  PShape healthOutline;
  PShape healthBar;
  float healthBarHeight;
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
    congrats = "You beat all three levels.\nWe're quite impressed.";
    controls = "Use WASD to navigate your player around the map.\nClick Left Mouse Button to use your selected ability.\nSelect different abilities with '1', '2', '3'.\nKeep in mind that you will only have one ability until you beat level 1.\nUse Spacebar to DO A FLIP!";
    
    //create buttons
    begin = new RectButton(3*width/10,3*height/5,color(137,43,51),"Click to try your luck.",80,300);
    mute = new RectButton(4.5*width/5,0.5*height/5,color(100),"Mute",90,100);
    PUChoice1 = new RectButton(3*width/10,2.5*height/5,color(50,100,200),"Option 1",200,200);
    PUChoice2 = new RectButton(7*width/10,2.5*height/5,color(50,100,200),"Option 2",200,200);
    PUChoice3 = new RectButton(3*width/10,2.5*height/5,color(50,100,200),"Option 1-1",200,200);
    PUChoice4 = new RectButton(7*width/10,2.5*height/5,color(50,100,200),"Option 2-2",200,200);
    returnToMenu = new RectButton(width/2,4*height/5,color(50,100,200),"Return to main menu",200,250);
    controlsB = new RectButton(3.9*width/5,0.5*height/5,color(100),"Controls",90,100);
    
    // height must be connected to player health in final
    rectMode(CENTER);
    healthOutline = createShape(RECT,0,0,5,50);
    healthOutline.setStroke(color(0));
    healthOutline.setFill(color(255));
    abilityDeck = createShape(RECT,0,0,75,25);
    abilityDeck.setFill(color(214,89,76));
    textBox = createShape(RECT,0,0,100,50);
    textBox.setFill(color(255));
    textBox.setStroke(color(200));
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
      begin.display();
      begin.animateButton();
      mute.display();
      mute.animateButton();
      controlsB.display();
      controlsB.animateButton();
    }
    else if (gameState == 10) {   // first progression; to second level
      background(0);
      String endTime = getTimeFormat(runTime);
      endTime1 = runTime;
      startTime = millis();
      // display endscreen
      textAlign(CENTER);
      textSize(42);
      fill(255);
      text(nextLevel,width/2,1*height/5);
      textSize(32);
      text("Time elapsed: ",1*width/10,0.5*height/5);
      text(endTime,2*width/10,0.5*height/5);
        PUChoice1.display();
        PUChoice1.animateButton();
        PUChoice2.display();
        PUChoice2.animateButton();
    }
    else if (gameState == 11) {    // second progression; to third level
      background(0);
      String endTime = getTimeFormat(runTime);
      endTime2 = runTime;
      startTime = millis();
      // display endscreen
      textAlign(CENTER);
      textSize(42);
      fill(255);
      text(nextLevel,width/2,1*height/5);
      textSize(32);
      text("Time elapsed: ",1*width/10,0.5*height/5);
      text(endTime,2*width/10,0.5*height/5);
      // present selection for next power up
        PUChoice3.display();
        PUChoice3.animateButton();
        PUChoice4.display();
        PUChoice4.animateButton();
    }
    else if (gameState == 12){        // fail screen
      background(0);
      String endTime = getTimeFormat(runTime);
      startTime = millis();
      // display endscreen
      textAlign(CENTER);
      fill(255);
      text(zCount,width/2,1.5*height/5);
      text(endLevel,width/2,2*height/5);
      text("Time elapsed: ",1*width/10,0.5*height/5);
      text(endTime,2*width/10,0.5*height/5);
      // present button to return to main menu
      returnToMenu.display();
      returnToMenu.animateButton();
    }
    else if (gameState == 20) {    // completed all levels
      background(0);
      textAlign(CENTER);
      textSize(54);
      fill(255);
      text(congrats,width/2,1*height/5);
      textSize(28);
      endTime3 = runTime;
      // display textbox to type in 
      shape(textBox,width/2,2.5*height/5);
      text(hs.enterInitials,width/2,2.5*height/5-40);
      textSize(15);
      text(hs.pressEnter, width/2,2.5*height/5+50);
      fill(0);
      textSize(28);
      text(hs.contents.toUpperCase(),width/2,2.5*height/5+5);
      
      // display time
      totalTime = endTime1 + endTime2 + endTime3;
      fill(255);
      text(getTimeFormat(totalTime),width/2,2*height/5);

      returnToMenu.display();
      returnToMenu.animateButton();
    }
    else if (gameState == 13) {    // controls explanation
      background(0);
      textSize(54);
      fill(255);
      text(title,width/2,1*height/5);
      textSize(28);
      text(controls,width/2,2*height/5);
      returnToMenu.display();
      returnToMenu.animateButton();
    }
 }   
 
 void displayHUD(int gameState, PVector playerPos, float playerHealth) {
   // display HUD for in-game
   if (gameState > 0 && gameState < 10) {
     runTime = millis() - startTime;
     zCount = "Zombies left: " + str(countZombiesAlive());
     textAlign(LEFT);
     textSize(12);
     fill(255);
     text(zCount,-playerPos.x-120,-playerPos.y-75);
     text("Time elapsed: ",-playerPos.x-120,-playerPos.y-85);
     text(getTimeFormat(runTime),-playerPos.x-60,-playerPos.y-85);
     shape(healthOutline,-playerPos.x-120,-playerPos.y);
     healthBarHeight = playerHealth/2;
     rectMode(CENTER);
     healthBar = createShape(RECT,0,0,5,healthBarHeight);    // pass in player health to .displayHUD and normalize to height of healthbar
     healthBar.setStroke(color(0));
     healthBar.setFill(color(255,50,50));
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
      if (begin.isPressed()) {
      gameState = 1;
      }
      else if (controlsB.isPressed()) {
        gameState = 13;
      }
      else if (mute.isPressed()) {
      // stop sound
      }
    }
    else if (gameState == 12 || gameState == 13 || gameState == 20) {
      if (returnToMenu.isPressed()) {
        gameState = 0;
      }
    }
    else if (gameState == 10) {
      if (PUChoice1.isPressed()) {
        // add new ability
        gameState = 2;
      }
      else if (PUChoice2.isPressed()) {
        // add new ability
        gameState = 2;
      }
    }  
    else if (gameState == 11) {
      if (PUChoice3.isPressed()) {
        // add new ability
        gameState = 3;
      }  
      else if (PUChoice4.isPressed()) {
        // add new ability
        gameState = 3;
      }
    }
  }
}

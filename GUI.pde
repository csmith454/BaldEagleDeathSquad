class GUI {
  // font can be found here https://www.fontsquirrel.com/fonts/sh-pinscher
  // the font's license can be found here https://www.fontsquirrel.com/license/sh-pinscher
  PFont shPinscherReg;
  // start and end screen display
  String title;
  String nextLevel;
  String endLevel;
  String credits;
  //String highScores;
  RectButton level1Select;
  RectButton level2Select;
  RectButton level3Select;
  RectButton mute;
  RectButton PUChoice1;
  RectButton PUChoice2;
  RectButton PUChoice3;
  RectButton PUChoice4;
  
  // HUD display 
  int zCount;
  String oneControls;
  String twoControls;
  String threeControls;
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
    
    //create buttons
    level1Select = new RectButton(1*width/5,3*height/5,color(137,43,51),"Level 1",false,75,100);
    level2Select = new RectButton(1.5*width/5,3*height/5,color(242,205,71),"Level 2",true,75,100);
    level3Select = new RectButton(2*width/5,3*height/5,color(11,188,116),"Level 3",true,75,100);
    
    healthBarHeight = 50;
    rectMode(CENTER);
    healthBar = createShape(RECT,0,0,5,50);
    healthBar.setStroke(0);
    healthBar.setFill(color(255,50,50));
    healthOutline = createShape(RECT,0,0,5,50);
    healthOutline.setStroke(3);
    healthOutline.setFill(color(0));
    abilityDeck = createShape(RECT,0,0,60,30);
    abilityDeck.setFill(color(214,89,76));
    
  }
  
  void display(int gameState) {
    if (gameState == 0) {
      // display start screen
      background(0);
      textAlign(CENTER);
      textSize(80);
      text(title,width/4,2.5*height/5);
      textSize(16);
      text(credits,width/4,2.65*height/5);
      textSize(32);
      level1Select.display();
      level1Select.animateButton();
      level2Select.display();
      level2Select.animateButton();
      level3Select.display();
      level3Select.animateButton();
      
      // display scores
      
    }
    else if (gameState == 10) {        // success screen
      String endTime = getTimeFormat(runTime);
      startTime = millis();
      // display endscreen
      textAlign(CENTER);
      textSize(42);
      text(nextLevel,width/4,2.25*height/5);
      textSize(32);
      text("Time elapsed",width/4,2.5*height/5);
      text(endTime,width/4+50,2.5*height/5);
      // present selection for next power up
      
    }
    else if (gameState == 11){        // fail screen
      String endTime = getTimeFormat(runTime);
      startTime = millis();
      // display endscreen
      textAlign(CENTER);
      text("Time elapse",width/2,height/2+30);
      text(endTime,width/2,height/2+50);
      //present button to return to main menu
      
    }
 }   
 
 void displayHUD(int gameState, PVector playerPos) {
   // display HUD for in-game
   if (gameState > 0 && gameState < 10) {
     runTime = millis() - startTime;
     //zCount = "Zombies left: " + str(ZombiesArray.size());
     zCount = 50;
     textAlign(LEFT);
     textSize(16);
     fill(255);
     text(zCount,-playerPos.x-195,-playerPos.y-75);
     text("Time elapsed: ",-playerPos.x-85,-playerPos.y-85);
     text(getTimeFormat(runTime),-playerPos.x-10,-playerPos.y-85);
     shape(healthOutline,-playerPos.x-195,-playerPos.y-40);
     shape(healthBar,-playerPos.x-195,-playerPos.y-40);
     
     shape(abilityDeck,-playerPos.x-25,-playerPos.y+75);
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
}

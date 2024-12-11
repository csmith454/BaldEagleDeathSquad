class GUI {
  // font can be found here https://www.fontsquirrel.com/fonts/sh-pinscher
  // the font's license can be found here https://www.fontsquirrel.com/license/sh-pinscher
  PFont shPinscherReg;
  // start and end screen display
  String title;
  String PU1;
  String PU2;
  String PU3;
  String PU4;
  String PU5;
  String PU6;
  String PU7;
  String PU8;
  String PU9;
  String[] deck1 = {"Sword","Spikes","Bow"};
  String[] deck2 = {"Speed+","Slow\nField","Flip"};
  String[] deck3 = {"Bazooka","Box","FRD"};
  String ability1;
  String ability2;
  String ability3;
  String initialChoice;
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
  RectButton PUChoice5;
  RectButton PUChoice6;
  RectButton PUChoice7;
  RectButton PUChoice8;
  RectButton PUChoice9;
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
    initialChoice = "Select your first weapon\nand prepare for the worst.";
    endLevel = "Good try.\nYou'll need to do better to defeat\nTHE HIVE";
    congrats = "You beat all three levels.\nWe're quite impressed.";
    controls = "Use WASD to navigate your player around the map.\nClick Left Mouse Button to use your selected ability.\nSelect different abilities with '1' and '2'.\nKeep in mind that you will only have one ability until you beat level 1.\nUse Spacebar to activate your passive ability if chosen";
    PU1 = "Guts' Sword\nHow did that\nget here?";
    PU2 = "Placeable Spikes\nThe zombies won't\nknow what hit\nthem.";
    PU3 = "Bow + Arrow\nChannel your inner\nLegolas.";
    PU4 = "Roller Blades\nYou're going to\nbe fast now!";
    PU5 = "Slowness Field\nSome eldritch magic\nthat will slow \ndown zombies around you.";
    PU6 = "DO A FLIP!\nSelf explanatory?";
    PU7 = "Bazooka\nReally take out\nyour anger.";
    PU8 = "Placable boxes\nBlock those\npesky zombies.";
    PU9 = "Fus Ro Dah\nWait do we have\nto pay for the\nrights to this? ";
    ability1 = "'1'\n";
    ability2 = "'2'\n";
    ability3 = "'Spacebar'\n";
    
    //create buttons
    begin = new RectButton(3*width/10,3*height/5,color(137,43,51),"Click to try your luck.",80,300);
    mute = new RectButton(4.5*width/5,0.5*height/5,color(100),"Mute",90,100);
    PUChoice1 = new RectButton(2*width/10,2.5*height/5,color(50,100,200),PU1,250,250);
    PUChoice2 = new RectButton(5*width/10,2.5*height/5,color(50,100,200),PU2,250,250);
    PUChoice3 = new RectButton(8*width/10,2.5*height/5,color(50,100,200),PU3,250,250);
    PUChoice4 = new RectButton(2*width/10,2.5*height/5,color(50,100,200),PU4,250,250);
    PUChoice5 = new RectButton(5*width/10,2.5*height/5,color(50,100,200),PU5,250,250);
    PUChoice6 = new RectButton(8*width/10,2.5*height/5,color(50,100,200),PU6,250,250);
    PUChoice7 = new RectButton(2*width/10,2.5*height/5,color(50,100,200),PU7,250,250);
    PUChoice8 = new RectButton(5*width/10,2.5*height/5,color(50,100,200),PU8,250,250);
    PUChoice9 = new RectButton(8*width/10,2.5*height/5,color(50,100,200),PU9,250,250);
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
    else if (gameState == 9) {
      background(0);
      textAlign(CENTER);
      textSize(42);
      fill(255);
      text(initialChoice,width/2,1*height/5);
      textSize(32);
      PUChoice1.display();
      PUChoice1.animateButton();
      PUChoice2.display();
      PUChoice2.animateButton();
      PUChoice3.display();
      PUChoice3.animateButton();
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
      PUChoice4.display();
      PUChoice4.animateButton();
      PUChoice5.display();
      PUChoice5.animateButton();
      PUChoice6.display();
      PUChoice6.animateButton();
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
      PUChoice7.display();
      PUChoice7.animateButton();
      PUChoice8.display();
      PUChoice8.animateButton();
      PUChoice9.display();
      PUChoice9.animateButton();
    }
    else if (gameState == 12){        // fail screen
      background(0);
      String endTime = getTimeFormat(runTime);
      startTime = millis();
      // display endscreen
      textAlign(CENTER);
      fill(255);
      textSize(42);
      text(zCount,width/2,1.5*height/5);
      text(endLevel,width/2,2*height/5);
      textSize(32);
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
     
     for (int i = deck1.length; i > 0 ;i--) {
       if (player.abilities[i+5] == true && gameState == 3) {
         ability3+=deck3[i];
         break;
       }
       if (player.abilities[i+2] == true && gameState == 2) {
         ability2+=deck2[i];
         break;
       }
       if (player.abilities[i] == true && gameState == 1) {
         ability1+=deck1[i];
         break;
       }
     }
     textSize(9);
     text(ability1,-playerPos.x-35,-playerPos.y+70);
     text(ability2,-playerPos.x-15,-playerPos.y+70);
     text(ability3,-playerPos.x+5,-playerPos.y+70);
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
        gameState = 9;
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
    else if (gameState == 9) {    
      if (PUChoice1.isPressed()) {
        player.abilities[0] = true;
        gameState = 1;
      }
      else if (PUChoice2.isPressed()) {
        player.abilities[1] = true;
        gameState = 1;
      }
      else if (PUChoice3.isPressed()) {
        player.abilities[2] = true;
        gameState = 1;
      }
    }
    else if (gameState == 10) {
      if (PUChoice4.isPressed()) {
        player.abilities[3] = true;
        gameState = 2;
      }
      else if (PUChoice5.isPressed()) {
        player.abilities[4] = true;
        gameState = 2;
      }
      else if (PUChoice6.isPressed()) {
        player.abilities[5] = true;
        gameState = 2;
      }
    }  
    else if (gameState == 11) {
      if (PUChoice7.isPressed()) {
        player.abilities[6] = true;
        gameState = 3;
      }  
      else if (PUChoice8.isPressed()) {
        player.abilities[7] = true;
        gameState = 3;
      }
      else if (PUChoice9.isPressed()) {
        player.abilities[8] = true;
        gameState = 3;
      }
    }
  }
}

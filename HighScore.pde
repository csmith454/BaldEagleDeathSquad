class HighScore {
  ArrayList<String> keys;
  ArrayList<String> values;
  String instructions;
  String title;
  String initials;
  String time;
  String contents;
  String enterInitials;
  String pressEnter;
  boolean pressed;
  boolean canType;
  PShape leaderboard;
  
  HighScore(ArrayList<String> keys, ArrayList<String> values) {
    this.keys = keys;
    this.values = values;
    this.instructions = "";
    this.title = "Highscores";
    this.initials = "Initials";
    this.time = "Time elapsed";
    this.enterInitials = "Press 't' to enter your initials.";
    this.pressEnter = "Press 'Enter' or 'Return' to save your time.";
    this.contents = "";
    rectMode(CENTER);
    leaderboard = createShape(RECT,0,0,width/3,height/2);
    leaderboard.setFill(color(50,100,200));
  }
  
  void display(int gameState) {
    if (gameState == 0) {
      float x = 7.5*width/10;
      float y = 2*height/5;
      // use records to write out to screen
      shape(leaderboard,7.5*width/10,height/2);
      textSize(36);
      text(title,7.5*width/10,1.5*height/5);
      textSize(24);
      for (int i = 0; i < keys.size(); i++) {
        String rec = keys.get(i) + "    " + values.get(i);
        text(rec,x,y);
        y+=25;
      }
    }
  }
  
  void addNew(String formattedTime) {
    // add to files
    keys.add(contents.toUpperCase());
    values.add(formattedTime);
    String[] initials = new String[keys.size()];
    String[] scores = new String[values.size()];
    for (int i = 0; i < keys.size(); i++) {
        initials[i] = keys.get(i);
        scores[i] = values.get(i);
    }
    saveStrings("data/initials.txt",initials);
    saveStrings("data/scores.txt",scores);
  }
  
  void keyPressed() {
    if (pressed == false) {
      if (key == 't') {
        canType = true;
      }
      if (canType) {
        if(key == BACKSPACE || key == DELETE){
          contents = "";
        }
        else if (key == ENTER || key == RETURN) {
          addNew(g.getTimeFormat(g.totalTime));
        }
        if (contents.length() < 4) {
          contents+=key;
        }
      }
      pressed = true;
    }
  }
  void keyReleased() {
    if (pressed == true) {
      pressed = false;
    }
  }
}

class HighScore {
  StringDict records;
  String instructions;
  String title;
  String initials;
  String time;
  PShape leaderboard;
  
  HighScore(String[] keys, String[] values) {
    this.records = new StringDict();
    for (int i = 0; i < keys.length; i++) {
      records.set(keys[i],values[i]);
    }
    this.instructions = "";
    this.title = "Highscores";
    this.initials = "Initials";
    this.time = "Time elapsed";
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
      for (String k : records.keys()) {
        String rec = k + "     " +records.get(k);
        text(rec,x,y);
        y+=25;
      }
    }
  }
  
  void displayTyper() {
    //text(contents,-100,-100);
  }
  
  void addNew() {
    String contents = "";
    keyPressed(contents);
    // add contents to dictionaries
    
  }
  
  void keyPressed(String contents) {
    // remove last added key 
    //if () {
      
    //}
    if(key == BACKSPACE || key == DELETE){
      contents = contents.substring(0,contents.length() - 1);
      
    contents+=key;
    }
  }
}

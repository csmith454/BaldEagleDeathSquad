class Player {
  // Animation
  int numFrames = 4;
  float animLength = 1;
  
  // Sprites
  int pixelSize = 100;
  PImage[] front_sprite = new PImage[numFrames];
  PImage[] back_sprite = new PImage[numFrames];
  PImage[] side_sprite = new PImage[numFrames];
  PImage rocketLauncher_sprite;
  PImage rocket_sprite;
  PImage sword_sprite;
  
  // Character
  PVector pos = new PVector(0,0);
  boolean[] abilities = new boolean[9];
  boolean firstEquipped = false;
  float timer1 = 5.0;
  float timer2 = 5.0;
  float timer3 = 5.0;
  float timer1Max = 0.0;
  float timer2Max = 0.0;
  float timer3Max = 0.0;
  float swordTimer = 1.0;
  float spikeTimer = 0.7;
  float bowPullback = 0.5;
  float boostTimer = 3.0;
  float slowTimer = 5.0;
  float jumpTimer = 1.0;
  float rocketTimer = 2.0;
  float blockTimer = 2.5;
  float blockCount = 3;
  float windAmount = 100;
  
  
  // Inputs
  boolean [] inputBuffer = new boolean[6];
  String direction = "down";
  boolean idle = true;
  boolean left = false;
  
  // States
  StateMachine stateMachine;
  
  // Other Entitites
  ArrayList<Rocket> rockets;
  
  Player(ArrayList<Rocket> rockets) {
    this.rockets = rockets;
    stateMachine = new StateMachine();
    for (int i = 0; i < abilities.length; i++) {
      abilities[i] = true; // Currently set to true for testing purposes, later set it to false when abiliies become unlockable.
    }
    
    // STATES
    Moving moving = new Moving();
    Dash dash = new Dash();
    
    // TRANSITIONS
    stateMachine.at(moving, dash, () -> moving.toDash());
    stateMachine.at(dash,moving, () -> dash.toMoving());
    
    // START STATE
    stateMachine.setState(moving);
  }
  
  void update() {
    pushMatrix();
    stateMachine.tick();
    popMatrix();
    if (timer1 < timer1Max) {
      timer1 += 1.0/frameRate;
    }
    if (timer2 < timer2Max) {
      timer2 += 1.0/frameRate;
    }
    if (timer3 < timer3Max) {
      timer3 += 1.0/frameRate;
    }
  }
  
  void keyPressed() {
    if (key == 'w' || key == 'W') {
      this.inputBuffer[0] = true;
    }
    else if (key == 's' || key == 'S') {
      this.inputBuffer[1] = true;
    }
    else if (key == 'a' || key == 'A') {
      this.inputBuffer[2] = true;
    }
    else if (key == 'd' || key == 'D') {
      this.inputBuffer[3] = true;
    }
    else if (key == ' ') {
      this.inputBuffer[4] = true;
    }
    else if (key == '1') {
      this.firstEquipped = true;
    }
    else if (key == '2') {
      this.firstEquipped = false;
    }
  }
  
  void keyReleased() {
    if (key == 'w' || key == 'W') {
      this.inputBuffer[0] = false;
    }
    if (key == 's' || key == 'S') {
      this.inputBuffer[1] = false;
    }
    if (key == 'a' || key == 'A') {
      this.inputBuffer[2] = false;
    }
    if (key == 'd' || key == 'D') {
      this.inputBuffer[3] = false;
    }
    if (key == ' ') {
      this.inputBuffer[4] = false;
    }
  }
  
  void mousePressed() {
    this.inputBuffer[5] = true;
  }
  
  void mouseReleased() {
    this.inputBuffer[5] = false;
  }
}

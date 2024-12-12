class Player {
  boolean spike;
  // Animation
  int numFrames = 4;
  float animLength = 1;
  float[] matrix;
  
  // Sprites
  int pixelSize = 32;
  PImage[] front_sprite = new PImage[numFrames];
  PImage[] back_sprite = new PImage[numFrames];
  PImage[] side_sprite = new PImage[numFrames];
  PImage[] front_sprite_I = new PImage[numFrames];
  PImage[] back_sprite_I = new PImage[numFrames];
  PImage[] side_sprite_I = new PImage[numFrames];
  PImage rocketLauncher_sprite;
  PImage rocket_sprite;
  PImage[] explosion_sprite = new PImage[4];
  PImage sword_sprite;
  PImage spike_sprite;
  PImage[] bow_sprite = new PImage[3];
  PImage arrow_sprite;
  PImage box_sprite;
  PImage[] wind_sprite = new PImage[2];
  
  // Character
  float health = 100;
  float speed = 2;
  boolean isFast = false;
  PVector pos = new PVector(0,0);
  PVector vel = new PVector(0,0);
  PVector acel = new PVector(0,0);
  float acelModifier = 4;
  int diagonal = 0;
  float size = 14;
  PVector hitBoxPos = new PVector(0,0);
  float hitBoxSize = 20;
  PVector hitstunDirection;
  float knockback;
  boolean[] abilities = new boolean[9];
  boolean isDashing = false;
  boolean ability2Cooldown = false;
  boolean ability3Cooldown = false;
  boolean firstEquipped = true;
  boolean damaged = false;
  boolean invincible = false;
  float invincibleTimer = 0.0;
  float timer1 = 5.0;
  float timer2 = 5.0;
  float timer3 = 5.0;
  float timer1Max = 0.0;
  float timer2Max = 0.0;
  float timer3Max = 0.0;
  float swordTimer = 0.7;
  float swordDamage = 30;
  float spikeTimer = 1.5;
  float bowPullback = 2.0;
  float boostTimer = 3.0;
  float slowTimer = 5.0;
  float jumpTimer = 1.0;
  float jumpInternalTimer = 0.0;
  float jumpInternalSeconds = 0.5;
  float rocketTimer = 2.0;
  float blockTimer = 2.5;
  int blockCount = 3;
  float windAmount = 2.5;
  
  
  // Inputs
  boolean [] inputBuffer = new boolean[6];
  String direction = "down";
  boolean idle = true;
  boolean left = false;
  
  // States
  StateMachine stateMachine;
  
  // Other Entitites
  ArrayList<Rocket> rockets;
  ArrayList<Spike> spikes;
  ArrayList<Arrow> arrows;
  
  Player(float[] matrix, ArrayList<Rocket> rockets, ArrayList<Spike> spikes, ArrayList<Arrow> arrows) {
    this.rockets = rockets;
    this.spikes = spikes;
    this.arrows = arrows;
    stateMachine = new StateMachine();
    for (int i = 0; i < abilities.length; i++) {
      abilities[i] = false; // Currently set to true for testing purposes, later set it to false when abilities become unlockable.
    }
    this.matrix = matrix;
    
    // STATES
    Moving moving = new Moving(hitBoxSize);
    Dash dash = new Dash();
    Hitstun hitstun = new Hitstun();
    
    // TRANSITIONS
    stateMachine.at(moving, dash, () -> moving.toDash());
    stateMachine.at(moving, hitstun, () -> moving.toHitstun());
    stateMachine.at(hitstun, moving, () -> hitstun.toMoving());
    stateMachine.at(dash,moving, () -> dash.toMoving());
    
    // START STATE
    stateMachine.setState(moving);
  }
  
  void update() {
    println(pos);
    pushMatrix();
    stateMachine.tick();
    popMatrix();
    
    // Handle invincibility
    if (invincibleTimer >= 0.0) {
      invincibleTimer -= 1/frameRate;
    }
    else {
      invincible = false;
    }
    
    // deceleration
    if (vel.x >= 0.1) {
      vel.x -= player.pixelSize * player.speed/frameRate/player.acelModifier/2;
    }
    else if (vel.x <= -0.1) {
      vel.x += player.pixelSize * player.speed/frameRate/player.acelModifier/2;
    }
    else {
      vel.x = 0;
    }
    if (vel.y >= 0.1) {
      vel.y -= player.pixelSize * player.speed/frameRate/player.acelModifier/2;
    }
    else if (vel.y <= -0.1) {
      vel.y += player.pixelSize * player.speed/frameRate/player.acelModifier/2;
    }
    else {
      vel.y = 0;
    }
    
    float change = pixelSize * speed/frameRate;
    if (diagonal >= 2) { // If the player is moving diagonally, cut speed for each direction.
        change /= 1.41421356237;
    }
    
    if (isFast) {
      change *= 2;
    }
    vel.x = constrain(vel.x + acel.x,-change,change);
    vel.y = constrain(vel.y + acel.y,-change,change);
    pos.add(vel);
    
    timer1 = constrain(timer1 + 1.0/frameRate, 0, timer1Max);
    timer2 = constrain(timer2 + 1.0/frameRate, 0, timer2Max);
    timer3 = constrain(timer3 + 1.0/frameRate, 0, timer3Max);
    
    if (showHitbox) {
      noFill();
      stroke(255);
      ellipse(-pos.x,-pos.y,size,size); // Hurtbox
      ellipse(hitBoxPos.x,hitBoxPos.y,hitBoxSize,hitBoxSize); //Hitbox
    }
    
    // Particles if boosting
    if (isFast) {
      if (frameCount % (int(frameRate/7)) == 0) {
        particles.add(new Particle(new PVector(-pos.x + random(-10,10),-pos.y + random(-10,10)), new PVector(0,0)));
      }
    }
  }
  
  void updatePos(PVector pos) {
    this.pos.x = pos.x;
    this.pos.y = pos.y;
  }
  
  boolean check_collision_sphere(PVector otherPos, float otherSize) {
    float dist = this.pos.dist(otherPos);
    if (dist <= this.size + otherSize) {
      return true;
    }
    return false;
  }
  
  boolean check_collision_square(PVector otherPos, PVector otherSize) {
    float deltaX = Math.abs(-this.pos.x - otherPos.x);
    float deltaY = Math.abs(-this.pos.y - otherPos.y);
    if (deltaX < (this.size/2 + otherSize.x/2) && deltaY < (this.size/2 + otherSize.y/2)) {
    return true;
  }
    return false;
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
    if (key == 'p' || key == 'P') {
      this.spike = !spike;
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
  
  float[] multMatrix(float[] m1, float[] m2) {
    int size = int(sqrt(m1.length));
    float[] returnMatrix;
    returnMatrix = new float[size*size];
    for (int row = 0; row < size; row++) {
      for (int column = 0; column < size; column++) {
        float total = 0;
        for (int i = 0; i < size; i++) {
          total += m1[row*size + i] * m2[i * size + column];
        }
        returnMatrix[row*size + column] = total;
      }
    }
    return returnMatrix;
  }
}

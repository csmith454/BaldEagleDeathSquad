class Dash implements State {
  boolean [] dashBuffer;;
  float timer = 0.0;
  float seconds = 0.5;
  
  Dash() {
    
  }
  
  void onEnter() {
    timer = 0.0;
    dashBuffer = new boolean[player.inputBuffer.length];
    if (player.inputBuffer != null) {
      System.arraycopy(player.inputBuffer, 0, dashBuffer, 0, player.inputBuffer.length);
    }
  }
  
  void onExit() {
  
  }
  
  void tick() {
    fill(100);
    stroke(100);
    ellipse(-player.pos.x,-player.pos.y,player.pixelSize*0.35,player.pixelSize*0.35);
    timer += 1/frameRate;
    int diagonal = 0;
    PVector change = new PVector(0,0);
    if (this.dashBuffer[2]) {
      change.x += player.pixelSize*2.5/frameRate;
      diagonal += 1;
    }
    if (this.dashBuffer[3]) {
      change.x -= player.pixelSize*2.5/frameRate;
      diagonal += 1;
    }
    if (this.dashBuffer[0]) {
      change.y += player.pixelSize*2.5/frameRate;
      diagonal += 1;
    }
    if (this.dashBuffer[1]) {
      change.y -= player.pixelSize*2.5/frameRate;
      diagonal += 1;
    }
    if (diagonal >= 2) {
      if (change.x != 0) {
        change.x /= 1.41421356237;
      }
      if (change.y != 0) {
        change.y /= 1.41421356237;
      }
    }
    player.pos.add(change);
    float xPos = -player.pos.x;
    pushMatrix();
    if (player.left) {
      scale(-1,1);
      xPos *= -1;
    }
    
    float jump_height = 0;
    float progress = (timer/seconds) * PI;
    if (progress < 0.41792 || progress > 2.72044) {
      jump_height = player.pixelSize/2 * 1.7 * sin(progress);
    }
    else {
      jump_height = player.pixelSize/2 * sin(0.7 * progress + PI/6.7);
    }
    
    translate(xPos-player.pixelSize/2,-player.pos.y-player.pixelSize*0.8 - jump_height);
    rotate(radians(90*int(timer/(seconds/4))));
    if (int(timer/(seconds/4)) == 1) {
      translate(0,-player.pixelSize);
    }
    else if (int(timer/(seconds/4)) == 2) {
      translate(-player.pixelSize,-player.pixelSize);
    }
    else if (int(timer/(seconds/4)) == 3) {
      translate(-player.pixelSize,0);
    }
    if (player.direction == "down") {
      image(player.front_sprite[0],0,0,player.pixelSize,player.pixelSize);
    }
    else if (player.direction == "up") {
      image(player.back_sprite[0], 0,0,player.pixelSize,player.pixelSize);
    }
    else if (player.direction == "side") {
      image(player.side_sprite[0], 0,0,player.pixelSize,player.pixelSize);
    }
    popMatrix();
  }
  
  Boolean toMoving() {
    if (timer >= seconds) {
      return true;
    }
    return false;
  }
}

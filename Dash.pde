class Dash implements State {
  boolean [] dashBuffer;;
  float speedStorage;
  
  Dash() {
    
  }
  
  void onEnter() {
    player.jumpInternalTimer = 0.0;
    dashBuffer = new boolean[player.inputBuffer.length];
    if (player.inputBuffer != null) {
      System.arraycopy(player.inputBuffer, 0, dashBuffer, 0, player.inputBuffer.length);
    }
    speedStorage = player.speed;
    player.speed *= 1.5;
    player.isDashing = true;
  }
  
  void onExit() {
    player.speed = speedStorage;
    player.isDashing = false;
  }
  
  void tick() {
    fill(100);
    stroke(100);
    ellipse(-player.pos.x,-player.pos.y,player.pixelSize*0.35,player.pixelSize*0.35);
    player.jumpInternalTimer += 1/frameRate;
    player.diagonal = 0;
    PVector change = new PVector(0,0);
    if (this.dashBuffer[2]) {
      change.x += player.pixelSize*player.speed/frameRate/player.acelModifier;
      player.diagonal += 1;
    }
    if (this.dashBuffer[3]) {
      change.x -= player.pixelSize*player.speed/frameRate/player.acelModifier;
      player.diagonal += 1;
    }
    if (this.dashBuffer[0]) {
      change.y += player.pixelSize*player.speed/frameRate/player.acelModifier;
      player.diagonal += 1;
    }
    if (this.dashBuffer[1]) {
      change.y -= player.pixelSize*player.speed/frameRate/player.acelModifier;
      player.diagonal += 1;
    }
    player.acel = (change);
   
    float xPos = -player.pos.x;
    pushMatrix();
    if (player.left) {
      scale(-1,1);
      xPos *= -1;
    }
    
    float jump_height = 0;
    float progress = (player.jumpInternalTimer/player.jumpInternalSeconds) * PI;
    if (progress < 0.41792 || progress > 2.72044) {
      jump_height = player.pixelSize/2 * 1.7 * sin(progress);
    }
    else {
      jump_height = player.pixelSize/2 * sin(0.7 * progress + PI/6.7);
    }
    
    translate(xPos-player.pixelSize/2,-player.pos.y-player.pixelSize*0.8 - jump_height);
    rotate(radians(90*int(player.jumpInternalTimer/(player.jumpInternalSeconds/4))));
    if (int(player.jumpInternalTimer/(player.jumpInternalSeconds/4)) == 1) {
      translate(0,-player.pixelSize);
    }
    else if (int(player.jumpInternalTimer/(player.jumpInternalSeconds/4)) == 2) {
      translate(-player.pixelSize,-player.pixelSize);
    }
    else if (int(player.jumpInternalTimer/(player.jumpInternalSeconds/4)) == 3) {
      translate(-player.pixelSize,0);
    }
    if (player.direction == "down") {
      if (!player.invincible) {
        image(player.front_sprite[0],0,0,player.pixelSize,player.pixelSize);
      }
      else {
        image(player.front_sprite_I[0],0,0,player.pixelSize,player.pixelSize);
      }
    }
    else if (player.direction == "up") {
      if (!player.invincible) {
        image(player.back_sprite[0], 0,0,player.pixelSize,player.pixelSize);
      }
      else {
        image(player.front_sprite_I[0],0,0,player.pixelSize,player.pixelSize);
      }
    }
    else if (player.direction == "side") {
      if (!player.invincible) {
        image(player.side_sprite[0], 0,0,player.pixelSize,player.pixelSize);
      }
      else {
        image(player.front_sprite_I[0],0,0,player.pixelSize,player.pixelSize);
      }
    }
    popMatrix();
  }
  
  Boolean toMoving() {
    if (player.jumpInternalTimer >= player.jumpInternalSeconds) {
      return true;
    }
    return false;
  }
}

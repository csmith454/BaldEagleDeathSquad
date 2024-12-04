class Moving implements State {
  float degree = 0;
  float hitBoxSize_Store;
  
  Moving(float hitBoxSize) {
    hitBoxSize_Store = hitBoxSize;
  }
  
  void onEnter() {
  
  }
  
  void onExit() {
  
  }
  
  void tick() {
    
    // Handles player movement
    player.idle = true;
    int diagonal = 0;
    PVector change = new PVector(0,0);
    if (player.inputBuffer[2]) {
      change.x += player.pixelSize/frameRate;
      player.direction = "side";
      player.idle = false;
      player.left = true;
      diagonal += 1;
    }
    if (player.inputBuffer[3]) {
      change.x += -player.pixelSize/frameRate;
      player.direction = "side";
      player.idle = false;
      player.left = false;
      diagonal += 1;
    }
    if (player.inputBuffer[0]) {
      change.y += player.pixelSize/frameRate;
      player.direction = "up";
      player.idle = false;
      diagonal += 1;
    }
    if (player.inputBuffer[1]) {
      change.y += -player.pixelSize/frameRate;
      player.direction = "down";
      player.idle = false;
      diagonal += 1;
    }
    if (diagonal >= 2) { // If the player is moving diagonally, cut speed for each direction.
      if (change.x != 0) {
        change.x /= 1.41421356237;
      }
      if (change.y != 0) {
        change.y /= 1.41421356237;
      }
    }
    player.pos.add(change);
    
    // Abilities
    if (player.firstEquipped) {
      // Handles tier 1 abilities.
      if (player.abilities[0]) {
        // Sword
        player.timer1Max = player.swordTimer;
        pushMatrix();
        translate(-player.pos.x,-player.pos.y);
        player.matrix = player.multMatrix(player.matrix, new float[] {1,0,-player.pos.x,
                                                      0,1,-player.pos.y,
                                                      0,0,1});
        
        // Makes the sword rotate around the player.
        float degree = -90;
        if (player.inputBuffer[5] && player.timer1 >= player.swordTimer) {
          player.timer1 = 0.0;
        }
        if (player.timer1 < player.swordTimer/1.5) {
          degree = 140;
          degree -= lerp(0,100,player.timer1 * 1.5 * (1/player.swordTimer));
          player.hitBoxSize = this.hitBoxSize_Store;
        }
        else {
          player.hitBoxSize = 0;
        }
        if (mouseY != height / 2 && mouseX != width / 2) {
          degree = atan2((mouseY - height/2),(mouseX - width/2)) + radians(degree);
          rotate(degree);
        }
        player.matrix = player.multMatrix(player.matrix,new float[] {1,0,sin(degree) * (player.pixelSize * 0.7),
                                                                    0,1,-cos(degree) * (player.pixelSize * 0.7),
                                                                    0,0,1});
        translate(-player.pixelSize/2,-player.pixelSize);
        image(player.sword_sprite,0,-player.pixelSize * 0.1,player.pixelSize,player.pixelSize);
        player.hitBoxPos = new PVector(player.matrix[2],player.matrix[5]);
        println(player.hitBoxPos);
        popMatrix();
        player.matrix = player.multMatrix(player.matrix,new float[] {1,0,-sin(degree) * (player.pixelSize * 0.7),
                                                                    0,1,cos(degree) * (player.pixelSize * 0.7),
                                                                    0,0,1});
        player.matrix = player.multMatrix(player.matrix, new float[] {1,0,player.pos.x,
                                                      0,1,player.pos.y,
                                                      0,0,1});
      }
      else if (player.abilities[1]) {
        // Spike
        player.timer1Max = player.spikeTimer;
      }
      else if (player.abilities[2]) {
        // Bow
        player.timer1Max = player.bowPullback;
      }
    }
    // Tier 2 abilities
    if (player.abilities[3]) {
      // Boost
      player.timer2Max = player.boostTimer;
    }
    else if (player.abilities[4]) {
      // Slowness
      player.timer2Max = player.slowTimer;
    }
    else if (player.abilities[5]) { // Jump is unique in that it doesnt need to be selected to use
        // Jump
        player.timer2Max = player.jumpTimer;
    }
    if (!player.firstEquipped) {
      // Tier 3 abilities
      if (player.abilities[6]) {
        // Rocket Launcher
        player.timer3Max = player.rocketTimer;
        pushMatrix();
        translate(-player.pos.x-player.pixelSize/2,-player.pos.y-player.pixelSize);
        
        // Makes the rocket rotate around the player.
        translate(player.pixelSize/2,player.pixelSize);
        if (mouseY != height / 2 && mouseX != width / 2) {
          degree = atan2((mouseY - height/2),(mouseX - width/2)) + radians(90);
          rotate(degree);
        }
        translate(-player.pixelSize/2,-player.pixelSize);
        
        if (player.timer3 >= player.rocketTimer) {
          image(player.rocket_sprite,0,-player.pixelSize * 0.4,player.pixelSize,player.pixelSize);
        }
        image(player.rocketLauncher_sprite,0,-player.pixelSize * 0.1,player.pixelSize,player.pixelSize);
        if (player.inputBuffer[5] && player.timer3 >= player.rocketTimer) {
          player.timer3 = 0.0;
          player.rockets.add(new Rocket(new PVector(player.pos.x, player.pos.y),degree,player.rocket_sprite, player.pixelSize, player.matrix));
        }
        popMatrix();
      }
      else if (player.abilities[7]) {
        // Blocks
        player.timer3Max = player.blockTimer;
      }
      else if (player.abilities[8]) {
        // Wind
      }
    }
    
    // Handles Animation
    int frame = int((frameCount % (frameRate * player.animLength)) / ((frameRate * player.animLength) / player.numFrames));
    if (player.idle) {
      frame = 0;
    }
    float xPos = -player.pos.x;
    pushMatrix();
    if (player.left) {
      scale(-1,1);
      xPos *= -1;
    }
    translate(xPos-player.pixelSize/2,-player.pos.y-player.pixelSize*0.8);
    if (player.direction == "down") {
      image(player.front_sprite[frame],0,0,player.pixelSize,player.pixelSize);
    }
    else if (player.direction == "up") {
      image(player.back_sprite[frame],0,0,player.pixelSize,player.pixelSize);
    }
    else if (player.direction == "side") {
      image(player.side_sprite[frame],0,0,player.pixelSize,player.pixelSize);
    }
    popMatrix();
  }
  
  Boolean toDash() {
    if (player.inputBuffer[4]) {
      return true;
    }
    return false;
  }
}

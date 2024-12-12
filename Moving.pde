class Moving implements State {
  float degree = 0;
  float hitBoxSize_Store;
  boolean to_dash = false;
  
  Moving(float hitBoxSize) {
    hitBoxSize_Store = hitBoxSize;
  }
  
  void onEnter() {
  
  }
  
  void onExit() {
    player.hitBoxSize = 0.0;
    player.acel.x = 0;
    player.acel.y = 0;
  }
  
  void tick() {
    // Handles player movement
    player.idle = true;
    player.diagonal = 0;
    PVector change = new PVector(0,0);
    int vert = 0;
    int horiz = 0;
    if (player.inputBuffer[2]) {
      change.x += player.pixelSize * player.speed/frameRate/player.acelModifier;
      player.direction = "side";
      player.idle = false;
      player.left = true;
      player.diagonal += 1;
      horiz = 1;
    }
    if (player.inputBuffer[3]) {
      change.x += -player.pixelSize * player.speed/frameRate/player.acelModifier;
      player.direction = "side";
      player.idle = false;
      player.left = false;
      player.diagonal += 1;
      horiz = -1;
    }
    if (player.inputBuffer[0]) {
      change.y += player.pixelSize * player.speed/frameRate/player.acelModifier;
      player.direction = "up";
      player.idle = false;
      player.diagonal += 1;
      vert = 1;
    }
    if (player.inputBuffer[1]) {
      change.y += -player.pixelSize * player.speed/frameRate/player.acelModifier;
      player.direction = "down";
      player.idle = false;
      player.diagonal += 1;
      vert = -1;
    }
    player.acel = (change);
    
    // Abilities
    if (player.firstEquipped) {
       //Handles tier 1 abilities.
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
        if (!(player.timer1 < player.swordTimer/1.5)) {
          rotate(45);
          translate(player.pixelSize/2,-player.pixelSize/3);
        }
        image(player.sword_sprite,0,-player.pixelSize * 0.1,player.pixelSize,player.pixelSize);
        //if (!(player.timer1 < player.swordTimer/1.5)) {
        //  translate(-player.pixelSize/2,-player.pixelSize);
        //}
        player.hitBoxPos = new PVector(player.matrix[2],player.matrix[5]);
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
        pushMatrix();
        translate(-player.pos.x,-player.pos.y);
        player.matrix = player.multMatrix(player.matrix, new float[] {1,0,-player.pos.x,
                                                      0,1,-player.pos.y,
                                                      0,0,1});

        degree = atan2((mouseY - height/2),(mouseX - width/2));
        rotate(degree);
        translate(15,0);
        player.matrix = player.multMatrix(player.matrix, new float[] {1,0,sin(degree) * 15,
                                                      0,1,-cos(degree) * 15,
                                                      0,0,1});
        if (player.inputBuffer[5] && player.timer1 >= player.spikeTimer) {
          player.timer1 = 0.0;
          player.spikes.add(new Spike(new PVector(-player.pos.x + sin(degree + radians(90)) * 15, -player.pos.y - cos(degree + radians(90)) * 15),player.pixelSize,player.spike_sprite,player.matrix));
        }
        if (player.timer1 < player.spikeTimer) {
          fill(color(230,50,50));
          stroke(color(230,50,50));
          
        }
        else {
          fill(color(50,230,50));
          stroke(color(50,230,50));
        }
        ellipse(0,0,player.pixelSize/2,player.pixelSize/2);
        popMatrix();
        player.matrix = player.multMatrix(player.matrix, new float[] {1,0,-sin(degree) * 15,
                                                      0,1,cos(degree) * 15,
                                                      0,0,1});
        player.matrix = player.multMatrix(player.matrix, new float[] {1,0,player.pos.x,
                                                      0,1,player.pos.y,
                                                      0,0,1});
      }
      else if (player.abilities[2]) {
        // Bow
        player.timer1Max = player.bowPullback;
        pushMatrix();
        translate(-player.pos.x-player.pixelSize/2,-player.pos.y-player.pixelSize);
        
        // Makes the bow rotate around the player.
        translate(player.pixelSize/2,player.pixelSize);
        if (mouseY != height / 2 && mouseX != width / 2) {
          degree = atan2((mouseY - height/2),(mouseX - width/2)) + radians(90);
          rotate(degree);
        }
        translate(-player.pixelSize/2,-player.pixelSize);
        if (!player.inputBuffer[5]) {
          player.timer1 = 0.0;
          image(player.bow_sprite[0],0,player.pixelSize*0.2,player.pixelSize,player.pixelSize);
        }
        else {
          player.timer1 += 1/frameRate;
          if (player.timer1 < player.timer1Max/3) {
            image(player.bow_sprite[0],0,player.pixelSize*0.2,player.pixelSize,player.pixelSize);
          }
          else if (player.timer1 < player.timer1Max/3*2) {
            image(player.bow_sprite[1],0,player.pixelSize*0.2,player.pixelSize,player.pixelSize);
          }
          else {
            image(player.bow_sprite[2],0,player.pixelSize*0.2,player.pixelSize,player.pixelSize);
          }
          if (player.timer1 >= player.timer1Max) {
            player.arrows.add(new Arrow(new PVector(player.pos.x, player.pos.y),degree,player.arrow_sprite, player.pixelSize, player.matrix));
            player.timer1 = 0.0;
          }
        }
        popMatrix();
      }
    }
    // Tier 2 abilities
    if (player.abilities[3]) {
      // Boost
      player.timer2Max = player.boostTimer;
      if (player.timer2 >= player.timer2Max) {
        player.ability2Cooldown = false;
      }
      if (player.inputBuffer[4] && player.timer2 > 0.0 && player.ability2Cooldown == false) {
        player.timer2 -= 2/frameRate;
        player.isFast = true;
      }
      else if (player.inputBuffer[4] && player.timer2 <= 0.0) {
        player.ability2Cooldown = true;
      }
      else {
        player.isFast = false;
      }
    }
    else if (player.abilities[4]) {
      // Slowness
      player.timer2Max = player.slowTimer;
      if (player.timer2 >= player.timer2Max) {
        player.ability2Cooldown = false;
      }
      if (player.inputBuffer[4] && player.timer2 > 0.0 && player.ability2Cooldown == false) {
        player.timer2 -= 2/frameRate;
        noStroke();
        fill(color(200,50,200,90));
        ellipse(-player.pos.x,-player.pos.y,100,100);
        if (showHitbox) {
          noFill();
          stroke(255);
          ellipse(-player.pos.x,-player.pos.y,100,100);
        }
        for (Zombie zombie: zombies) {
          if (zombie.check_collision_sphere(new PVector(-player.pos.x,-player.pos.y),100)) {
            zombie.isSlowed = true;
          }
          else {
            zombie.isSlowed = false;
          }
        }
      }
      else if (player.inputBuffer[4] && player.timer2 <= 0.0) {
        player.ability2Cooldown = true;
      }
      else {
        for (Zombie zombie: zombies) {
          zombie.isSlowed = false;
        }
      }
    }
    else if (player.abilities[5]) {
      // Jump
      player.timer2Max = player.jumpTimer;
      if (player.inputBuffer[4] && player.timer2 >= player.timer2Max) {
        to_dash = true;
        player.timer2 = 0.0;
      }
    }
    if (!player.firstEquipped) {
      player.hitBoxSize = 0;
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
        pushMatrix();
        translate(-player.pos.x,-player.pos.y);
        player.matrix = player.multMatrix(player.matrix, new float[] {1,0,-player.pos.x,
                                                      0,1,-player.pos.y,
                                                      0,0,1});

        degree = atan2((mouseY - height/2),(mouseX - width/2));
        player.matrix = player.multMatrix(player.matrix, new float[] {1,0,sin(degree) * 30,
                                                      0,1,-cos(degree) * 30,
                                                      0,0,1});
        if (player.inputBuffer[5] && player.timer3 >= player.blockTimer) {
          player.timer3 = 0.0;
          boxes.add(new Box(new PVector(-player.pos.x + sin(degree + radians(90)) * 30, -player.pos.y - cos(degree + radians(90)) * 30),player.pixelSize,player.box_sprite,player.matrix));
        }
        if (player.timer3 < player.blockTimer) {
          fill(color(230,50,50));
          stroke(color(230,50,50));
          
        }
        else {
          fill(color(50,230,50));
          stroke(color(50,230,50));
        }
        rect(-player.pixelSize/4 + sin(degree + radians(90)) * 30,-player.pixelSize/4 - cos(degree + radians(90)) * 30,player.pixelSize/2,player.pixelSize/2);
        popMatrix();
        player.matrix = player.multMatrix(player.matrix, new float[] {1,0,-sin(degree) * 30,
                                                      0,1,cos(degree) * 30,
                                                      0,0,1});
        player.matrix = player.multMatrix(player.matrix, new float[] {1,0,player.pos.x,
                                                      0,1,player.pos.y,
                                                      0,0,1});
      }
      else if (player.abilities[8]) {
        // Wind
        player.timer3Max = player.windAmount;
        pushMatrix();
        translate(-player.pos.x-player.pixelSize/2,-player.pos.y-player.pixelSize);
        
        // Makes the Wind machine rotate around the player.
        translate(player.pixelSize/2,player.pixelSize);
        if (mouseY != height / 2 && mouseX != width / 2) {
          degree = atan2((mouseY - height/2),(mouseX - width/2)) + radians(90);
          rotate(degree);
        }
        translate(-player.pixelSize/2,-player.pixelSize);
        
        if (player.timer3 >= player.timer3Max) {
          player.ability3Cooldown = false;
        }
        if (player.inputBuffer[5] && player.timer3 > 0.0 && player.ability3Cooldown == false) {
          player.timer3 -= 2/frameRate;
          if (frameCount % 10 < 5) {
            image(player.wind_sprite[1],0,-player.pixelSize * 0.1,player.pixelSize,player.pixelSize);
          }
          else {
            image(player.wind_sprite[0],0,-player.pixelSize * 0.1,player.pixelSize,player.pixelSize);
          }
          if (frameCount % (int(frameRate/7)) == 0) {
            particles.add(new Particle(new PVector(-player.pos.x + random(-10,10) + sin(degree) * 20,-player.pos.y + random(-10,10) - cos(degree) * 20), new PVector(sin(degree) * 150,-cos(degree) * 150)));
          }
          for (Zombie zombie: zombies) {
            if (zombie.check_collision_sphere(new PVector(-player.pos.x + sin(degree) * 30,-player.pos.y - cos(degree) * 30), 25)) {
              zombie.acceleration.add(new PVector(sin(degree) * 60,-cos(degree) * 60));
              zombie.isWinded = true;
            }
            else if (zombie.check_collision_sphere(new PVector(-player.pos.x + sin(degree) * 60,-player.pos.y - cos(degree) * 60), 25)) {
              zombie.acceleration.add(new PVector(sin(degree) * 30,-cos(degree) * 30));
              zombie.isWinded = true;
            }
            else {
              zombie.isWinded = false;
            }
          }
        }
        else if (player.inputBuffer[5] && player.timer3 <= 0.0) {
          player.ability3Cooldown = true;
          image(player.wind_sprite[0],0,-player.pixelSize * 0.1,player.pixelSize,player.pixelSize);
        }
        else {
          image(player.wind_sprite[0],0,-player.pixelSize * 0.1,player.pixelSize,player.pixelSize);
          for (Zombie zombie: zombies) {
            zombie.isWinded = false;
          }
        }
        popMatrix();
        if (player.inputBuffer[5] && player.timer3 > 0.0 && player.ability3Cooldown == false) {
          if (showHitbox) {
            noFill();
            stroke(255);
            ellipse(-player.pos.x + sin(degree) * 30,-player.pos.y - cos(degree) * 30,25,25);
            ellipse(-player.pos.x + sin(degree) * 60,-player.pos.y - cos(degree) * 60,25,25);
          }
        }
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
      if (!player.invincible) {
        image(player.side_sprite[frame], 0,0,player.pixelSize,player.pixelSize);
      }
      else {
        image(player.front_sprite_I[frame],0,0,player.pixelSize,player.pixelSize);
      }
    }
    else if (player.direction == "up") {
      if (!player.invincible) {
        image(player.side_sprite[frame], 0,0,player.pixelSize,player.pixelSize);
      }
      else {
        image(player.front_sprite_I[frame],0,0,player.pixelSize,player.pixelSize);
      }
    }
    else if (player.direction == "side") {
      if (!player.invincible) {
        image(player.side_sprite[frame], 0,0,player.pixelSize,player.pixelSize);
      }
      else {
        image(player.front_sprite_I[frame],0,0,player.pixelSize,player.pixelSize);
      }
    }
    popMatrix();
  }
  
  Boolean toDash() {
    if (to_dash) {
      to_dash = false;
      return true;
    }
    return false;
  }
  
  boolean toHitstun() {
    if (player.damaged) {
      return true;
    }
    return false;
  }
}

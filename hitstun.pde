class Hitstun implements State {
  float speedStorage;
  float decelStorage;
  float timer = 0;
  
  Hitstun() {
    
  }
  
  void onEnter() {
    speedStorage = player.speed;
    decelStorage = player.acelModifier;
    player.speed = player.knockback * 2;
    player.acelModifier *= player.speed;
    player.vel.add(new PVector(player.hitstunDirection.x/abs(player.hitstunDirection.x) * player.speed, player.hitstunDirection.y/abs(player.hitstunDirection.y) * player.speed));
    timer = 0;
    player.invincible = true;
    player.invincibleTimer = 1.5;
  }
  
  void onExit() {
    player.damaged = false;
    player.speed = speedStorage;
    player.acelModifier = decelStorage;
  }
  
  void tick() {
    float xPos = -player.pos.x;
    pushMatrix();
    if (player.left) {
      scale(-1,1);
      xPos *= -1;
    }
    translate(xPos-player.pixelSize/2,-player.pos.y-player.pixelSize*0.8);
    timer += 1/frameRate;
    if (player.direction == "down") {
      image(player.front_sprite_I[0],0,0,player.pixelSize,player.pixelSize);
    }
    else if (player.direction == "up") {
      image(player.back_sprite_I[0],0,0,player.pixelSize,player.pixelSize);
    }
    else if (player.direction == "side") {
      image(player.side_sprite_I[0],0,0,player.pixelSize,player.pixelSize);
    }
    popMatrix();
  }
  
  Boolean toMoving() {
    if (player.vel == new PVector(0.0,0.0,0.0) || this.timer > 0.5) {
      return true;
    }
    return false;
  }
}

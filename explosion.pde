class Explosion {
  PVector pos;
  int pixelSize;
  float count;
  float lifetime = 0.5;
  float size;

  Explosion(PVector pos,int pixelSize) {
    this.pos = pos;
    this.pixelSize = pixelSize * 3;
    this.count = 0;
    this.size = 10;
  }
  
  boolean check_collision_sphere(PVector otherPos, float otherSize) {
    float dist = this.pos.dist(otherPos);
    if (dist <= this.size/2 + otherSize/2) {
      return true;
    }
    return false;
  }
  
  boolean check_collision_square(PVector otherPos, PVector otherSize) {
    float deltaX = Math.abs(this.pos.x - otherPos.x);
    float deltaY = Math.abs(this.pos.y - otherPos.y);
    if (deltaX < (this.size/2 + otherSize.x/2) && deltaY < (this.size/2 + otherSize.y/2)) {
    return true;
  }
    return false;
  }
  
  void display() {
    count += 1/frameRate;
    size += 150/frameRate;
    
    pushMatrix();
    translate(pos.x,pos.y);
    if (count < lifetime*0.25) {
      image(player.explosion_sprite[0],-pixelSize/2,-pixelSize/2,pixelSize,pixelSize);
    }
    else if (count < lifetime*0.5) {
      image(player.explosion_sprite[1],-pixelSize/2,-pixelSize/2,pixelSize,pixelSize);
    }
    else if (count < lifetime*0.75) {
      image(player.explosion_sprite[2],-pixelSize/2,-pixelSize/2,pixelSize,pixelSize);
    }
    else{
      image(player.explosion_sprite[3],-pixelSize/2,-pixelSize/2,pixelSize,pixelSize);
    }
    if (showHitbox) {
      noFill();
      stroke(255);
      ellipse(0,0,size,size);
    }
    popMatrix();
  }
}

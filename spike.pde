class Spike {
  PVector pos;
  PImage spike_sprite;
  float pixelSize;
  float[] matrix;
  float size;
  float lifetime = 5;
  float count = 0;
  float damage = 20;
  
  Spike(PVector pos, float pixelSize, PImage spike_sprite, float[] matrix) {
    this.pos = pos;
    this.pixelSize = pixelSize;
    this.matrix = matrix;
    this.spike_sprite = spike_sprite;
    size = 20;
  }
  
  void display() {
    noFill();
    image(spike_sprite,pos.x - pixelSize/2,pos.y - pixelSize/2,pixelSize,pixelSize);
    if (showHitbox) {
      noFill();
      stroke(255);
      ellipse(this.pos.x,this.pos.y,this.size,this.size); //Hitbox
    }
    count += 1/frameRate;
  }
  
  boolean check_collision(PVector otherPos, float otherSize) {
    float dist = this.pos.dist(otherPos);
    if (dist <= this.size + otherSize) {
      return true;
    }
    return false;
  }
  
  
}

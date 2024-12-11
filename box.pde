class Box {
  PVector pos;
  float pixelSize;
  PImage box_sprite;
  float size;
  float[] matrix;
  float count;
  float lifetime;
  
  Box(PVector pos, float pixelSize, PImage box_sprite, float[] matrix) {
    this.pos = pos;
    this.pixelSize = pixelSize;
    this.box_sprite = box_sprite;
    this.matrix = matrix;
    this.count = 0.0;
    this.lifetime = 10.0;
    this.size = 15;
  }
  
  void display() {
    image(box_sprite,pos.x-size/2,pos.y-size/2,size,size);
    if (showHitbox) {
      noFill();
      stroke(255);
      rect(pos.x-size/2,pos.y-size/2,size,size);
    }
    count += 1/frameRate;
    println(this.count);
  }
}

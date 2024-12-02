class Rocket {
  PVector pos;
  float degree;
  int pixelSize;
  float vel;
  PImage rocket_sprite;
  
  Rocket(PVector pos, float degree, PImage sprite, int pixelSize) {
    this.pos = pos;
    this.degree = degree;
    this.rocket_sprite = sprite;
    this.pixelSize = pixelSize;
    this.vel = pixelSize*3.5;
  }
  
  void display() {
    pushMatrix();
    translate(-pos.x,-pos.y);
    rotate(degree);
    translate(-player.pixelSize/2,-player.pixelSize/2);
    image(rocket_sprite,0,-player.pixelSize * 0.9,player.pixelSize,player.pixelSize);
    popMatrix();
  }
  
  void move() {
    pos.add(new PVector(-(sin(degree)*vel)/frameRate,(cos(degree)*vel)/frameRate));
  }
  
  void display_move() {
    this.display();
    this.move();
  }
}

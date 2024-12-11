class Particle {
  PVector pos;
  PVector vel;
  float lifetime = 1.0;
  float count = 0.0;
  
  Particle(PVector pos, PVector vel) {
    this.pos = pos;
    this.vel = vel;
  }
  
  void  display() {
   fill(255);
   noStroke();
   rect(pos.x-2,pos.y-2,2,2);
  }
  
  void move() {
    this.pos.add(new PVector(this.vel.x/frameRate,this.vel.y/frameRate));
  }
  
  void display_move() {
    this.display();
    this.move();
    lifetime -= 1/frameRate;
  }
}

class Camera {
  PVector playerPos;
  Camera(PVector pos) {
    this.playerPos = pos;
  }
  
  void move_camera() {
    translate(playerPos.x+width/2,playerPos.y+height/2);
  }
}

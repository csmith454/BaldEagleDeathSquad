class Camera {
  PVector playerPos;
  float scaleSize = 4;
  
  Camera(PVector pos) {
    this.playerPos = pos;
  }
  
  void move_camera() {
    scale(scaleSize);
    translate(playerPos.x+width/2/scaleSize,playerPos.y+height/2/scaleSize);
  }
}

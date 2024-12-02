class Spawn {
  JSONObject spawn;
  float h;
  float w;
  float x;
  float y;
  
  Spawn(JSONObject s) {
    // pull out id, height, width, x, y
    this.h = s.getFloat("height");
    this.w = s.getFloat("width");
    this.x = s.getFloat("x");
    this.y = s.getFloat("y");
  }
}
  

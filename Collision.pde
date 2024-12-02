class Collision {
  JSONObject collision;
  float h;
  float w;
  float x;
  float y;
  
  Collision(JSONObject c) {
    // pull id, height, width, x, y
    this.h = c.getFloat("height");
    this.w = c.getFloat("width");
    this.x = c.getFloat("x");
    this.y = c.getFloat("y");
  }
}
  

class Collision {
  JSONObject collision;
  float h;
  float w;
  float x;
  float y;
  JSONObject special;
  String specialStr;
  boolean box;
  boolean water;
  JSONArray properties;
  
  Collision(JSONObject c) {
    // pull id, height, width, x, y, special bools
    this.h = c.getFloat("height");
    this.w = c.getFloat("width");
    this.x = c.getFloat("x");
    this.y = c.getFloat("y");
    if (c.isNull("properties") != true) {
      this.properties = c.getJSONArray("properties");
      this.special = properties.getJSONObject(0);
      this.specialStr = special.getString("name");
      println(specialStr);
      if (specialStr.equals("box")) {
        box = true;
        water = false;
      }
      else if (specialStr.equals("water")) {
        box = false;
        water = true;
      }
      else {
        box = false;
        water = false;
      }
    }
    else {
        box = false;
        water = false;
      }
  }
}
  

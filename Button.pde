class Button {
  PVector pos;
  color c;
  String text;
  PVector distance;
  boolean locked;
  
  Button(float x, float y, color c, String text, boolean locked) {
    pos = new PVector(x,y);
    this.c = c;
    this.text = text;
    this.locked = locked;
    textAlign(CENTER);
  }
}

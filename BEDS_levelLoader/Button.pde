class Button {
  PVector pos;
  color c;
  String text;
  PVector distance;
  
  Button(float x, float y, color c, String text) {
    pos = new PVector(x,y);
    this.c = c;
    this.text = text;
    textAlign(CENTER);
    noStroke();
  }
}

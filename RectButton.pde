class RectButton extends Button {
  PShape rec;
  PShape scaleRec;
  float h;
  float w;
  
  
  RectButton(float x, float y, color c, String text, boolean locked,float h, float w) {
    super(x,y,c,text,locked);
    this.h = h;
    this.w = w;
    rectMode(CENTER);
    textMode(CENTER);
    rec = createShape(RECT,0,0,w,h);
    scaleRec = createShape(RECT,0,0,1.25*w,1.25*h);
  }
  
  void display() {
    if (this.locked == true) {
      rec.setFill(color(152,141,141));
    }
    else {
      rec.setFill(c);
    }
    shape(rec,pos.x,pos.y);
    text(text,pos.x,pos.y);
  }
  
  void animateButton() {
    distance = new PVector(abs(mouseX-pos.x),abs(mouseY-pos.y));
    if (distance.x < w/2 && distance.y < h/2) {
      if (this.locked){
        scaleRec.setFill(color(152,141,141));
      }
      else {
        scaleRec.setFill(c);
      } 
      shape(scaleRec,pos.x,pos.y);
      text(text,pos.x,pos.y);
    }
  }
  
  boolean isPressed() {
    distance = new PVector(abs(mouseX-pos.x),abs(mouseY-pos.y));
    if (this.locked) {
      return false;
    }
    else {
      if (distance.x < w && distance.y < h) {
        return true;
      }
      else {
        return false;
      }
    }
  }
}

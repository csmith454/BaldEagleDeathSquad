class RectButton extends Button {
  PShape rec;
  PShape scaleRec;
  float h;
  float w;
  
  RectButton(float x, float y, color c, String text,float h, float w) {
    super(x,y,c,text);
    this.h = h;
    this.w = w;
    rectMode(CENTER);
    rec = createShape(RECT,0,0,w,h);
    scaleRec = createShape(RECT,0,0,1.25*w,1.25*h);
    rec.setFill(c);
    scaleRec.setFill(c);
  }
  
  void display() {
    shape(rec,pos.x,pos.y);
    text(text,pos.x,pos.y);
  }
  
  void animateButton() {
    distance = new PVector(abs(mouseX-pos.x),abs(mouseY-pos.y));
    
    if (distance.x < w/2 && distance.y < h/2) {
      shape(scaleRec,pos.x,pos.y);
      text(text,pos.x,pos.y);
    }
  }
  
  boolean isPressed() {
    distance = new PVector(abs(mouseX-pos.x),abs(mouseY-pos.y));
    
    if (distance.x < w && distance.y < h) {
      return true;
    }
    else {
      return false;
    }
  }
}

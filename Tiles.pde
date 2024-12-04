class Tiles {
  int [] data;
  PGraphics bg;
  ArrayList<PImage> tilesToDraw;
  float x;
  float y;
  
  
  Tiles(JSONArray data, ArrayList<PImage> tilesToDraw) {
    this.data = data.toIntArray();
    this.tilesToDraw = tilesToDraw;
  }
  
  PGraphics createBackground() {
    bg = createGraphics(width,height);
    bg.beginDraw();
    x = 0;
    y = 0;
    for (int i = 0; i < data.length; i++) {
      if (i !=0 && i % 37 == 0) {
        x = 0;
        y+=16;
      }
      bg.image(tilesToDraw.get(data[i]-1),x,y);
      x+=16;
    }
    bg.endDraw();
    
    return bg;
  }
}

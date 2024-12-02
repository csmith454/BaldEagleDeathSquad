class Level {
  
  ArrayList<Collision> collisions;
  ArrayList<Spawn> spawns;
  PGraphics bg;
  
  Level(PGraphics bg, ArrayList<Collision> collisions, ArrayList<Spawn> spawns) {
    this.bg = bg;
    this.collisions = collisions;
    this.spawns = spawns;
  }
  
  void displayLevel() {
    image(bg,0,0);
  }
}

class Level {
  
  int id;
  ArrayList<Collision> collisions;
  ArrayList<Spawn> spawns;
  PGraphics bg;
  
  Level(int id, PGraphics bg, ArrayList<Collision> collisions, ArrayList<Spawn> spawns) {
    this.id = id;
    this.bg = bg;
    this.collisions = collisions;
    this.spawns = spawns;
  }
  
  void displayLevel() {
    image(bg,0,0);
  }
}

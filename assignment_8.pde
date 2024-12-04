ArrayList<Rocket> rockets = new ArrayList<Rocket>();
Player player = new Player(rockets);
Camera camera = new Camera(player.pos);

JSONObject level1;
JSONObject level2;
JSONObject level3;

Level L1;
Level L2;
Level L3;

ArrayList<ArrayList<Collision>> allCollisions;
ArrayList<Collision> collision1;
ArrayList<Collision> collision2;
ArrayList<Collision> collision3;

ArrayList<ArrayList<Spawn>> allSpawns;
ArrayList<Spawn> spawn1;
ArrayList<Spawn> spawn2;
ArrayList<Spawn> spawn3;

boolean startOfLevel = true;
int gameState;
GUI g;

void setup() {
  noSmooth();
  size(1600,800);
  frameRate(60);
  
  allCollisions = new ArrayList<ArrayList<Collision>>();
  collision1 = new ArrayList<Collision>();
  collision2 = new ArrayList<Collision>();
  collision3 = new ArrayList<Collision>();
  
  allSpawns = new ArrayList<ArrayList<Spawn>>();
  spawn1 = new ArrayList<Spawn>();
  spawn2 = new ArrayList<Spawn>();
  spawn3 = new ArrayList<Spawn>();
  
  loadData();
  
  gameState = 1;
  g = new GUI();
  g.display(gameState);
  
  // Initialize sprites for player character
  for (int i = 0; i < player.numFrames; i++) {
    String imageName = "front_" + nf(i + 1, 1) + ".png";
    player.front_sprite[i] = loadImage(imageName);
    imageName = "back_" + nf(i + 1, 1) + ".png";
    player.back_sprite[i] = loadImage(imageName);
    imageName = "side_" + nf(i + 1, 1) + ".png";
    player.side_sprite[i] = loadImage(imageName);
  }
  player.rocketLauncher_sprite = loadImage("rocketLauncher.png");
  player.rocket_sprite = loadImage("rocket.png");
  player.sword_sprite = loadImage("sword.png");
  
}

void draw() {
  g.display(gameState);
  
  if (gameState == 1) {
    background(255);
    camera.move_camera();
    L1.displayLevel();
    player.update();
    if (startOfLevel) {
      player.updatePos(new PVector(-L1.spawns.get(0).x,-L1.spawns.get(0).y)); // Make this the spawn position
      startOfLevel = false;
      println("a");
    }
    for (Rocket rocket: rockets) {
      rocket.display_move();
    }
  }
  else if (gameState == 2) {
    // display level 2
    background(255);
    camera.move_camera();
    L2.displayLevel();
    player.update();
    if (startOfLevel) {
      player.updatePos(new PVector(-L2.spawns.get(0).x,-L2.spawns.get(0).y)); // Make this the spawn position
      startOfLevel = false;
      println("a");
    }
    for (Rocket rocket: rockets) {
      rocket.display_move();
    }
  }
  else if (gameState == 3) {
    //display level 3
    background(255);
    camera.move_camera();
    L3.displayLevel();
    player.update();
    if (startOfLevel) {
      player.updatePos(new PVector(-L3.spawns.get(1).x,-L3.spawns.get(1).y)); // Make this the spawn position
      startOfLevel = false;
      println("a");
    }
    for (Rocket rocket: rockets) {
      rocket.display_move();
    }
  }
  
}

void keyPressed() {
  player.keyPressed();
}


void keyReleased() {
  player.keyReleased();
}

void mousePressed() {
  player.mousePressed();
}

void mouseReleased() {
  player.mouseReleased();
}

ArrayList<PImage> L1createTilesToDraw() {
  ArrayList<PImage> tilesToDraw = new ArrayList<PImage>();
  IntDict nameID = new IntDict();
  
  JSONObject level1Tiles = loadJSONObject("Level1.tsj");
  
  JSONArray L1Tiles = level1Tiles.getJSONArray("tiles");
  
  for (int i = 0; i < L1Tiles.size(); i++) {
    JSONObject t = L1Tiles.getJSONObject(i);
    
    int id = t.getInt("id");
    String imgName = t.getString("image");
    
    nameID.set(imgName, id);
  }
  
  for (String name : nameID.keys()) {
    PImage img = loadImage(name);
    tilesToDraw.add(img);
  }
  return tilesToDraw;
}

ArrayList<PImage> L2createTilesToDraw() {
  ArrayList<PImage> tilesToDraw = new ArrayList<PImage>();
  IntDict nameID = new IntDict();
  
  JSONObject level2Tiles = loadJSONObject("Level2.tsj");
  
  JSONArray L2Tiles = level2Tiles.getJSONArray("tiles");
  
  for (int i = 0; i < L2Tiles.size(); i++) {
    JSONObject t = L2Tiles.getJSONObject(i);
    
    int id = t.getInt("id");
    String imgName = t.getString("image");
    
    nameID.set(imgName, id);
  }
  
  for (String name : nameID.keys()) {
    PImage img = loadImage(name);
    tilesToDraw.add(img);
  }
  return tilesToDraw;
}

ArrayList<PImage> L3createTilesToDraw() {
  ArrayList<PImage> tilesToDraw = new ArrayList<PImage>();
  IntDict nameID = new IntDict();
  
  JSONObject level3Tiles = loadJSONObject("Level3.tsj");
  
  JSONArray L3Tiles = level3Tiles.getJSONArray("tiles");
  
  for (int i = 0; i < L3Tiles.size(); i++) {
    JSONObject t = L3Tiles.getJSONObject(i);
    
    int id = t.getInt("id");
    String imgName = t.getString("image");
    
    nameID.set(imgName, id);
  }
  
  for (String name : nameID.keys()) {
    PImage img = loadImage(name);
    tilesToDraw.add(img);
  }
  return tilesToDraw;
}

void loadData(){
  // parse level 1
  level1 = loadJSONObject("Level1.tmj");
  
  JSONArray layers = level1.getJSONArray("layers");
  
  JSONObject jsonTiles = layers.getJSONObject(0);
  JSONArray tiles = jsonTiles.getJSONArray("data");
  
  JSONObject jsonCollisions = layers.getJSONObject(1);
  JSONArray collisions = jsonCollisions.getJSONArray("objects");
  
  JSONObject jsonSpawns = layers.getJSONObject(2);
  JSONArray spawns = jsonSpawns.getJSONArray("objects");
  
  // create class objects from JSON 
  Tiles t1 = new Tiles(tiles,L1createTilesToDraw());
  
  for (int i = 0; i < collisions.size(); i++) {
    JSONObject c = collisions.getJSONObject(i);
    
    Collision colObj = new Collision(c);
    
    collision1.add(colObj);
  }
  
  for (int i = 0; i < spawns.size(); i++) {
    JSONObject s = spawns.getJSONObject(i);
    
    Spawn spaObj = new Spawn(s);
    
    spawn1.add(spaObj);
  }
  
  // parse level 2
  level2 = loadJSONObject("Level2.tmj");
  
  JSONArray layers2 = level2.getJSONArray("layers");
  
  JSONObject jsonTiles2 = layers2.getJSONObject(0);
  JSONArray tiles2 = jsonTiles2.getJSONArray("data");
  
  JSONObject jsonCollisions2 = layers2.getJSONObject(1);
  JSONArray collisions2 = jsonCollisions2.getJSONArray("objects");
  
  JSONObject jsonSpawns2 = layers2.getJSONObject(2);
  JSONArray spawns2 = jsonSpawns2.getJSONArray("objects");
  
  // create class objects from JSON 
  Tiles t2 = new Tiles(tiles2, L2createTilesToDraw());
  
  for (int i = 0; i < collisions2.size(); i++) {
    JSONObject c = collisions2.getJSONObject(i);
    
    Collision colObj = new Collision(c);
    
    collision2.add(colObj);
  }
  
  for (int i = 0; i < spawns2.size(); i++) {
    JSONObject s = spawns2.getJSONObject(i);
    
    Spawn spaObj = new Spawn(s);
    
    spawn2.add(spaObj);
  }
  
  // parse level 3
  level3 = loadJSONObject("Level3.tmj");
  
  JSONArray layers3 = level3.getJSONArray("layers");
  
  JSONObject jsonTiles3 = layers3.getJSONObject(0);
  JSONArray tiles3 = jsonTiles3.getJSONArray("data");
  
  JSONObject jsonCollisions3 = layers3.getJSONObject(1);
  JSONArray collisions3 = jsonCollisions3.getJSONArray("objects");
  
  JSONObject jsonSpawns3 = layers3.getJSONObject(2);
  JSONArray spawns3 = jsonSpawns3.getJSONArray("objects");
  
  // create class objects from JSON 
  Tiles t3 = new Tiles(tiles3, L3createTilesToDraw());
  
  for (int i = 0; i < collisions3.size(); i++) {
    JSONObject c = collisions3.getJSONObject(i);
    
    Collision colObj = new Collision(c);
    
    collision3.add(colObj);
  }
  
  for (int i = 0; i < spawns3.size(); i++) {
    JSONObject s = spawns3.getJSONObject(i);
    
    Spawn spaObj = new Spawn(s);
    
    spawn3.add(spaObj);
  }
  
  // add arraylists to greater arraylists
  allCollisions.add(collision1);
  allCollisions.add(collision2);
  allCollisions.add(collision3);
  
  allSpawns.add(spawn1);
  allSpawns.add(spawn2);
  allSpawns.add(spawn3);
  
  // create level objects 
  L1 = new Level(t1.createBackground(),allCollisions.get(0),allSpawns.get(0));
  L2 = new Level(t2.createBackground(),allCollisions.get(1),allSpawns.get(1));
  L3 = new Level(t3.createBackground(),allCollisions.get(2),allSpawns.get(2));
}

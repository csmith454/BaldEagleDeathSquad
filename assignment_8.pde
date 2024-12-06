boolean showHitbox = false;

ArrayList<Rocket> rockets = new ArrayList<Rocket>();
ArrayList<Rocket> remove_rockets = new ArrayList<Rocket>();
ArrayList<Spike> spikes = new ArrayList<Spike>();
ArrayList<Spike> remove_spikes = new ArrayList<Spike>();

float[] matrix = {1,0,0,
                  0,1,0,
                  0,0,1}; // Used for manually storing transformations that happen to the world matrix. Processing doesn't have a way that I know of to actually get the matrix to be used by code, so I keep track of my own matrix for use in monitoring positions.
Player player = new Player(matrix, rockets, spikes);
Camera camera = new Camera(player.pos);

// Zombie information
ArrayList<Zombie> zombies;
ArrayList<PVector> meatPellets;
boolean showNextLevelScreen = false;
boolean gameStarted = true;
int level = 1;
float mutationRate = 2.0;
PImage zombieSouthTexture;
PImage zombieNorthTexture;
PImage zombieEastWestTexture;
boolean flipTexture;

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

StringDict records;
HighScore hs;
boolean startOfLevel = true;
int gameState;
GUI g;

void setup() {
  noSmooth();
  size(1000,800);
  frameRate(60);
  
  allCollisions = new ArrayList<ArrayList<Collision>>();
  collision1 = new ArrayList<Collision>();
  collision2 = new ArrayList<Collision>();
  collision3 = new ArrayList<Collision>();
  
  allSpawns = new ArrayList<ArrayList<Spawn>>();
  spawn1 = new ArrayList<Spawn>();
  spawn2 = new ArrayList<Spawn>();
  spawn3 = new ArrayList<Spawn>();
  
  // Zombie information
  zombies = new ArrayList<Zombie>();
  meatPellets = new ArrayList<PVector>();
  
  loadData();
  String[] keys = loadStrings("initials.txt");
  String[] values = loadStrings("scores.txt");
  hs = new HighScore(keys,values);

  gameState = 0;
  g = new GUI();
  g.display(gameState);
  hs.display(gameState);
  
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
  player.spike_sprite = loadImage("spike.png");
  for (int i = 0; i < 3; i++) {
    String imageName = "bow_" + nf(i + 1, 1) + ".png";
    player.bow_sprite[i] = loadImage(imageName);
  }
  player.arrow = loadImage("arrow.png");
  
  // Initialize sprites for zombies
  zombieSouthTexture = loadImage("zombie_facing_south.png");
  zombieNorthTexture = loadImage("zombie_facing_north.png");
  zombieEastWestTexture = loadImage("zombie_facing_eastwest.png");
}

void draw() {
  if (zombies.size() == 0 && gameState == 3) {
    if (frameCount > 10000) {
      gameState = 12;
    }
  }
  else if (zombies.size() == 0 && frameCount > 10000) {
    
    gameState = 10;
  }
  // if number of zombies in array is zero then chenge to gameState 10
  // if no zombies and gameState is 3 then transition to GUI gameState 12 and display HS sequence
  g.display(gameState);
  hs.display(gameState);
  
  if (gameState == 1) {
    // display level 1
    levelLogic(L1, collision1);
  }
  else if (gameState == 2) {
    // display level 2
    levelLogic(L2, collision2);
  }
  else if (gameState == 3) {
    //display level 3
    levelLogic(L3, collision3);
  }
}

void keyPressed() {
  player.keyPressed();
}


void keyReleased() {
  player.keyReleased();
}

void mousePressed() {
  g.mousePressed();
  player.mousePressed();
}

void mouseReleased() {
  player.mouseReleased();
}

// Functions

void levelLogic(Level L, ArrayList<Collision> collisions) {
  background(0);
  camera.move_camera();
  L.displayLevel();
  g.displayHUD(gameState,player.pos);    // eventually pass in player health
  if (startOfLevel) {
    player.updatePos(new PVector(-L.spawns.get(1).x-20,-L.spawns.get(1).y)); // Make this the spawn position
    startOfLevel = false;
    spawnZombies(1);
  }
  
  // Handles all character game objects
  for (Rocket rocket: rockets) {
    rocket.display_move();
    if (rocket.count >= rocket.lifetime) {
      remove_rockets.add(rocket);
    }
  }
  for (Spike spike: spikes) {
    spike.display();
    if (spike.count >= spike.lifetime) {
      remove_spikes.add(spike);
    }
  }
  rockets.removeAll(remove_rockets);
  spikes.removeAll(remove_spikes);
  remove_rockets.clear();
  remove_spikes.clear();
  player.update();
  
  // Handles collisions
  collisionLevel(collisions);
  
  // Handles zombie logic
  for (Zombie zombie : zombies) {
    zombie.move(zombies, player.pos);
    zombie.sufferHunger();
    zombie.display();

    if (zombie.decomposing && !zombie.pelletGenerated) {
      meatPellets.add(zombie.position.copy());
      zombie.pelletGenerated = true;
    }
  }

  for (PVector meatPellet : meatPellets) {
    fill(139, 69, 19);
    ellipse(meatPellet.x, meatPellet.y, 10, 10);
  }
}

void collisionLevel(ArrayList<Collision> collisions) {
  for (Collision collision: collisions) {
    if (collision.water || collision.box) {
      if (showHitbox) {
        noFill();
        stroke(color(0,0,255));
        rect(collision.x,collision.y,collision.w,collision.h);
      }
      if (player.check_collision_square(new PVector(collision.x+collision.w/2,collision.y+collision.h/2), new PVector(collision.w,collision.h))) {
        if (player.isDashing && player.jumpInternalTimer >= player.jumpInternalSeconds * 0.9 ) {
          player.jumpInternalTimer = 0;
        }
        if (!player.isDashing) {
          if (-player.pos.x > collision.x + collision.w) {
            player.vel.x -= player.pixelSize * player.speed/frameRate/player.accelModifier*2;
          }
          else if (-player.pos.x < collision.x) {
            player.vel.x += player.pixelSize * player.speed/frameRate/player.accelModifier*2;
          }
          if (-player.pos.y > collision.y + collision.h) {
            player.vel.y -= player.pixelSize * player.speed/frameRate/player.accelModifier*2;
          }
          else if (-player.pos.y < collision.y) {
            player.vel.y += player.pixelSize * player.speed/frameRate/player.accelModifier*2;
          }
        }
      }
    }
    else {
      if (showHitbox) {
        noFill();
        stroke(255);
        rect(collision.x,collision.y,collision.w,collision.h);
      }
      if (player.check_collision_square(new PVector(collision.x+collision.w/2,collision.y+collision.h/2), new PVector(collision.w,collision.h))) {
        
        if (-player.pos.x > collision.x + collision.w) {
          player.vel.x -= player.pixelSize * player.speed/frameRate/player.accelModifier*2;
        }
        else if (-player.pos.x < collision.x) {
          player.vel.x += player.pixelSize * player.speed/frameRate/player.accelModifier*2;
        }
        if (-player.pos.y > collision.y + collision.h) {
          player.vel.y -= player.pixelSize * player.speed/frameRate/player.accelModifier*2;
        }
        else if (-player.pos.y < collision.y) {
          player.vel.y += player.pixelSize * player.speed/frameRate/player.accelModifier*2;
        }
      }
    }
  }
  for (Zombie zombie: zombies) {
    for (Collision collision: collisions) {
      if (zombie.check_collision_square(new PVector(collision.x+collision.w/2,collision.y+collision.h/2), new PVector(collision.w,collision.h))) {
        if (zombie.position.x > collision.x + collision.w) {
          zombie.velocity.x += zombie.speed;
        }
        else if (zombie.position.x < collision.x) {
          zombie.velocity.x -= zombie.speed;
        }
        if (zombie.position.y > collision.y + collision.h) {
          zombie.velocity.y += zombie.speed;
        }
        else if (zombie.position.y < collision.y) {
          zombie.velocity.y -= zombie.speed;
        }
      }
    }
  }
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



// Zombie functions
void spawnZombies(int numZombies) {
  zombies.clear();
  meatPellets.clear();
  for (int i = 0; i < numZombies; i++) {
    PVector startPosition = new PVector(random(500), random(500));
    zombies.add(new Zombie(startPosition));
  }
}

int countZombiesAlive() {
  int count = 0;
  for (Zombie zombie : zombies) {
    if (zombie.alive) {
      count++;
    }
  }
  return count;
}

void evolveZombies() {
  zombies.sort((z1, z2) -> z2.score - z1.score);

  int topZombiesCount = min(4, zombies.size());
  ArrayList<Zombie> topZombies = new ArrayList<Zombie>();
  for (int i = 0; i < topZombiesCount; i++) {
    topZombies.add(zombies.get(i));
  }

  float avgSize = 0;
  float avgSense = 0;
  float avgSpeed = 0;
  float avgHungerDrain = 0;
  float avgDamage = 0;

  for (Zombie topZombie : topZombies) {
    avgSize += topZombie.size;
    avgSense += topZombie.sense;
    avgSpeed += topZombie.speed;
    avgHungerDrain += topZombie.hungerDrain;
    avgDamage += topZombie.damage;
  }

  avgSize /= topZombiesCount;
  avgSense /= topZombiesCount;
  avgSpeed /= topZombiesCount;
  avgHungerDrain /= topZombiesCount;
  avgDamage /= topZombiesCount;

  mutationRate *= 0.9;

  for (Zombie zombie : zombies) {
    zombie.size = avgSize + random(-mutationRate, mutationRate);
    zombie.sense = avgSense + random(-mutationRate * 10, mutationRate * 10);
    zombie.speed = avgSpeed + random(-mutationRate * 0.1, mutationRate * 0.1);
    zombie.hungerDrain = avgHungerDrain + random(-mutationRate * 0.1, mutationRate * 0.1);
    zombie.damage = avgDamage + random(-mutationRate, mutationRate);
  }
}

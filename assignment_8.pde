boolean showHitbox = false;

ArrayList<Rocket> rockets = new ArrayList<Rocket>();
ArrayList<Rocket> remove_rockets = new ArrayList<Rocket>();
ArrayList<Spike> spikes = new ArrayList<Spike>();
ArrayList<Spike> remove_spikes = new ArrayList<Spike>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<Explosion> remove_explosions = new ArrayList<Explosion>();
ArrayList<Arrow> arrows = new ArrayList<Arrow>();
ArrayList<Arrow> remove_arrows = new ArrayList<Arrow>();
ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<Particle> remove_particles = new ArrayList<Particle>();
ArrayList<Box> boxes = new ArrayList<Box>();
ArrayList<Box> remove_boxes = new ArrayList<Box>();

float[] matrix = {1,0,0,
                  0,1,0,
                  0,0,1}; // Used for manually storing transformations that happen to the world matrix. Processing doesn't have a way that I know of to actually get the matrix to be used by code, so I keep track of my own matrix for use in monitoring positions.
Player player = new Player(matrix, rockets, spikes, arrows);
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
PImage[] splash_sprite = new PImage[3];
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
  String[] initials = loadStrings("initials.txt");
  String[] scores = loadStrings("scores.txt");
  ArrayList<String> keys = new ArrayList<String>();
  ArrayList<String> values = new ArrayList<String>();
  for (int i = 0; i < initials.length; i++) {
    keys.add(initials[i]);
    values.add(scores[i]);
  }
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
    imageName = "explosion" + nf(i+1,1) + ".png";
    player.explosion_sprite[i] = loadImage(imageName);
  }
  for (int i = 0; i < player.numFrames; i++) {
      player.front_sprite_I[i] = player.front_sprite[i].copy();
      player.front_sprite_I[i].loadPixels();
      for (int j = 0; j < player.front_sprite_I[i].pixels.length; j++) {
        color c = player.front_sprite_I[i].pixels[j];
        float a = alpha(c);
        if (a > 0) {
          float r = red(c) * 1.5;
          float g = green(c) * 2;
          float b = blue(c) * 2;
          player.front_sprite_I[i].pixels[j] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
        }
      }
    }
    for (int i = 0; i < player.numFrames; i++) {
      player.side_sprite_I[i] = player.side_sprite[i].copy();
      player.side_sprite_I[i].loadPixels();
      for (int j = 0; j < player.side_sprite_I[i].pixels.length; j++) {
        color c = player.side_sprite_I[i].pixels[j];
        float a = alpha(c);
        if (a > 0) {
          float r = red(c) * 1.5;
          float g = green(c) * 2;
          float b = blue(c) * 2;
          player.side_sprite_I[i].pixels[j] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
        }
      }
    }
    for (int i = 0; i < player.numFrames; i++) {
      player.back_sprite_I[i] = player.back_sprite[i].copy();
      player.back_sprite_I[i].loadPixels();
      for (int j = 0; j < player.back_sprite_I[i].pixels.length; j++) {
        color c = player.back_sprite_I[i].pixels[j];
        float a = alpha(c);
        if (a > 0) {
          float r = red(c) * 1.5;
          float g = green(c) * 2;
          float b = blue(c) * 2;
          player.back_sprite_I[i].pixels[j] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
        }
      }
    }
  player.rocketLauncher_sprite = loadImage("rocketLauncher.png");
  player.rocket_sprite = loadImage("rocket.png");
  player.sword_sprite = loadImage("sword.png");
  player.spike_sprite = loadImage("spike.png");
  player.box_sprite = loadImage("box.png");
  for (int i = 0; i < 3; i++) {
    String imageName = "bow_" + nf(i + 1, 1) + ".png";
    player.bow_sprite[i] = loadImage(imageName);
  }
  player.arrow_sprite = loadImage("arrow.png");
  for (int i = 0; i < 2; i++) {
    String imageName = "wind" + nf(i + 1, 1) + ".png";
    player.wind_sprite[i] = loadImage(imageName);
  }
  
  // Initialize sprites for zombies
  zombieSouthTexture = loadImage("zombie_facing_south.png");
  zombieNorthTexture = loadImage("zombie_facing_north.png");
  zombieEastWestTexture = loadImage("zombie_facing_eastwest.png");
  for (int i = 0; i < 3; i++) {
    String imageName = "splash" + nf(i + 1, 1) + ".png";
    splash_sprite[i] = loadImage(imageName);
  }
}

void draw() {
  // control transitions between levels
  if (countZombiesAlive() == 0 && gameState == 3 && startOfLevel == false) {
    gameState = 20;
    startOfLevel = true;
  }
  else if (countZombiesAlive() == 0 && gameState == 1 && startOfLevel == false) {
    gameState = 10;
    startOfLevel = true;
  }
  else if (countZombiesAlive() == 0 && gameState == 2 && startOfLevel == false) {
    gameState = 11;
    startOfLevel = true;
  }
  
  if (player.health <= 0) {
    gameState = 12;
    player.health = 100;
  }
  
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
  if (gameState == 20) {
    hs.keyPressed();
  }
}

void keyReleased() {
  player.keyReleased();
  if (gameState == 20) {
    hs.keyReleased();
  }
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
  g.displayHUD(gameState,player.pos,player.health);    // eventually pass in player health
  if (startOfLevel) {
    player.updatePos(new PVector(-L.spawns.get(1).x-20,-L.spawns.get(1).y)); // Make this the spawn position
    startOfLevel = false;
    spawnZombies(20);
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
  for (Arrow arrow: arrows) {
    arrow.display_move();
    if (arrow.count >= arrow.lifetime) {
      remove_arrows.add(arrow);
    }
  }
  for (Box box: boxes) {
    box.display();
    if (box.count >= box.lifetime) {
      remove_boxes.add(box);
    }
  }
  rockets.removeAll(remove_rockets);
  spikes.removeAll(remove_spikes);
  arrows.removeAll(remove_arrows);
  boxes.removeAll(remove_boxes);
  remove_rockets.clear();
  remove_spikes.clear();
  remove_arrows.clear();
  remove_boxes.clear();
  player.update();
  
  // Handles wall collisions, zombie to player collisions are handled in the zombie class.
  collisionLevel(collisions);
  
  // Handles zombie logic
  for (Zombie zombie : zombies) {
    zombie.move(zombies, player.pos); // Pass both the zombie list and the player position
    zombie.display();

    if (zombie.decomposing && !zombie.pelletGenerated) {
        meatPellets.add(zombie.position.copy());
        zombie.pelletGenerated = true;
    }
}


  
  // Explosions and particles appear above everything else, so they're handled down here.
  for (Explosion explosion: explosions) {
    explosion.display();
    if (explosion.count >= explosion.lifetime) {
      remove_explosions.add(explosion);
    }
  }
  for (Particle particle: particles) {
    particle.display_move();
    if (particle.count >= particle.lifetime) {
      remove_particles.add(particle);
    }
  }
  explosions.removeAll(remove_explosions);
  particles.removeAll(remove_particles);
  remove_explosions.clear();
  remove_particles.clear();

  for (PVector meatPellet : meatPellets) {
    noStroke();
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
      // Wall to Player collisions
      if (player.check_collision_square(new PVector(collision.x+collision.w/2,collision.y+collision.h/2), new PVector(collision.w,collision.h))) {
        if (player.isDashing && player.jumpInternalTimer >= player.jumpInternalSeconds * 0.9 ) {
          player.jumpInternalTimer = 0;
        }
        if (!player.isDashing) {
          if (-player.pos.x > collision.x + collision.w) {
            player.vel.x -= player.pixelSize * player.speed/frameRate/player.acelModifier*2;
          }
          else if (-player.pos.x < collision.x) {
            player.vel.x += player.pixelSize * player.speed/frameRate/player.acelModifier*2;
          }
          if (-player.pos.y > collision.y + collision.h) {
            player.vel.y -= player.pixelSize * player.speed/frameRate/player.acelModifier*2;
          }
          else if (-player.pos.y < collision.y) {
            player.vel.y += player.pixelSize * player.speed/frameRate/player.acelModifier*2;
          }
        }
      }
      // Wall to GameObject collisions
      for (Rocket rocket: rockets) {
        if (rocket.check_collision_square(new PVector(collision.x+collision.w/2,collision.y+collision.h/2), new PVector(collision.w,collision.h)) && !collision.water) {
          remove_rockets.add(rocket);
          explosions.add(new Explosion(rocket.hitbox,rocket.pixelSize));
        }
      }
      for (Arrow arrow: arrows) {
        if (arrow.check_collision_square(new PVector(collision.x+collision.w/2,collision.y+collision.h/2), new PVector(collision.w,collision.h)) && !collision.water) {
          remove_arrows.add(arrow);
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
          player.vel.x -= player.pixelSize * player.speed/frameRate/player.acelModifier*2;
        }
        else if (-player.pos.x < collision.x) {
          player.vel.x += player.pixelSize * player.speed/frameRate/player.acelModifier*2;
        }
        if (-player.pos.y > collision.y + collision.h) {
          player.vel.y -= player.pixelSize * player.speed/frameRate/player.acelModifier*2;
        }
        else if (-player.pos.y < collision.y) {
          player.vel.y += player.pixelSize * player.speed/frameRate/player.acelModifier*2;
        }
      }
      // Wall to GameObject collisions
      for (Rocket rocket: rockets) {
        if (rocket.check_collision_square(new PVector(collision.x+collision.w/2,collision.y+collision.h/2), new PVector(collision.w,collision.h))) {
          remove_rockets.add(rocket);
          explosions.add(new Explosion(rocket.hitbox,rocket.pixelSize));
        }
      }
      for (Arrow arrow: arrows) {
        if (arrow.check_collision_square(new PVector(collision.x+collision.w/2,collision.y+collision.h/2), new PVector(collision.w,collision.h)) && !collision.water) {
          remove_arrows.add(arrow);
        }
      }
    }
  }
  for (Zombie zombie: zombies) {
    // Zombie wall collisions
    for (Collision collision: collisions) {
      if (zombie.check_collision_square(new PVector(collision.x+collision.w/2,collision.y+collision.h/2), new PVector(collision.w,collision.h))) {
        if (collision.water && zombie.isWinded) {
          zombie.isDrowning = true;
          if (zombie.position.x > collision.x + collision.w) {
            zombie.position.x -= 10;
          }
          else if (zombie.position.x < collision.x) {
            zombie.position.x += 10;
          }
          if (zombie.position.y > collision.y + collision.h) {
            zombie.position.y -= 10;
          }
          else if (zombie.position.y < collision.y) {
            zombie.position.y += 10;
          }
        }
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
    for (Rocket rocket: rockets) {
      if (rocket.check_collision_sphere(zombie.position,zombie.size)) {
        remove_rockets.add(rocket);
        explosions.add(new Explosion(rocket.hitbox,rocket.pixelSize));
      }
    }
    for (Explosion explosion: explosions) {
      if (explosion.check_collision_sphere(zombie.position,zombie.size) && zombie.invincibilityTimer <= 0.0) {
        zombie.health -= explosion.damage;
        zombie.position.add(new PVector((zombie.position.x-explosion.pos.x)*2,(zombie.position.y-explosion.pos.y)*2));
        zombie.invincibilityTimer = 0.4;
      }
    }
    for (Arrow arrow: arrows) {
      if (arrow.check_collision_sphere(zombie.position,zombie.size) && zombie.invincibilityTimer <= 0.0) {
        remove_arrows.add(arrow);
        zombie.health -= arrow.damage;
        zombie.position.add(new PVector(sin(arrow.degree)*arrow.damage*2,-cos(arrow.degree)*arrow.damage*2));
        zombie.invincibilityTimer = 0.4;
      }
    }
    for (Spike spike: spikes) {
      if (zombie.check_collision_sphere(spike.pos,spike.size) && zombie.invincibilityTimer <= 0.0) {
        zombie.health -= spike.damage;
        zombie.invincibilityTimer = 0.4;
      }
    }
    for (Box box: boxes) {
      for (Collision collision: collisions) {
        if (zombie.check_collision_square(new PVector(box.pos.x,box.pos.y), new PVector(box.size,box.size))) {
          if (zombie.position.x > box.pos.x - box.size/2) {
            zombie.velocity.x += zombie.speed;
          }
          else if (zombie.position.x < box.pos.x) {
            zombie.velocity.x -= zombie.speed;
          }
          if (zombie.position.y > box.pos.y - box.size/2) {
            zombie.velocity.y += zombie.speed;
          }
          else if (zombie.position.y < box.pos.y) {
            zombie.velocity.y -= zombie.speed;
          }
        }
      }
    }
  }
  for (Box box: boxes) {
    // Wall to Player collisions
    if (player.check_collision_square(new PVector(box.pos.x,box.pos.y), new PVector(box.size,box.size))) {
      if (player.isDashing && player.jumpInternalTimer >= player.jumpInternalSeconds * 0.9 ) {
        player.jumpInternalTimer = 0;
      }
      if (!player.isDashing) {
        if (-player.pos.x > box.pos.x - box.size/2) {
          player.vel.x -= player.pixelSize * player.speed/frameRate/player.acelModifier*2;
        }
        else if (-player.pos.x < box.pos.x) {
          player.vel.x += player.pixelSize * player.speed/frameRate/player.acelModifier*2;
        }
        if (-player.pos.y > box.pos.y - box.size/2) {
          player.vel.y -= player.pixelSize * player.speed/frameRate/player.acelModifier*2;
        }
        else if (-player.pos.y < box.pos.y) {
          player.vel.y += player.pixelSize * player.speed/frameRate/player.acelModifier*2;
        }
      }
    }
    // Wall to GameObject collisions
    for (Rocket rocket: rockets) {
      if (rocket.check_collision_square(new PVector(box.pos.x,box.pos.y), new PVector(box.size,box.size))) {
        remove_rockets.add(rocket);
        explosions.add(new Explosion(rocket.hitbox,rocket.pixelSize));
      }
    }
    for (Arrow arrow: arrows) {
      if (arrow.check_collision_square(new PVector(box.pos.x,box.pos.y), new PVector(box.size,box.size))) {
        remove_arrows.add(arrow);
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
  L1 = new Level(1,t1.createBackground(),allCollisions.get(0),allSpawns.get(0));
  L2 = new Level(2,t2.createBackground(),allCollisions.get(1),allSpawns.get(1));
  L3 = new Level(3,t3.createBackground(),allCollisions.get(2),allSpawns.get(2));
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
    zombie.damage = avgDamage + random(-mutationRate, mutationRate);
  }
}

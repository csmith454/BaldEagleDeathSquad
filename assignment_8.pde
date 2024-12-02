ArrayList<Rocket> rockets = new ArrayList<Rocket>();
Player player = new Player(rockets);
Camera camera = new Camera(player.pos);

void setup() {
  noSmooth();
  size(1600,800);
  frameRate(60);
  
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
  background(255);
  camera.move_camera();
  fill(255,0,0);
  rect(100,100,100,100);
  rect(-500,-500,100,100);
  rect(-600,0,100,100);
  fill(255);
  for (Rocket rocket: rockets) {
    rocket.display_move();
  }
  player.update();
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

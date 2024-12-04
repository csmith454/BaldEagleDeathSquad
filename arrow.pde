class Arrow {
  PVector pos;
  float degree;
  int pixelSize;
  float vel;
  PImage arrow_sprite;
  float[] matrix;
  PVector hitbox = new PVector(0,0);
  float size;
  float lifetime = 10;
  float count = 0;
  
  Arrow(PVector pos, float degree, PImage sprite, int pixelSize, float[] matrix) {
    this.pos = pos;
    this.degree = degree;
    this.arrow_sprite = sprite;
    this.pixelSize = pixelSize;
    this.vel = pixelSize*3.5;
    this.matrix = matrix;
    size = 12;
  }
  
  void display() {
    pushMatrix();
    translate(-pos.x,-pos.y);
    matrix = this.multMatrix(matrix,new float[] {1,0,-pos.x,
                                                0,1,-pos.y,
                                                0,0,1});
    rotate(degree);
    printMatrix();
    println(matrix);
    translate(-player.pixelSize/2,-player.pixelSize/2);
    matrix = this.multMatrix(matrix,new float[] {1,0,sin(degree) * (player.pixelSize * 0.9),
                                                0,1,-cos(degree) * (player.pixelSize * 0.9),
                                                0,0,1});
    image(arrow_sprite,0,0,player.pixelSize,player.pixelSize);
    popMatrix();
    
    noFill();
    stroke(255);
    ellipse(this.matrix[2],this.matrix[5],size,size); // Hitbox
    
    this.hitbox = new PVector(this.matrix[2],this.matrix[5]);
    matrix = this.multMatrix(matrix,new float[] {1,0,-sin(degree) * (player.pixelSize * 0.9),
                                                0,1,cos(degree) * (player.pixelSize * 0.9),
                                                0,0,1});
    matrix = this.multMatrix(matrix,new float[] {1,0,pos.x,
                                                0,1,pos.y,
                                                0,0,1});
  }
  
  void move() {
    pos.add(new PVector(-(sin(degree)*vel)/frameRate,(cos(degree)*vel)/frameRate));
  }
  
  void display_move() {
    count += 1/frameRate;
    this.display();
    this.move();
  }
  
  boolean check_collision(PVector otherPos, float otherSize) {
    float dist = this.hitbox.dist(otherPos);
    if (dist <= this.size + otherSize) {
      return true;
    }
    return false;
  }
  
  float[] multMatrix(float[] m1, float[] m2) {
    int size = int(sqrt(m1.length));
    float[] returnMatrix;
    returnMatrix = new float[size*size];
    for (int row = 0; row < size; row++) {
      for (int column = 0; column < size; column++) {
        float total = 0;
        for (int i = 0; i < size; i++) {
          total += m1[row*size + i] * m2[i * size + column];
        }
        returnMatrix[row*size + column] = total;
      }
    }
    return returnMatrix;
  }
}

class Zombie {
  PVector position;
  PVector velocity;
  PVector direction;
  
  PVector acceleration;
  float size;
  float hitboxSize;
  float sense;
  float speed;
  float maxForce;
  float hungerDrain;
  float damage;
  int health;
  int hunger;
  boolean alive;
  boolean decomposing;
  boolean pelletGenerated;
  int score;
  boolean facingRight;
  String directionFacing;

  Zombie(PVector startPosition) {
    position = startPosition.copy();
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    direction = velocity.copy().normalize();
    
    size = random(15, 30); // Size influences damage
    sense = random(100, 200); // Sensing radius
    speed = map(size, 30, 15, 0.5, 2.0); // Speed inversely proportional to size
    maxForce = 0.1;
    hungerDrain = map(speed, 0.5, 2.0, 0.5, 2.0); // Hunger drain based on speed
    damage = map(size, 15, 30, 10, 20); // Damage based on size
    health = 5000;
    hunger = 300;
    alive = true;
    decomposing = false;
    pelletGenerated = false;
    score = 0;
    facingRight = true;
    directionFacing = "south";
  }

  void move(ArrayList<Zombie> zombieList, PVector playerPosition) {
    if (!alive) return;
    swarmSense(zombieList, playerPosition);

    hitboxSize = size * 2;
    handleWallCollision();
    if (!alive) return;

    if (PVector.dist(position, new PVector(-playerPosition.x,-playerPosition.y)) < sense) {
      PVector target = PVector.sub(new PVector(-playerPosition.x,-playerPosition.y), position).normalize().mult(speed);
      applyForce(target);
    } else {
      flock(zombieList);
    }

    velocity.add(acceleration);
    velocity.limit(speed);
    position.add(velocity);
    acceleration.mult(0);

    handleCollisions(zombieList, new PVector(-playerPosition.x,-playerPosition.y));

    if (abs(velocity.y) > abs(velocity.x)) {
      if (velocity.y > 0) {
        directionFacing = "south";
      } else {
        directionFacing = "north";
      }
    } else {
      directionFacing = "eastwest";
      facingRight = velocity.x > 0;
    }
  }

  void handleWallCollision() {

    if (position.x < hitboxSize / 2) {
      position.x = hitboxSize / 2;
      velocity.x *= -1;
    } else if (position.x > width - hitboxSize / 2) {
      position.x = width - hitboxSize / 2;
      velocity.x *= -1;
    }
    if (position.y < hitboxSize / 2) {
      position.y = hitboxSize / 2;
      velocity.y *= -1;
    } else if (position.y > height - hitboxSize / 2) {
      position.y = height - hitboxSize / 2;
      velocity.y *= -1;
    }
  }

  void handleCollisions(ArrayList<Zombie> zombieList, PVector playerPosition) {

    for (Zombie other : zombieList) {
      if (other != this && other.alive) {
        float distance = PVector.dist(position, other.position);
        if (distance < hitboxSize) {
          PVector repulsion = PVector.sub(position, other.position).normalize();
          repulsion.mult(0.5);
          applyForce(repulsion);

          float overlap = hitboxSize - distance;
          PVector adjustment = repulsion.copy().mult(overlap * 0.05);
          position.add(adjustment);
          other.position.sub(adjustment);
        }
      }
    }

    float playerDistance = PVector.dist(position, playerPosition);
    if (playerDistance < (hitboxSize / 2) + 15 && playerDistance > size * 0.5) {
      PVector repulsion = PVector.sub(position, playerPosition).normalize();
      repulsion.mult(1);
      applyForce(repulsion);

      float overlap = (size / 2) + (15) - playerDistance;
      PVector adjustment = repulsion.copy().mult(overlap * 0.1);
      position.add(adjustment);

      score++;
    }
  }

  void swarmSense(ArrayList<Zombie> zombieList, PVector playerPosition) {
    if (PVector.dist(position, new PVector(-playerPosition.x,-playerPosition.y)) < sense) {
      for (Zombie other : zombieList) {
        if (other != this && PVector.dist(position, other.position) < sense * 2) {
          other.sensePlayer(new PVector(-playerPosition.x,-playerPosition.y));
        }
      }
    }
  }

  void sensePlayer(PVector playerPosition) {
    if (!alive) return;
    PVector target = PVector.sub(new PVector(-playerPosition.x,-playerPosition.y), position).normalize().mult(speed);
    applyForce(target);
  }

  void flock(ArrayList<Zombie> zombieList) {
    PVector alignment = align(zombieList);
    PVector cohesion = cohesion(zombieList);
    
    PVector separation = separate(zombieList);

    alignment.mult(1.0);
    cohesion.mult(1.0);
    separation.mult(2.0);

    applyForce(alignment);
    applyForce(cohesion);
    applyForce(separation);
  }

  PVector align(ArrayList<Zombie> zombieList) {
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Zombie other : zombieList) {
      if (other != this && other.alive) {
        float d = PVector.dist(position, other.position);
        if (d < sense) {
          sum.add(other.velocity);
          count++;
        }
      }
    }
    if (count > 0) {
      sum.div((float) count);
      sum.normalize();
      sum.mult(speed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      return steer;
    }
    return new PVector(0, 0);
  }

  PVector cohesion(ArrayList<Zombie> zombieList) {
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Zombie other : zombieList) {
      if (other != this && other.alive) {
        float d = PVector.dist(position, other.position);
        if (d < sense) {
          sum.add(other.position);
          count++;
        }
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);
    }
    return new PVector(0, 0);
  }

  PVector separate(ArrayList<Zombie> zombieList) {
    float desiredSeparation = size * 3;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Zombie other : zombieList) {
      float d = PVector.dist(position, other.position);
      if (d > 0 && d < desiredSeparation) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
    }
    if (sum.mag() > 0) {
      sum.normalize();
      sum.mult(speed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      return steer;
    }
    return new PVector(0, 0);
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.normalize();
    desired.mult(speed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    return steer;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void sufferHunger() {
    hunger -= hungerDrain;
    if (hunger <= 0) {
      health -= 1;
      if (health <= 0) {
        alive = false;
        decomposing = true;
      }
    }
  }

  void display() {
    if (decomposing) {
      fill(139, 69, 19);
      ellipse(position.x, position.y, hitboxSize, hitboxSize);
    } else if (alive) {
      pushMatrix();
      translate(position.x, position.y);
      if (directionFacing.equals("eastwest") && facingRight) {
        scale(-1, 1);
      }
      imageMode(CENTER);

      if (directionFacing.equals("south")) {
        image(zombieSouthTexture, 0, 0, size * 2, size * 2);
      } else if (directionFacing.equals("north")) {
        image(zombieNorthTexture, 0, 0, size * 2, size * 2);
      } else {
        image(zombieEastWestTexture, 0, 0, size * 2, size * 2);
      }

      imageMode(CORNER);
      popMatrix();
    }
  }
}

class Zombie {
  PVector position;
  PVector velocity;
  PVector direction;

  PVector acceleration;
  float size;
  float sense;
  float speed;
  float maxForce;
  float damage;
  int health;
  boolean alive;
  boolean decomposing;
  boolean pelletGenerated;
  int score;
  boolean facingRight;
  boolean isSlowed;
  boolean isWinded;
  boolean isDrowning;
  float drownTimer;
  String directionFacing;
  float invincibilityTimer = 0.0;

  Zombie(PVector startPosition) {
    position = startPosition.copy();
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    direction = velocity.copy().normalize();

    size = random(15, 30); // Size influences damage and health
    sense = random(100, 200); // Sensing radius
    speed = map(size, 30, 15, 0.5, 2.0); // Speed inversely proportional to size
    maxForce = 0.1;
    damage = map(size, 15, 30, 10, 20); // Damage based on size
    health = (int) map(size, 15, 30, 50, 100); // Health scales with size
    alive = true;
    decomposing = false;
    pelletGenerated = false;
    score = 0;
    facingRight = true;
    directionFacing = "south";
  }

  void move(ArrayList<Zombie> zombieList, PVector playerPosition) {
    if (invincibilityTimer > 0.0) {
      invincibilityTimer -= 1/frameRate;
    }
    
    if (!alive || isDrowning) return;

    handleWallCollision();
    if (!alive) return;

    if (PVector.dist(position, new PVector(-playerPosition.x, -playerPosition.y)) < sense) {
      PVector target = PVector.sub(new PVector(-playerPosition.x, -playerPosition.y), position).normalize().mult(speed);
      applyForce(target);
    }

    velocity.add(acceleration);
    if (isSlowed) {
      velocity.limit(speed / 2);
    } else {
      velocity.limit(speed);
    }
    velocity.limit(speed);
    position.add(velocity);
    acceleration.mult(0);

    handleCollisions(zombieList, new PVector(-playerPosition.x, -playerPosition.y));

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
    if (position.x < size) {
      position.x = size;
      velocity.x *= -1;
    } else if (position.x > width - size) {
      position.x = width - size;
      velocity.x *= -1;
    }
    if (position.y < size) {
      position.y = size;
      velocity.y *= -1;
    } else if (position.y > height - size) {
      position.y = height - size;
      velocity.y *= -1;
    }
  }

  void handleCollisions(ArrayList<Zombie> zombieList, PVector playerPosition) {
    for (Zombie other : zombieList) {
      if (other != this && other.alive) {
        float distance = PVector.dist(position, other.position);
        if (distance < size * 2) {
          PVector repulsion = PVector.sub(position, other.position).normalize();
          repulsion.mult(0.5);
          applyForce(repulsion);

          float overlap = size * 2 - distance;
          PVector adjustment = repulsion.copy().mult(overlap * 0.05);
          position.add(adjustment);
          other.position.sub(adjustment);
        }
      }
    }

    float playerDistance = PVector.dist(position, playerPosition);
    if (this.check_collision_sphere(playerPosition, player.size)) {
      PVector repulsion = PVector.sub(position, playerPosition).normalize();
      repulsion.mult(1);
      applyForce(repulsion);

      float overlap = (size) + (player.size) - playerDistance;
      PVector adjustment = repulsion.copy().mult(overlap * 0.1);
      position.add(adjustment);

      score++;
      // Player is damaged
      if (!player.invincible) {
        player.hitstunDirection = repulsion;
        player.knockback = damage / 7;
        player.damaged = true;
        player.health -= damage;
      }
    }
    if (this.check_collision_sphere(player.hitBoxPos, player.hitBoxSize) && invincibilityTimer <= 0.0) {
      this.health -= player.swordDamage;
      this.position.add(new PVector((this.position.x+player.pos.x)/2,(this.position.y+player.pos.y)/2));
      invincibilityTimer = 0.4;
    }
  }

  boolean check_collision_sphere(PVector otherPos, float otherSize) {
    float dist = this.position.dist(otherPos);
    if (dist <= this.size / 2 + otherSize / 2) {
      return true;
    }
    return false;
  }

  boolean check_collision_square(PVector otherPos, PVector otherSize) {
    float deltaX = Math.abs(this.position.x - otherPos.x);
    float deltaY = Math.abs(this.position.y - otherPos.y);
    if (deltaX < (this.size / 2 + otherSize.x / 2) && deltaY < (this.size / 2 + otherSize.y / 2)) {
      return true;
    }
    return false;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void display() {
    if (isDrowning) {
      pushMatrix();
      translate(position.x, position.y);
      imageMode(CENTER);
      if (drownTimer <= 0.2) {
        image(splash_sprite[0], 0, 0, size * 1.2, size * 1.2);
      } else if (drownTimer <= 0.4) {
        image(splash_sprite[1], 0, 0, size * 1.2, size * 1.2);
      } else if (drownTimer <= 0.6) {
        image(splash_sprite[2], 0, 0, size * 1.2, size * 1.2);
      } else {
        this.alive = false;
      }
      drownTimer += 1 / frameRate;
      imageMode(CORNER);
      popMatrix();
    } else if (alive) {
      pushMatrix();
      translate(position.x, position.y);
      if (directionFacing.equals("eastwest") && facingRight) {
        scale(-1, 1);
      }
      imageMode(CENTER);

      if (directionFacing.equals("south")) {
        image(zombieSouthTexture, 0, 0, size * 1.2, size * 1.2);
      } else if (directionFacing.equals("north")) {
        image(zombieNorthTexture, 0, 0, size * 1.2, size * 1.2);
      } else {
        image(zombieEastWestTexture, 0, 0, size * 1.2, size * 1.2);
      }
      if (showHitbox) {
        noFill();
        stroke(color(255, 0, 0));
        ellipse(0, 0, size, size);
      }
      imageMode(CORNER);
      popMatrix();
    }
  }
}

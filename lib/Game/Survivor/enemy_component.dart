import 'dart:math';
import 'package:fit_rpg/Game/Survivor/projectile_component.dart';
import 'package:fit_rpg/Game/Survivor/survivor_game.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'player_component.dart';

class EnemyComponent extends SpriteComponent 
with CollisionCallbacks, HasGameReference<SurvivorGame> {

  final PlayerComponent playerRef; // Reference to the player component
  final double speed = 15; // Speed of the enemy
  int health = 1; // Enemy health

  EnemyComponent({
    required this.playerRef,
    required Vector2 gameSize,
  }) : super(size: Vector2(30,30), // Size of the enemy
  ) {
    _spawnAtEdge(gameSize);
  }
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = Sprite(await game.images.load('BossSprite.png'));
    add(RectangleHitbox()..collisionType = CollisionType.active); // Hitbox for collision detection

    print("✅ EnemyComponent initialized at $position");
  }

  Vector2 _spawnAtEdge(Vector2 gameSize) {
    // Spawn enemy at a random position at the top of the screen
    final rand = Random();
    final edge = rand.nextInt(4); // Randomly choose one of the four edges

    switch (edge) {
      case 0: //left edge
        position = Vector2(0, rand.nextDouble() * gameSize.y);
        break;
      case 1: //right edge
        position = Vector2(gameSize.x, rand.nextDouble() * gameSize.y);
        break;
      case 2: //top edge
        position = Vector2(rand.nextDouble() * gameSize.x, 0);
        break;
      case 3: //bottom edge
        position = Vector2(rand.nextDouble() * gameSize.x, gameSize.y);
        break;
      default:
        position = Vector2.zero(); // shouldn't happen
        break;
    }
    return position;
  }

  void takeDamage(int amount) {
    health -= amount;
    if(health <= 0) {
      removeFromParent(); // death animation can be placed here
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    final toPlayer = playerRef.position - position; // Vector to the player
    if (toPlayer.length != 0) {
      final direction = toPlayer.normalized(); // Normalize the vector
      position += direction * speed * dt; // Move towards the player
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is PlayerComponent) {
      removeFromParent(); // Remove enemy on collision with player
      //Let the player handle the collision HP
      return;
    }

    if (other is ProjectileComponent) {
      takeDamage(1); // projectile damage to enemy
      other.removeFromParent();
    }
  }
}
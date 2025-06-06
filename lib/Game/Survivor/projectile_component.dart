import 'package:fit_rpg/Game/Survivor/enemy_component.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/Game/Survivor/survivor_game.dart';

class ProjectileComponent extends SpriteComponent
with CollisionCallbacks, HasGameReference<SurvivorGame>{
  
  final Vector2 velocity; // direction * speed
  late Sprite _arrowSprite;

  ProjectileComponent({
    required Vector2 startPosition,
    required this.velocity,
  }) : super(
    position: startPosition.clone(),
    anchor: Anchor.center,
  );
  

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _arrowSprite = Sprite(await game.images.load('arrow.png'));
    sprite = _arrowSprite;
    size = Vector2(32,32);
    anchor = Anchor.center;

    final hitbox = CircleHitbox(isSolid: false, radius: size.x / 2)..collisionType = CollisionType.passive;
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // Remove projectile offscreen
    final screenBounds = game.size;
    if(position.x < 0 || position.y < 0 ||
        position.x > screenBounds.x || position.y > screenBounds.y) {
          removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is EnemyComponent) {
      removeFromParent(); // destroy projectile on hit
    }
  }
}
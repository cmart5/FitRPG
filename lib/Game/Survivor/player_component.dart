import 'dart:math' as math;

import 'package:fit_rpg/Game/Survivor/enemy_component.dart';
import 'package:fit_rpg/Game/Survivor/projectile_component.dart';
import 'package:fit_rpg/Game/Survivor/survivor_game.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';

class PlayerComponent extends SpriteComponent
    with KeyboardHandler, CollisionCallbacks, HasGameReference<SurvivorGame> {

      int health = 3; // Player's health
      double speed = 200; // Player's movement speed in pixels per second
      final Set<LogicalKeyboardKey> _keys = {}; // Track currently pressed keys
      Vector2? _target;

      Vector2 _joystickDirection = Vector2.zero();
      double _joystickIntensity = 0.0;

      late Sprite _idleSprite;
      late Sprite _shootSprite;

      double _projectileCD = 3.0; // Time between shots
      double _timeSinceShot = 0.0; // Counter
      double _shootFrameDuration = 0.25;
      double _shootFrameTimer = 0.0;
      bool _isShooting = false;

      PlayerComponent({
        required Vector2 position,
        required Vector2 size,
      }) : super(
        position: position,
        size: size,
        anchor: Anchor.center, // Center the player sprite
        priority: 1, // Render above enemies
      ) {
      }

      @override
      Future<void> onLoad() async {
        await super.onLoad();

        _idleSprite = Sprite(await game.images.load('player_sprite_idle_top.png'));
        _shootSprite = Sprite(await game.images.load('player_sprite_shoot_top.png'));

        sprite = _idleSprite;

        add(RectangleHitbox()..collisionType = CollisionType.active); // Hitbox for collision detection

        print("✅ PlayerComponent initialized at $position");
      }

      // Called every frame, Use dt (delta time) to move smoothly
      @override
      void update(double dt) {
        super.update(dt);

        Vector2 moveVector = Vector2.zero();
        // Keyboard movement
        if (_keys.isNotEmpty) {
          if (_keys.contains(LogicalKeyboardKey.keyA) || _keys.contains(LogicalKeyboardKey.arrowLeft)) {
            moveVector.x -= 1;
          }
          if (_keys.contains(LogicalKeyboardKey.keyD) || _keys.contains(LogicalKeyboardKey.arrowRight)) {
            moveVector.x += 1;
          }
          if (_keys.contains(LogicalKeyboardKey.keyW) || _keys.contains(LogicalKeyboardKey.arrowUp)) {
            moveVector.y -= 1;
          }
          if (_keys.contains(LogicalKeyboardKey.keyS) || _keys.contains(LogicalKeyboardKey.arrowDown)) {
            moveVector.y += 1;
          }
        } else if (_joystickIntensity > 0) {
          // Joystick input
          moveVector = _joystickDirection * _joystickIntensity;
        } else if (_target != null) {
          // Tap-to-move
          moveVector = _target! - position;
          if (moveVector.length < 5) {
            _target = null;
            moveVector = Vector2.zero();
          }
        }

        // Apply movement
        if (moveVector.length != 0) {
          moveVector.normalize();
          position += moveVector * speed * dt;
          final half = size / 2;
          position.clamp(half, game.size - half);
        }

        _timeSinceShot += dt;
        if(_timeSinceShot >= _projectileCD) {
          _timeSinceShot = 0;
          _isShooting = true;
          _shootFrameTimer = 0.0;
          
          sprite = _shootSprite;

          final enemies = game.children.whereType<EnemyComponent>().toList();
          if(enemies.isNotEmpty) {
            enemies.sort((a, b) =>
              a.position.distanceTo(position).compareTo(
              b.position.distanceTo(position))
            );
            final closest = enemies.first;
            final directionToEnemy = (closest.position - position).normalized();
            final rawAngle = math.atan2(directionToEnemy.y, directionToEnemy.y);
            final playerAngle = rawAngle + math.pi/2; // Want sprite angle to = 0, adjust accordingly
            angle = playerAngle;

            final projectileVelocity = directionToEnemy * 500; // Speed 200/s
            final proj = ProjectileComponent(
              startPosition: position + directionToEnemy,
              velocity: projectileVelocity,
            );
            proj.angle = math.atan2(directionToEnemy.y, directionToEnemy.x) + math.pi/2;
            game.add(proj); // add to world
          }
        }

        if (_isShooting) {
          _shootFrameTimer += dt;
          if(_shootFrameTimer >= _shootFrameDuration) {
            _isShooting = false;
            sprite = _idleSprite;
          }
        }

        if(!_isShooting) {
          final enemies = game.children.whereType<EnemyComponent>().toList();
          if (enemies.isNotEmpty) {
            enemies.sort((a, b) =>
              a.position.distanceTo(position)
                .compareTo(b.position.distanceTo(position))
            );
            final closest = enemies.first;
            final directionToEnemy = (closest.position - position).normalized();
            final rawAngle = math.atan2(directionToEnemy.y, directionToEnemy.x);
            angle = rawAngle + math.pi / 2;
          }
        }
      }

      void setKeyboardMovement(Set<LogicalKeyboardKey> keysPressed) {
        _keys
          ..clear()
          ..addAll(keysPressed);
        // Cancel any tap-to-move target:
        _target = null;
      }

      void setTouchTarget(Vector2 worldPos) {
        _target = worldPos;
        _keys.clear();
      }

      void setJoystick(Vector2 direction, double intensity) {
        _joystickDirection = direction;
        _joystickIntensity = intensity;
        _keys.clear();
        _target = null;
      }


      // Handle touch input, public method to trigger movement toward a tapped location
      void moveToward(Vector2 destination) {
        _target = destination;
      }

      // Handle collision with enemies
      @override
      void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
        super.onCollision(intersectionPoints, other);

        if(other is EnemyComponent) {
          health -= 1;
          other.removeFromParent(); // Remove enemy on collision

          if(health <= 0) {
            // Handle player death
            removeFromParent(); // Remove player from game
            print(" 💀 Player has died!"); // For debugging, replace with game over logic

            // trigger a game over screen/reset the game state
            final survivorGame = findParent<SurvivorGame>();
            survivorGame?.gameOver();
          }        
        }
      }
    }
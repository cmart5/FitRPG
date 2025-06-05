import 'package:fit_rpg/Game/Survivor/enemy_component.dart';
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

        sprite = Sprite(await game.images.load('WarriorSprite.png'));
        add(RectangleHitbox()..collisionType = CollisionType.active); // Hitbox for collision detection

        print("✅ PlayerComponent initialized at $position");
      }

      // Called every frame, Use dt (delta time) to move smoothly
      @override
      void update(double dt) {
        super.update(dt);

        Vector2 moveVector = Vector2.zero();
        // Priority 1: Keyboard movement
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
        }

        // Priority 2: Touch movement
        if (_keys.isEmpty && _target != null) {
          moveVector = _target! - position;
          if (moveVector.length < 5) {
            _target = null;
            moveVector = Vector2.zero();
          }
        }

        if (moveVector.length != 0) {
          moveVector.normalize();
          // Because speed is pixels/second and dt is seconds/frame, multiplying them gives pixels/frame.
          position += moveVector * speed * dt;

          // Clamp to game bounds
          final halfSize = size / 2;
          position.clamp(halfSize, game.size - halfSize);
        }
      }

      // Handle key presses
      @override
      bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
        _keys
          ..clear()
          ..addAll(keysPressed);
        return true;
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
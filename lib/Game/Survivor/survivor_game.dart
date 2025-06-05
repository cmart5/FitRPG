import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';          // Base class FlameGame
import 'package:flame/input.dart';         // For keyboard/touch input
import 'package:flutter/material.dart';    // For Color, etc.

import 'package:fit_rpg/Game/Survivor/enemy_component.dart';
import 'package:fit_rpg/Game/Survivor/player_component.dart';


// SurvivorGame is our main FlameGame subclass. It controls -
// the game loop (update & render), spawns enemies, and tracks how long the player has survived.
class SurvivorGame extends FlameGame 
    with HasCollisionDetection, HasKeyboardHandlerComponents, TapDetector {

  PlayerComponent? player;

  double survivalTime = 0.0; // Time survived in seconds
  double spawnInterval = 2.0; // Time between enemy spawns
  double _timeSinceLastSpawn = 0.0; // Timer for enemy spawning
  bool gameReady = false; // track explicitly when the game is safe to run game logic

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: Vector2(412, 915)); // Set the game resolution
    final worldSize = camera.viewport.size; // Get the world size from the viewport
    //final sprite = Sprite(await Flame.images.load('WarriorSprite.png')); // Load player sprite image
    // This means the “world” is 800×600 units, and Flame scales it to your device.
    player = PlayerComponent(
      position: worldSize / 2, // Center the player
      size: Vector2(50, 50), // Player size
    );

    add(player!); // Add the player to the game
    gameReady = true; // mark as ready and safe
    print('✅ Player registered: ${player}');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameReady) return;

    
    if (player == null) {
      // If player is still not found, we can't continue
      return;
    }
    survivalTime += dt; // Increment survival time
    _timeSinceLastSpawn += dt; // Increment spawn timer

    if(_timeSinceLastSpawn >= spawnInterval) {
      _timeSinceLastSpawn -= spawnInterval; // Reset spawn timer
      
      // Speed up spawning over time every 10 seconds down to 0.5 seconds lowest
      if(survivalTime > 10 && spawnInterval > 0.5) {
        spawnInterval -= 0.2; // Increase spawn rate every 10 seconds
      }

      // Spawn a new enemy at a random position at top of screen
      final enemy = EnemyComponent(playerRef: player!, gameSize: size);
      add(enemy); // Add a new enemy to the game
    }
  }

  // Render the UI overlays on top of the game
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!gameReady) return;

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Time: ${survivalTime.toStringAsFixed(1)}s',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      textDirection: TextDirection.ltr, // Text direction for the text painter
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 30)); // Draw the survival time at the top-left corner

    // Draw the player's health bar
    // Safely render HP text only if player is initialized:
    
      final healthPainter = TextPainter(
        text: TextSpan(
          text: 'HP: ${player!.health}',
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 24,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      healthPainter.layout();
      healthPainter.paint(canvas, Offset(10, 50));
    }

  /// If we want to handle taps (e.g., to shoot or dash), we could override onTapDown:
  @override
  void onTapDown(TapDownInfo info) {
    // Convert the screen‐touch position to world coordinates:
    final worldPosition = info.eventPosition.global;
    player?.moveToward(worldPosition);
    // debug
    print("Tapped at: $worldPosition");
    // e.g. player.shootAt(worldTouchPos);
  }

  void gameOver() {
    pauseEngine(); // Freeze the game loop
    overlays.add('GameOverOverlay');
  }

  void reset() {
    children.whereType<EnemyComponent>().forEach((enemy) => enemy.removeFromParent());
    player = null;
    survivalTime = 0;
    spawnInterval = 2.0;
    _timeSinceLastSpawn = 0;
    gameReady = false;

    resumeEngine();
    onLoad();
  }
}
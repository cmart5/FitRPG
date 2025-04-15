import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for key events

class FitRPGGame extends FlameGame with KeyboardEvents 
{
  late SpriteComponent character;
  double speed = 150; // Movement speed
  Vector2 velocity = Vector2.zero(); // Track movement direction

  @override
  Future<void> onLoad() async 
  {
    character = SpriteComponent()
      ..sprite = await loadSprite('slimeBlock.png') // Load from assets
      ..size = Vector2(100, 100) // Set sprite size
      ..position = Vector2(size.x / 2, size.y - 150); // Start at bottom center

    add(character);
  }

  @override
  void update(double dt) 
  {
    super.update(dt);

    // Apply movement
    character.position.add(velocity * speed * dt);

    // Keep the character within screen bounds
    character.x = character.x.clamp(0, size.x - character.width);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Reset velocity before checking pressed keys
    velocity = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      velocity.x = -1; // Move left
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      velocity.x = 1; // Move right
    }

    return KeyEventResult.handled;
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: FitRPGGame(),
    );
  }
}

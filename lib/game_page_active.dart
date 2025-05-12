import 'package:flutter/material.dart';
import 'package:fit_rpg/game_sprite.dart'; // Flame game logic

class GamePageActive extends StatelessWidget {
  const GamePageActive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitRPG - Active'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const GameScreen()),
      ),
    );
  }
}

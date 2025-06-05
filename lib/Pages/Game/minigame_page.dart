import 'package:fit_rpg/Game/Survivor/survivor_game.dart';
import 'package:fit_rpg/Pages/Game/game_widgets.dart';
import 'package:fit_rpg/Pages/Main/adventure_page.dart';
import 'package:fit_rpg/Pages/Main/hub_page.dart';
import 'package:fit_rpg/Services/audio_service.dart';
import 'package:fit_rpg/Services/widgets_ui.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MinigamePage extends StatefulWidget {
  const MinigamePage({super.key});

  @override
  State<MinigamePage> createState() => _MinigamePageState();
}

class _MinigamePageState extends State<MinigamePage> {

  final SurvivorGame _survivorGame = SurvivorGame();

  @override
  void initState() {
    super.initState();
    AudioService().setTheme(GameAudio.battleBackground); // Set the background music theme
  }

  @override
  void dispose() {
    _survivorGame.onRemove(); // Properly dispose of the game instance
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget<SurvivorGame>(
            game: _survivorGame,
            overlayBuilderMap: {
              'GameOverOverlay': (context, game) => GameOverOverlay(
                onRetry: () {
                  game.overlays.remove('GameOverOverlay');
                  game.reset();                  
                },
                onExit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HubPage()),
                    ); // Return
                }
              )
            },
          ),
        ],
      ),
    );
  }
}
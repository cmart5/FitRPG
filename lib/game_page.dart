import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_rpg/game_state.dart';
import 'package:fit_rpg/game_sprite.dart';

class GamePage extends StatefulWidget {
  final bool triggerDelayedXP;
  const GamePage({super.key, this.triggerDelayedXP = false});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Map<String, int> displayedXP = {};
  Map<String, int> displayedLevels = {};

  @override
  void initState() {
    super.initState();

    final gameState = Provider.of<GameState>(context, listen: false);
    displayedXP = Map.from(gameState.skillXP); 
    displayedLevels = Map.from(gameState.skillLevels); 

    if (widget.triggerDelayedXP) {
      Future.delayed(const Duration(milliseconds: 1500), () async {
        await gameState.applyPendingXPWithDelay();
        setState(() {
          displayedXP = Map.from(gameState.skillXP);
          displayedLevels = Map.from(gameState.skillLevels);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitRPG - Game'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // XP Display
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: gameState.skillXP.keys.map((skill) {
                  final startXP = displayedXP[skill] ?? 0;
                  final targetXP = gameState.skillXP[skill] ?? 0;
                  final skillLevel = gameState.skillLevels[skill] ?? 1;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$skill: Level $skillLevel - ',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TweenAnimationBuilder<int>(
                          tween: IntTween(begin: startXP, end: targetXP),
                          duration: const Duration(seconds: 1),
                          builder: (_, value, __) {
                            return Text(
                              'XP: $value',
                              style: const TextStyle(fontSize: 18),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // The Game Screen (Sprite Display)
          const SizedBox(height: 20),
          SizedBox(
            height: 200, // Adjust size as needed
            child: GameScreen(), // Embed the Flame game
          ),
        ],
      ),
    );
  }
}

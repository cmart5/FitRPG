import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_rpg/game_state.dart';
import 'package:fit_rpg/game_page_active.dart';

class GamePageStatic extends StatelessWidget {
  const GamePageStatic({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitRPG - Stats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Enter Active Game',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GamePageActive()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Your Skills", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Expanded(
            child: ListView(
              children: gameState.skillXP.keys.map((skill) {
                final xp = gameState.skillXP[skill] ?? 0;
                final level = gameState.skillLevels[skill] ?? 1;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$skill: Level $level', style: const TextStyle(fontSize: 18)),
                      Text('XP: $xp', style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_rpg/game_state.dart';

class GamePageStatic extends StatelessWidget 
{
  const GamePageStatic({super.key});

  Widget xpBar(double percent) {
    return Container(
      width: 200, // full width of the bar
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent,
                child: Image.asset(
                  'assets/images/XP_Bar.png',
                  fit: BoxFit.cover,
                  height: 20,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ],
        ),
      );
    }


  @override
  Widget build(BuildContext context) 
  {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitRPG - Stats'),
        actions: [],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Your Skills", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              children: gameState.skillXP.keys.map((skill) 
              {
                final xp = gameState.skillXP[skill] ?? 0;
                final level = gameState.skillLevels[skill] ?? 1;
                final xpToLevel = level * 100; // XP needed for next level
                final xpPercent = xp / xpToLevel;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$skill: Level $level',
                            style: const TextStyle(fontSize: 24),
                          ),
                          Text(
                            'XP: $xp / $xpToLevel',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      xpBar(xpPercent.clamp(0.0, 1.0)),
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

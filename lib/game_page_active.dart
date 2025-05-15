import 'package:flutter/material.dart';
import 'package:fit_rpg/battle_scene.dart';

class GamePageActive extends StatefulWidget {
  const GamePageActive({super.key});

  @override
  State<GamePageActive> createState() => _GamePageActiveState();
}

class _GamePageActiveState extends State<GamePageActive> {
  late BattleScene game;
  String battleLog = "A wild boss appears!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/FitRPG_StatBG.png',
              fit: BoxFit.cover,
            ),
          ),

          // Game
          Column(
            children: [
              Expanded(
                child: BattleSceneWidget(
                  onGameReady: (gameRef) => game = gameRef, //
                ),
              ),

              // Battle log
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  battleLog,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        game.playTackleAnimation();
                        setState(() {
                          battleLog = "You tackled the boss!";
                        });
                      },
                      child: const Text("Attack"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          battleLog = "You healed!";
                        });
                      },
                      child: const Text("Heal"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

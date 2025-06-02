import 'package:fit_rpg/Services/audio_service.dart';
import 'package:fit_rpg/Game/battler_service.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/Game/battle_scene.dart';

class GamePageActive extends StatefulWidget {
  const GamePageActive({super.key});

  @override
  State<GamePageActive> createState() => _GamePageActiveState();
}

enum BattlePhase {
  playerTurn,
  enemyTurn,
  victory,
  defeat,
}

class _GamePageActiveState extends State<GamePageActive> {

  @override
  void initState() {
    super.initState();
    // Initialize the game scene
    AudioService().setTheme(GameAudio.battleBackground);
  }

  int playerHP = 100;
  int enemyHP = 100;
  BattlePhase phase = BattlePhase.playerTurn;

  late BattleScene game;
  String battleLog = "A wild boss appears!";

  void enemyTurn() {
  if (phase != BattlePhase.enemyTurn) return;
  game.playTackleAnimationEnemy();

  Future.delayed(const Duration(milliseconds: 200), () {
    setState(() {    
      playerHP -= 15;
      battleLog = 'The enemy hits you for 15 dmg!';
      if (playerHP <= 0) {
        phase = BattlePhase.defeat;
        battleLog = 'You suck!';
      } else {
        phase = BattlePhase.playerTurn;
      }
    });
  }); 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game world — BattleScene with its own background
          Positioned.fill(
            child: BattleSceneWidget(
              onGameReady: (gameRef) => game = gameRef,
            ),
          ),

          // Battle log & menu overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Battle log
                Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    battleLog,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'pixelFont',
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  color: const Color.fromARGB(180, 0, 0, 0),
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Player HP: $playerHP',
                          style: const TextStyle(color: Colors.white, fontSize: 18)),
                      Text('Enemy HP: $enemyHP',
                          style: const TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),

                // Menu container
                BattleMenuContainer(
                  onCommandSelected: (command) {
                    if (phase != BattlePhase.playerTurn) return;

                    if (command == 'Normal Attack') {
                      setState(() {
                        game.playTackleAnimation();

                        Future.delayed(const Duration(milliseconds: 200), () {
                          setState(() {
                            enemyHP -= 20;
                            battleLog = 'You attack the enemy for 20 damage!';
                            if(enemyHP <= 0) {
                              phase = BattlePhase.victory;
                              battleLog = 'Victory! Enemy Defeated!';
                            } else {
                              phase = BattlePhase.enemyTurn;
                            }
                          });
                        });
                      });

                      Future.delayed(const Duration(seconds: 1), enemyTurn);
                    }

                    if(command.contains('Run')) {
                      setState(() {
                        battleLog = 'You fled safely from the fight!';
                        Navigator.pop(context); //Leave page
                      });
                    }
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

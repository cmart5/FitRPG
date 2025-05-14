import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_rpg/game_state.dart';

class GamePageStatic extends StatefulWidget 
{
  final bool triggerDelayedXP;
  const GamePageStatic({super.key, this.triggerDelayedXP = false});
  
  @override
  State<GamePageStatic> createState() => _GamePageStaticState();
}

class _GamePageStaticState extends State<GamePageStatic>
{
  @override
  void initState()
  {
    super.initState();

    if (widget.triggerDelayedXP) {
      Future.delayed(const Duration(milliseconds: 1500), () async{
        final gameState = Provider.of<GameState>(context, listen: false);
        await gameState.applyPendingXPWithDelay();
        await gameState.saveToCloud();
        setState(() {});
      }); 
    }  
  }
  
  @override
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
                          TweenAnimationBuilder<int>( // Animate XP value
                            tween: IntTween(
                              begin: gameState.recentlyUpdatedSkills.contains(skill) ? 0 : xp,
                              end: xp,
                            ),
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeOutExpo,
                            builder: (context, animatedXP, _) {
                              return Text('XP: $animatedXP / $xpToLevel', style: TextStyle(
                                fontSize: 20,
                                color: xpPercent >= 1.0 ? Colors.green : Colors.white,
                              ));
                            }
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      TweenAnimationBuilder<double>( // Animate XP bar
                        tween: Tween<double>(
                          begin: gameState.recentlyUpdatedSkills.contains(skill) ? 0.0 : xpPercent,
                          end: xpPercent.clamp(0.0, 1.0),
                        ),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return xpBar(value); // Pass the animated value to xpBar
                        },
                      ),
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

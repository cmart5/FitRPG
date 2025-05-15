import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_rpg/game_state.dart';

class GamePageStatic extends StatefulWidget 
{
  final bool triggerDelayedXP; // Flag to trigger delayed XP application
  const GamePageStatic({super.key, this.triggerDelayedXP = false}); 
  
  @override
  State<GamePageStatic> createState() => _GamePageStaticState();
}

class _GamePageStaticState extends State<GamePageStatic>
{
  Map<String, int> previousXP = {}; // Store previous XP values

  @override
  void initState()
  {
    super.initState();
    final gameState = Provider.of<GameState>(context, listen: false); // Initialize game state
    previousXP = Map.from(gameState.skillXP); // Store initial XP values

    if (widget.triggerDelayedXP) { // Check if delayed XP application is triggered
      Future.delayed(const Duration(milliseconds: 1500), () async{
        final gameState = Provider.of<GameState>(context, listen: false);
        await gameState.applyPendingXPWithDelay(); // Apply pending XP with delay
        await gameState.saveToCloud(); // Save to cloud
        setState(() {}); // Trigger a rebuild to reflect changes
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
            ClipRRect( // Change the rectagle based on the percent
              borderRadius: BorderRadius.circular(4), // round the corners
              child: FractionallySizedBox( // Use FractionallySizedBox to fill the bar
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
      resizeToAvoidBottomInset: false, // Prevent automatic layout resize
      extendBodyBehindAppBar: true, // Extend body behind AppBar      
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/FitRPG_StatBG.png',
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: .25), // Dark overlay
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent, // Make the AppBar transparent
            elevation: 0, // Remove shadow
            foregroundColor: Colors.white, // Set icon color to white
          ),
          // Foreground content
          Column(
            children: [
              const SizedBox(height: 75),
              const Text("Your Skills", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
              //const SizedBox(height: 10),

              Expanded(
                child: ListView(
                  children: gameState.skillXP.keys.map((skill) 
                  {
                    final xp = gameState.skillXP[skill] ?? 0;
                    final level = gameState.skillLevels[skill] ?? 1;
                    final xpToLevel = level * 100; // XP needed for next level
                    final xpPercent = xp / xpToLevel;

                    final oldXP = previousXP[skill] ?? xp; // Get the old XP value
                    final rolledOver = xp < oldXP; // Check if XP rolled over

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
                                  begin: gameState.recentlyUpdatedSkills.contains(skill) ? 0 : xp, // Start from 0 if recently updated
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
                              begin: gameState.recentlyUpdatedSkills.contains(skill) ? 0.0 : xpPercent, // Start from 0 if recently updated
                              end: xpPercent.clamp(0.0, 1.0), // Ensure the value is between 0 and 1
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
        ],
      ),
    );
  }
}

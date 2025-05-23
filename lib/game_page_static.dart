import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:fit_rpg/game_state.dart';

class GamePageStatic extends StatefulWidget 
{
  final bool triggerDelayedXP; // Flag to trigger delayed XP application
  const GamePageStatic({super.key, this.triggerDelayedXP = false}); 
  
  @override
  State<GamePageStatic> createState() => _GamePageStaticState();
}

class SkillProgressRow extends StatelessWidget { // Widget to display skill progress
  final String skill; // Skill name
  final int xp; // Current XP
  final int level; // Current level
  final bool recentlyUpdated; // Flag to indicate if the skill was recently updated
  final Widget bar; // XP bar widget

  const SkillProgressRow({ // Constructor
    super.key, // Key for the widget
    required this.skill, 
    required this.xp,
    required this.level,
    required this.recentlyUpdated,
    required this.bar,
  });

  @override
  Widget build(BuildContext context) {
    final xpToLevel = level * 100; // XP needed for next level
    final int gainedXP = recentlyUpdated ? xp : 0; // XP gained if recently updated
    final int animationDuration = (gainedXP * 10).clamp(400, 2000); // Animation duration based on gained XP

    return Padding(
      padding: const EdgeInsets.symmetric( vertical : 6, horizontal: 20), 
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
              TweenAnimationBuilder<int>(
                tween: IntTween(
                  begin: recentlyUpdated ? 0 : xp, // Start from 0 if recently updated, else from current XP
                  end: xp, // End at current XP
                ),
                duration: Duration(milliseconds: animationDuration), // Animation duration
                curve: Curves.easeOutExpo, // Animation curve
                builder: (context, animatedXP, _) { // Animate XP value
                  return Text( 
                    'XP: $animatedXP / $xpToLevel', // Display XP value
                    style: TextStyle(
                      fontSize: 20,
                      color: (xp / xpToLevel) >= 1.0 // Check if XP is maxed out
                          ? Colors.green // Change color to green if maxed out
                          : Colors.black, // Default color
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          bar, // XP bar widget
        ],
      ),
    );
  }
}

// What? Gives your state object the ability to create an AnimationController that “ticks” (drives frames) using a single internal ticker.
// Why? Any time you animate something smoothly over time, you need a ticker. This mixin wires up lifecycle so Flutter can call you on each frame.
class _GamePageStaticState extends State<GamePageStatic> with SingleTickerProviderStateMixin 
{
  late final AnimationController _controller;
  final Map<String, Animation<double>> _rolloverAnims = {};
  Map<String, int> previousXP = {}; // Store previous XP values

  @override
  void initState()
  {
    super.initState();
    // Store the current snapshot
    final gameState = Provider.of<GameState>(context, listen: false); // Initialize game state
    final previousXP = Map.from(gameState.skillXP); // Store initial XP values
    final previousLevels = Map.from(gameState.skillLevels); // Store initial levels

    //Create the controller for a 2-second playback
    _controller = AnimationController(
      vsync: this, // uses ticker provider mixin
      duration: const Duration(seconds: 2),
    );

    // if triggering (from ActivityPage), schedule rollout ->
    if (widget.triggerDelayedXP) { // Check if delayed XP application is triggered
      Future.delayed(const Duration(milliseconds: 1500), () async{
        // Apply pendingXP
        await gameState.applyPendingXPWithDelay(); // Apply pending XP with delay
        await gameState.saveToCloud(); // Save to cloud

        // Build TweenSequences for each skill leveling up
        _rolloverAnims.clear();
        print('recentlyUpdatedSkills: ${gameState.recentlyUpdatedSkills}');
        for (final skill in gameState.recentlyUpdatedSkills) {
          final oldLevel = previousLevels[skill]!;
          final newLevel = gameState.skillLevels[skill]!;

          if(newLevel > oldLevel) { // Only animate if level increased
            // XP values
            final oldXP = previousXP[skill]!;
            final newXP = gameState.skillXP[skill]!;
            

            // thresholds
            final oldThresh = (newLevel - 1) * 100;
            final newThresh = newLevel * 100;

            // % for tween endpoints
            final oldPercent = oldXP/oldThresh;
            final newPercent = newXP/newThresh;

            //Construct 2phase tween(animation): fill -> full, then 0 -> rolloverXP
            final tweenSeq = TweenSequence<double>([
              TweenSequenceItem(
                tween: Tween<double>(
                  begin: oldPercent,
                  end: 1.0)
                  .chain(CurveTween(curve: Curves.easeOut)),
                weight: 1,
              ),
              TweenSequenceItem(
                tween: Tween(
                  begin: 0.0,
                  end: newPercent)
                  .chain(CurveTween(curve: Curves.easeIn)),
                weight: 1,
                ),
            ]);

            // Attach to single controller
            _rolloverAnims[skill] = tweenSeq.animate(_controller);
          }
        }

        // Animation
        setState(() {}); // let build() see new map
        _controller.forward(from: 0.0); // run 2second sequence
      }); 
    }  
  }

  @override
  void dispose() { // clean up controllers to prevent mem leaks and excess resources
    _controller.dispose();
    super.dispose();
  }
  
  Widget xpBar(double percent) {
    return Container(
      width: 200, // full width of the bar
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
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
              'assets/images/Stats_BG.png',
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: .125), // Dark overlay
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent, // Make the AppBar transparent
            elevation: 0, // Remove shadow
            foregroundColor: Colors.black, // Set icon color to white
          ),
          // Foreground content
          Column(
            children: [
              const SizedBox(height: 75),
              const Text("Your Skills", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),

              Expanded(
                child: ListView(
                  children: gameState.skillXP.keys.map((skill) {
                    final xp = gameState.skillXP[skill] ?? 0;
                    final level = gameState.skillLevels[skill] ?? 1;
                    final xpToLevel = level * 100; // XP needed for next level
                    final xpPercent = (xp / xpToLevel).clamp(0.0, 1.0); // 0-100%
                    final recently = gameState.recentlyUpdatedSkills.contains(skill);

                    Widget barWidget;
                    if(_rolloverAnims.containsKey(skill)) {
                      // If rollover animation was built for skill
                      final anim = _rolloverAnims[skill]!;
                      barWidget = AnimatedBuilder(
                        animation: anim,
                        builder: (context, _) => xpBar(anim.value),
                      );
                    } else {
                      // If no rollover animation, use default bar
                      barWidget = TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: recently ? 0.0 : xpPercent, // Start from 0 if recently updated, else from current XP percent
                          end: xpPercent // End at current XP percent
                          ),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, _) => xpBar(value), // Call the xpBar method to create the bar
                      );
                    } 

                    return SkillProgressRow(
                      skill: skill,
                      xp: xp,
                      level: level,
                      recentlyUpdated: recently,
                      bar: barWidget, // Pass the bar widget
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

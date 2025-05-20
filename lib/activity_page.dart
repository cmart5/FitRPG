import 'package:fit_rpg/game_page_static.dart';
import 'package:fit_rpg/game_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityPage extends StatefulWidget 
{
  const ActivityPage({super.key});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> 
{
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  int steps = 0;
  int calories = 0;
  int duration = 0; // in minutes

  String? selectedSkill; // Track the selected skill
  final List<String> skills = [ // List of skills
    "Health",
    "Attack",
    "Strength",
    "Defence",
    "Agility",
    "Crafting",
    "Smithing",
  ];

  @override
  void initState() 
  {
    super.initState();
    _loadActivityData();
  }

  Future<void> _loadActivityData() async 
  {
    final prefs = await SharedPreferences.getInstance();
    setState(() 
    {
      steps = prefs.getInt('steps') ?? 0;
      calories = prefs.getInt('calories') ?? 0;
      duration = prefs.getInt('duration') ?? 0;

      // Pre-fill text fields with saved values
      _stepsController.text = steps.toString();
      _caloriesController.text = calories.toString();
      _durationController.text = duration.toString();
    });
  }

  Future<void> _saveActivityData() async 
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps', steps);
    await prefs.setInt('calories', calories);
    await prefs.setInt('duration', duration); 
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold( // Scaffold to provide basic material design layout
      resizeToAvoidBottomInset: false, // Prevent automatic layout resize
      body: Stack( // Stack to allow background image
      children: [
        MediaQuery.removeViewInsets(
          context: context,
          removeBottom: true, // Remove bottom inset to prevent keyboard overlap
        // Background image
          child: Positioned.fill( // Fill the entire screen with the background image
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.025),
                BlendMode.lighten,
              ),
              child: Image.asset(
                'assets/images/FitRPG_ActivityBG.png',
                fit: BoxFit.cover,  
              ),
            ),
          ),
        ),
        SafeArea( // Safe fixed height scrollable area
          child: Column( // Column to stack widgets vertically
            children: [
              const SizedBox(height: 20),
              Expanded( // Expanded to fill available space
                child: SingleChildScrollView( // Scrollable area for the content
                  padding: const EdgeInsets.all(16),
                  child: Column( // Column to stack widgets vertically
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center( // Centered title
                        child: Text(
                          "Acitivty Tracker",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Enter your workout manually.",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _stepsController,
                        style: const TextStyle(
                          fontSize: 24
                        ),
                        decoration: const InputDecoration(
                          labelText: "Steps",
                          labelStyle: TextStyle(
                          fontSize: 24
                        ),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _caloriesController,
                        style: const TextStyle(
                          fontSize: 24
                        ),
                        decoration: const InputDecoration(
                          labelText: "Calories",
                          labelStyle: TextStyle(
                          fontSize: 24
                        ),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _durationController,
                        style: const TextStyle(
                          fontSize: 24
                        ),
                        decoration: const InputDecoration(
                          labelText: "Duration (minutes)",
                          labelStyle: TextStyle(
                          fontSize: 24
                        ),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      // End of input fields
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Choose which Skill to Apply XP to:",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                            childAspectRatio: 3.0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                            children: skills.map((skill) {
                              final isSelected = selectedSkill == skill;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSkill = isSelected ? null : skill;
                                  });
                                },
                                child: Card(
                                  color: isSelected ? Colors.blueAccent : const Color.fromARGB(65, 0, 0, 0),
                                  elevation: isSelected ? 8 : 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: BorderSide(
                                      color: isSelected ? Colors.white : Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        skill,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'pixelFont',
                                          color: isSelected ? Colors.white : Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Save Button
                      ElevatedButton(
                        onPressed: () 
                        {
                          final steps = int.tryParse(_stepsController.text) ?? 0; // Get from the text field,
                          final calories = int.tryParse(_caloriesController.text) ?? 0; // set to 0 if empty
                          final duration = int.tryParse(_durationController.text) ?? 0;
                          final gameState = Provider.of<GameState>(context, listen: false);
                          final totalXP = gameState.calculateXP(selectedSkill!, steps, calories, duration); // Calculate XP based on activity

                          if(selectedSkill != null && totalXP > 0){
                            gameState.queueActivityXP(selectedSkill!, totalXP); // Queue the XP, dont apply it yet
                          }
                          Navigator.push( 
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GamePageStatic(triggerDelayedXP: true),
                            ),
                          );
                        },
                        child: const Text("Save Activity", style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
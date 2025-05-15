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

  void _updateValues(BuildContext context) 
  {
    setState(()
    {
      steps = int.tryParse(_stepsController.text) ?? 0; 
      calories = int.tryParse(_caloriesController.text) ?? 0;
      duration = int.tryParse(_durationController.text) ?? 0;
    });
    Provider.of<GameState>(context, listen: false).applyActivityXP(steps, calories, duration);
    _saveActivityData();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold( // Scaffold to provide basic material design layout
      resizeToAvoidBottomInset: false, // Prevent automatic layout resize
      body: Stack( // Stack to allow background image
      children: [
        // Background image
        Positioned.fill( // Fill the entire screen with the background image
          child: Image.asset(
            'assets/images/FitRPG_ActivityBG.png',
            fit: BoxFit.cover,
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
                        decoration: const InputDecoration(
                          labelText: "Steps",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _caloriesController,
                        decoration: const InputDecoration(
                          labelText: "Calories",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _durationController,
                        decoration: const InputDecoration(
                          labelText: "Duration (minutes)",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      // End of input fields
                      const SizedBox(height: 20),
                      // Save Button
                      ElevatedButton(
                        onPressed: () 
                        {
                          final steps = int.tryParse(_stepsController.text) ?? 0; // Get from the text field
                          final calories = int.tryParse(_caloriesController.text) ?? 0;
                          final duration = int.tryParse(_durationController.text) ?? 0;
                          final gameState = Provider.of<GameState>(context, listen: false);

                          gameState.queueActivityXP(steps, calories, duration); // Queue the XP, dont apply it yet

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
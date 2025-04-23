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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Activity Tracker',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // Steps Input
        _buildInputField("Steps", _stepsController),
        // Calories Input
        _buildInputField("Calories Burned", _caloriesController),
        // Duration Input
        _buildInputField("Workout Duration (mins)", _durationController),

        const SizedBox(height: 20),

        // Save Button
        ElevatedButton(
          onPressed: () 
          {
            final steps = int.tryParse(_stepsController.text) ?? 0;
            final calories = int.tryParse(_caloriesController.text) ?? 0;
            final duration = int.tryParse(_durationController.text) ?? 0;

            final gameState = Provider.of<GameState>(context, listen: false);
            gameState.queueActivityXP(steps, calories, duration);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GamePageStatic(),
              ),
            );
          },
          child: const Text("Save Activity"),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) 
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
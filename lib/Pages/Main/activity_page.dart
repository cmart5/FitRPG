import 'package:fit_rpg/Services/audio_service.dart';
import 'package:fit_rpg/Services/fitness_service.dart';
import 'package:fit_rpg/Pages/Game/skills_page.dart';
import 'package:fit_rpg/Game/game_stats.dart';
import 'package:fit_rpg/Services/widgets_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityPage extends StatefulWidget 
{
  const ActivityPage({super.key});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> 
{  
  @override
  void initState() 
  {
    super.initState();
    _loadActivityData();
    AudioService().setTheme(GameAudio.mainBackground); // Set the background music theme
  }

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
      extendBodyBehindAppBar: true, // Extend body behind AppBar      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack( // Stack to allow background image
      children: [
        MediaQuery.removeViewInsets(
          context: context,
          removeBottom: true, // Remove bottom inset to prevent keyboard overlap
        // Background image
          child: Positioned.fill( // Fill the entire screen with the background image
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white.withAlpha(32),
                BlendMode.lighten,
              ),
              child: Image.asset(
                'assets/images/Activity_BG.png',
                fit: BoxFit.cover,  
              ),
            ),
          ),
        ),
        SafeArea( // Safe fixed height scrollable area
          child: Column( // Column to stack widgets vertically
            children: [
              const SizedBox(height: 0),
              Expanded( // Expanded to fill available space
                child: SingleChildScrollView( // Scrollable area for the content
                  padding: EdgeInsets.all(16.w),
                  child: Column( // Column to stack widgets vertically
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center( // Centered title
                        child: Text(
                          "Acitivty Tracker",
                          style: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.h),
                      Text(
                        "Enter your daily stats here.",
                        style: TextStyle(fontSize: 32.sp, color: Colors.black),
                      ),
                      SizedBox(height: 0.h),
                      TextField(
                        onTap: () {
                          Feedback.forTap(context); // Provide haptic feedback
                          AudioService().playSFX('touch.wav'); // Play button click sound
                        },
                        controller: _stepsController,
                        style: TextStyle(
                          fontSize: 24.sp
                        ),
                        decoration: InputDecoration(
                          labelText: "Total Steps",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 24.sp
                        ),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        onTap: () {
                          Feedback.forTap(context); // Provide haptic feedback
                          AudioService().playSFX('touch.wav'); // Play button click sound
                        },
                        controller: _caloriesController,
                        style: TextStyle(
                          fontSize: 24.sp
                        ),
                        decoration: InputDecoration(
                          labelText: "Active Calories",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 24.sp
                        ),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20.h),
                      TextField(
                        onTap: () {
                          Feedback.forTap(context); // Provide haptic feedback
                          AudioService().playSFX('touch.wav'); // Play button click sound
                        },
                        controller: _durationController,
                        style: TextStyle(
                          fontSize: 24.sp
                        ),
                        decoration: InputDecoration(
                          labelText: "Total Workout Duration (minutes)",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 24.sp
                        ),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      // End of input fields
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          ElevatedButton(
                            onPressed: () async {
                              Feedback.forTap(context); // Provide haptic feedback
                              AudioService().playSFX('touch.wav'); // Play button click sound
                              final data = await HealthService.getTodayActivity();
                              setState(() {
                                _stepsController.text = data['steps'].toString();
                                _caloriesController.text = data['calories'].toString();
                                _durationController.text = data['duration'].toString();
                              });
                            },
                            child: Text("Sync with Health App", style: TextStyle(fontSize: 20.sp)),
                          ),
                          SizedBox(height: 20.h),
                          FrostedText(
                            sigmaX: 6.w,
                            sigmaY: 6.h,
                            color: Colors.white.withAlpha(0),
                            child: Text(
                            "Choose which Skill to Apply XP to:",
                            style: TextStyle(fontSize: 24.sp, color: Colors.black),
                            ),
                          ),
                          GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 30.0.w, 
                            mainAxisSpacing: 3.0.h, 
                            childAspectRatio: 2.0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                            children: skills.map((skill) {
                              final isSelected = selectedSkill == skill;

                              return GestureDetector(
                                onTap: () {
                                  Feedback.forTap(context); // Provide haptic feedback
                                  //AudioService().playCardSFX('touch.wav'); // Play button click sound
                                  setState(() {
                                    selectedSkill = isSelected ? null : skill;
                                  });
                                },
                                child: Card(
                                  color: isSelected ? Colors.blueAccent : Colors.black.withAlpha(150),
                                  elevation: isSelected ? 8 : 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r),
                                    side: BorderSide(
                                      color: isSelected ? Colors.white : Colors.grey,
                                      width: 2.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(0.w),
                                      child: Text(
                                        skill,
                                        style: TextStyle(
                                          fontSize: 20.sp,
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
                      SizedBox(height: 10.h),
                      // Save Button
                      ElevatedButton(
                        onPressed: () async {
                          AudioService().playSFX('touch.wav'); // Play button click sound
                          final steps = int.tryParse(_stepsController.text) ?? 0; // Get from the text field,
                          final calories = int.tryParse(_caloriesController.text) ?? 0; // set to 0 if empty
                          final duration = int.tryParse(_durationController.text) ?? 0;
                          final gameState = Provider.of<GameState>(context, listen: false);
                          final totalXP = gameState.calculateXP(selectedSkill!, steps, calories, duration); // Calculate XP based on activity

                          if(selectedSkill != null && totalXP > 0){
                            gameState.queueActivityXP(selectedSkill!, totalXP); // Queue the XP, dont apply it yet
                            //await gameState.applyPendingXPWithDelay(); // Apply the XP with a delay
                            await gameState.updateOrInsertUserSkill(selectedSkill!); // Upsert the skill to the database
                          }

                          Navigator.push( 
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GamePageStatic(triggerDelayedXP: true),
                            ),
                          );
                        },
                        child: Text("Save Activity", style: TextStyle(fontSize: 20.sp)),
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
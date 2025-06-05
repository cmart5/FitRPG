import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class GameState extends ChangeNotifier 
{
  final supabase = Supabase.instance.client;
  bool needsCloudSync = false;
  bool hasLoaded = false;

  GameState()
   {
    _loadGameData();
  }

  Map<String, int> skillXP = 
  {
    'Health': 0,
    'Attack': 0,
    'Strength': 0,
    'Defence': 0,
    'Agility': 0,
    'Crafting': 0,
    'Smithing': 0,
  };

  Map<String, int> pendingXP = 
  {
    'Health': 0,
    'Attack': 0,
    'Strength': 0,
    'Defence': 0,
    'Agility': 0,
    'Crafting': 0,
    'Smithing': 0,
  };

  Map<String, int> skillLevels =
  {
    'Health': 1,
    'Attack': 1,
    'Strength': 1,
    'Defence': 1,
    'Agility': 1,
    'Crafting': 1,
    'Smithing': 1,
  };

  // Calculate XP based on activity
  // This function takes the skill name, number of steps, calories burned, and duration of activity
  int calculateXP(String skill, int steps, int calories, int duration) {

    // Calculate XP based on activity
    double stepsMath = (steps / 1000 * 10); // => 10 XP per 1000 steps
    double caloriesMath = (calories / 100 * 5); // => 5 XP per 100 calories
    double durationMath = (duration / 5 * 2); // => 2 XP per 5 minutes

    // Calculate total XP gained from activity
    double xpSum = (stepsMath + caloriesMath + durationMath);
    // => 17 xp per 1000 steps, 100 calories, and 5 minutes. => High-end: 17 * 10 = 170 XP.

  return xpSum.round(); // Round to nearest whole number
  }

  void queueActivityXP(String skill, int xpAmount) 
  {
    if (pendingXP.containsKey(skill)) 
    {
      pendingXP[skill] = xpAmount; // Set the pending XP for this skill
    }
  }

  Set<String> recentlyUpdatedSkills = {};

  Future<void> applyPendingXPWithDelay() async {    
    recentlyUpdatedSkills.clear();
    await Future.delayed(const Duration(seconds: 1));
    
    for (var entry in pendingXP.entries) {
      final skill = entry.key;
      final gained = entry.value;
      final oldXP    = skillXP[skill]!;            // XP before applying
      final oldLevel = skillLevels[skill]!;        // level before applying
      final xpNeeded = _xpToLevelUp(oldLevel);     // threshold for that level

      if (gained > 0) {
        // Only animate rollover if we actually hit or exceed the threshold:
        if (oldXP + gained >= xpNeeded) {
          recentlyUpdatedSkills.add(skill);
        }

        gainXP(skill, gained);
        pendingXP[skill] = 0;
      }
      print('recentlyUpdatedSkills: $recentlyUpdatedSkills');
    }       
    notifyListeners();
  }

  int _xpToLevelUp(int level) 
  {
    return level * 100; // Incremental XP req for Level UP
  }  

  void gainXP(String skill, int amount) async { 
    final gainedXP = amount; // Store gained XP for later use
    if (!skillXP.containsKey(skill)) return; // Check if skill exists

    skillXP[skill] = (skillXP[skill] ?? 0) + amount; // Add XP to skill

    // Loop while we can still level up
    while (true) {
      final currentLevel = skillLevels[skill] ?? 1; // Get current level
      final xpToLevel = _xpToLevelUp(currentLevel); // Calculate XP needed for next level
      final int animationDuration = (gainedXP * 10).clamp(400, 2000); // Animation duration based on gained XP

      if (skillXP[skill]! >= xpToLevel) { // Check if enough XP to level up

        recentlyUpdatedSkills.add(skill); // Add skill to recently updated skills
        notifyListeners(); // Notify listeners for UI update
        await Future.delayed(Duration(milliseconds: animationDuration)); // Delay for animation

        // Calculate leftover XP after leveling up
        int leftoverXP = (skillXP[skill]! - xpToLevel).clamp(0, skillXP[skill]!);
        skillXP[skill] = 0; // Reset XP for this skill
        skillLevels[skill] = currentLevel + 1; // Increment level
        notifyListeners(); // Notify listeners for UI update

        await Future.delayed(Duration(milliseconds: animationDuration)); // Delay for animation

        skillXP[skill] = leftoverXP;
        recentlyUpdatedSkills.add(skill); // Add skill to recently updated skills
        notifyListeners(); // Notify listeners for UI update
      } 
      else { // If not enough XP, break the loop
        break;
      }
    }
    notifyListeners();
    _saveGameData();
  }

  /// Update or insert a single skill for the current user in Supabase
  Future<void> updateOrInsertUserSkill(String skill) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final xp = skillXP[skill] ?? 0;
    final level = skillLevels[skill] ?? 1;

    try {
      // Check if the row exists
      final existing = await supabase
          .from('user_skills')
          .select()
          .eq('user_id', userId)
          .eq('skill_name', skill)
          .maybeSingle();

      print('🧠 Saving skill: $skill with XP=$xp, Level=$level');
      print('📥 Checking if exists in Supabase...');

      if (existing != null) {
        // Update if exists
        await supabase
            .from('user_skills')
            .update({'xp': xp, 'level': level})
            .eq('user_id', userId)
            .eq('skill_name', skill);
        print('Skill $skill updated successfully in Supabase');
      } else {
        // Insert if not exists
        await supabase
            .from('user_skills')
            .insert({
              'user_id': userId,
              'skill_name': skill,
              'xp': xp,
              'level': level,
            });
        print('Skill $skill inserted successfully in Supabase');
      }
      print('👁️ Existing row: $existing');
    } catch (e) {
      print('Error updating/inserting $skill in Supabase: $e');
    }
  }

  Future<void> _saveGameData() async {
    final online = await _isOnline(); // Check if online
    final prefs = await SharedPreferences.getInstance(); // Get local storage instance
    final userId = supabase.auth.currentUser?.id; // Get the current user ID

    print("User ID: ${Supabase.instance.client.auth.currentUser?.id}");

    if (userId == null) return; // If user is not logged in, do not save data

    for (var skill in skillXP.keys) { // Always save XP and level for each skill locally
      prefs.setInt('${skill}_xp', skillXP[skill]!);
      prefs.setInt('${skill}_level', skillLevels[skill]!);
    }

    print("Starting save to Supabase...");

    if(!online) {
      print("Offline: saving data to local storage");
      needsCloudSync = true;
    }

    final rows = skillXP.keys.map((skill) {
      return {
        'user_id': userId,
        'skill_name': skill,
        'xp': skillXP[skill],
        'level': skillLevels[skill],
      };
    }).toList();

    final response = await Supabase.instance.client
      .from('user_skills')
      .upsert(rows);

    if (response?.error != null) {
      print('Error saving XP data to Supabase: ${response?.error!.message}'); 
      needsCloudSync = true; // Set flag to true if there's an error
    } else {
      print('XP data saved successfully to Supabase');
      needsCloudSync = false; // Reset flag if save is successful
    }
  }

  // Save game data to cloud (public method)
  // This method can be called from anywhere in the app
  Future<void> saveToCloud() async {
    await _saveGameData();
  }

  Future<void> loadGameData() async {
    if(hasLoaded) {
      print('Game Data has already been loaded - skipping');
      return;
    }

    await _loadGameData();

    hasLoaded = true;
  }

  //
  Future<void> _loadGameData() async
   {
    //Future<bool> _isOnline() async => true;
    final online = await _isOnline(); // Check if online

    if (online) {
      print('Online: loading data from Supabase');  

      final userId = Supabase.instance.client.auth.currentUser?.id; // Get the current user ID
      print("🧠 Loading XP for user: $userId");
      if (userId == null) { return; } // If user is not logged in, do not load data

      try {
        final response = await Supabase.instance.client // Load XP data from Supabase
          .from('user_skills')
          .select()
          .eq('user_id', userId);

        // Clear current data first
        skillXP.updateAll((key, _) => 0);
        skillLevels.updateAll((key, _) => 1);

        for (final row in response) {
          final skill = row['skill_name'] as String;
          final xp = row['xp'] as int;
          final level = row['level'] as int;

          if (skillXP.containsKey(skill)) {
            skillXP[skill] = xp;
            skillLevels[skill] = level;
          } 
          else {
            print('Unknown skill: $skill');
          }
        }
            } catch (e) {
        print('Error loading XP data: $e');
      }
    } else { // If offline, load data from local storage
      print('Offline: loading data from local storage');
      final prefs = await SharedPreferences.getInstance();

      for (var skill in skillXP.keys) { // Iterate through each skill
        final xp = prefs.getInt('${skill}_xp') ?? 0; // Get the XP for this skill
        final level = prefs.getInt('${skill}_level') ?? 1; // Get the level for this skill

        skillXP[skill] = xp; // Save XP for each skill
        skillLevels[skill] = level; // Save level for each skill
      }
    }
    notifyListeners();
    print ('XP data loaded successfully');
  }

  Future<bool> _isOnline() async { // Check if the device is online
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) return false;

      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) return false;

      return true;
    } catch (e) {
      print("❌ Network check failed: $e");
      return false;
    }
  }
  void clear() {
    skillXP.updateAll((key, value) => 0);
    skillLevels.updateAll((key, value) => 1);
    pendingXP.updateAll((key, value) => 0);
    hasLoaded = false;
    print("🧹 GameState cleared");
  }
}

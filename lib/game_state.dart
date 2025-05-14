import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GameState extends ChangeNotifier 
{
  final supabase = Supabase.instance.client;

  GameState()
   {
    _loadGameData();
    //_startIdleXP();
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

  void queueActivityXP(int steps, int calories, int duration) 
  {
    pendingXP['Agility'] = (steps / 10).round();   // Steps contribute to Agility XP
    pendingXP['Attack'] = (steps / 100).round();   // Steps contribute to Attack XP
    pendingXP['Health'] = (steps / 50).round();   // Steps contribute to Attack XP
    pendingXP['Strength'] = (calories / 15).round(); // Calories burned contribute to Strength XP
    pendingXP['Defence'] = (calories / 10).round(); // Calories burned contribute to Defence XP
    pendingXP['Crafting'] = (duration / 5).round();   // Workout time contributes to Crafting XP
    pendingXP['Smithing'] = (duration / 5).round();   // Workout time contributes to Smithing XP
  }

  void applyActivityXP(int steps, int calories, int duration) 
  {
    gainXP('Agility', (steps / 10).round());   // Steps contribute to Agility XP
    gainXP('Attack', (steps / 100).round());   // Steps contribute to Attack XP
    gainXP('Health', (steps / 50).round());   // Steps contribute to Health XP
    gainXP('Strength', (calories / 15).round()); // Calories burned contribute to Strength XP
    gainXP('Defence', (calories / 10).round()); // Calories burned contribute to Defence XP
    gainXP('Crafting', (duration / 5).round());   // Workout time contributes to Crafting XP
    gainXP('Smithing', (duration / 5).round());   // Workout time contributes to Smithing XP
  }

  Set<String> recentlyUpdatedSkills = {};

  Future<void> applyPendingXPWithDelay() async 
  {
    recentlyUpdatedSkills.clear();
    await Future.delayed(const Duration(seconds: 1));
    
    for (var skill in pendingXP.keys) { // Iterate through each skill

      final gained = pendingXP[skill] ?? 0; // Get the pending XP for this skill

      if(gained > 0) { // Check if there's pending XP
        skillXP[skill] = (skillXP[skill] ?? 0) + gained; // Apply pending XP

        if (skillXP[skill]! >= _xpToLevelUp(skillLevels[skill]!)) // Check if level up
        {
          _levelUp(skill); // Level up the skill
        }
      }
      pendingXP[skill] = 0; // Reset pending XP for this skill
    }    
    notifyListeners();
  }

  int _xpToLevelUp(int level) 
  {
    return level * 100; // Incremental XP req for Level UP
  }  

  void gainXP(String skill, int amount) 
  {
    if (skillXP.containsKey(skill))
     {
      skillXP[skill] = (skillXP[skill] ?? 0) + amount;
      if (skillXP[skill]! >= _xpToLevelUp(skillLevels[skill]!)) 
      {
        _levelUp(skill);
      }
      notifyListeners();
      _saveGameData();
    }
  }

  void _levelUp(String skill) 
  {
    skillXP[skill] = 0;
    skillLevels[skill] = (skillLevels[skill] ?? 1) + 1;
    notifyListeners();
    _saveGameData();
  }  

  Future<void> _saveGameData() async {
    final userId = supabase.auth.currentUser?.id; // Get the current user ID
    print("User ID: ${Supabase.instance.client.auth.currentUser?.id}");
    if (userId == null) return; // If user is not logged in, do not save data


    final prefs = await SharedPreferences.getInstance();

    print("Starting save to Supabase...");

    for (var skill in skillXP.keys) { // Iterate through each skill
      final xp = skillXP[skill]!; // Get the XP for this skill
      final level = skillLevels[skill]!; // Get the level for this skill

      final response = await Supabase.instance.client
        .from('user_skills') // Save to Supabase
        .upsert({
          'user_id': userId,
          'skill_name': skill,
          'xp': xp,
          'level': level,
        },
        onConflict: 'user_id,skill_name'
      );

      // Log if there's an error
      if (response.error != null) {
         print("Error saving $skill: ${response.error!.message}");
      } else {
         print("Saved $skill successfully.");
      }

      // Save XP and level for each skill locally
      prefs.setInt('${skill}_xp', skillXP[skill]!);
      prefs.setInt('${skill}_level', skillLevels[skill]!);
    }
  }

  Future<void> saveToCloud() async {
    await _saveGameData();
  }

  Future<void> _loadGameData() async
   {
    final prefs = await SharedPreferences.getInstance();
    for (var skill in skillXP.keys) 
    {
      skillXP[skill] = prefs.getInt('${skill}_xp') ?? 0;
      skillLevels[skill] = prefs.getInt('${skill}_level') ?? 1;
    }
    notifyListeners();
  }


}

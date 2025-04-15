import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameState extends ChangeNotifier 
{
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

  GameState()
   {
    _loadGameData();
    _startIdleXP();
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

  int _xpToLevelUp(int level) 
  {
    return level * 100; // Incremental XP req for Level UP
  }

  void _startIdleXP()
   {
    Timer.periodic(const Duration(seconds: 5), (timer) 
    {
      for (var skill in skillXP.keys) 
      {        
        gainXP(skill, 5);
      }
    });
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

  Future<void> applyPendingXPWithDelay() async 
  {
    await Future.delayed(const Duration(seconds: 1));
    
    for (var skill in pendingXP.keys) {
      skillXP[skill] = (skillXP[skill] ?? 0) + pendingXP[skill]!; // Ensure stacking
      pendingXP[skill] = 0;

      if (skillXP[skill]! >= _xpToLevelUp(skillLevels[skill]!)) 
      {
        _levelUp(skill);
      }
    }
    
    notifyListeners();
  }

  Future<void> _saveGameData() async {
    final prefs = await SharedPreferences.getInstance();
    for (var skill in skillXP.keys) {
      prefs.setInt('${skill}_xp', skillXP[skill]!);
      prefs.setInt('${skill}_level', skillLevels[skill]!);
    }
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

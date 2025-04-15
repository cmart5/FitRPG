import 'package:flutter/material.dart';
import 'package:fit_rpg/game_page.dart';
import 'package:fit_rpg/activity_page.dart';

class HomePage extends StatelessWidget 
{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(title: const Text('FitRPG - Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              const ActivityPage(), // ActivityPage is now directly displayed
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () 
              {
                // Navigate to fitness tracking page (to be created later)
              },
              child: const Text('Open Fitness Tracker'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: ()
               {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const GamePage()),// Navigate to game page
                );
              },
              child: const Text('Open RPG Game'),
            ),
          ],
        ),
      ),
    );
  }
}

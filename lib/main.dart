import 'package:fit_rpg/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_rpg/game_state.dart';
import 'package:fit_rpg/home_page.dart';
import 'package:fit_rpg/window_manager.dart';

void main() async
{
  runApp(
    WindowManagerInitializer(
      child: ChangeNotifierProvider(
        create: (context) => GameState(),
        child: const FitRPGApp(),
      ),
    ),
  );
}

class FitRPGApp extends StatelessWidget 
{
  const FitRPGApp({super.key});

  // Widget is the application layout
  // MaterialApp is the main widget for Flutter apps, providing navigation and theming
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'FitRPG',
      theme: ThemeData.dark(),
      home: const MainNavigation(), //MainNavigation is the main screen of the app, which contains the bottom navigation bar
    );
  }
}
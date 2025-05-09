import 'package:fit_rpg/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_rpg/game_state.dart';
import 'package:fit_rpg/home_page.dart';
import 'package:fit_rpg/window_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that the Flutter engine is initialized before running the app
  // Initialize Supabase client with URL and API key
  await Supabase.initialize(
    url: 'https://hqgepaqroxfukxbtrpkb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxZ2VwYXFyb3hmdWt4YnRycGtiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY3MDk1NTksImV4cCI6MjA2MjI4NTU1OX0.jNAzar8L9X2m9F58q23fzOTkPsL3ysgSTU-oiWH8k6k',
  );
  //await Supabase.instance.client.auth.recoverSession('your-refresh-token-here'); // Attempt to recover the session if it exists

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
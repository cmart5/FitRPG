import 'package:fit_rpg/Services/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_rpg/Game/game_stats.dart';
import 'package:fit_rpg/Services/window_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return ScreenUtilInit(
      designSize: const Size(1344, 2992), // Set to match your emulator's original design
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'FitRPG',
          theme: ThemeData.dark().copyWith(
            textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'pixelFont', // Custom font for the app
              bodyColor: Colors.black, // Text color
              displayColor: Colors.black, // Text color for display    
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 180, 180, 180), // Button fill color
                foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Text (and icon) color
                textStyle: const TextStyle(
                  fontFamily: 'pixelFont',
                  fontSize: 32,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4), // Sharp corners for retro feel
                ),
              ),
            ),
          ),

          home: const AuthGate(), // Main entry point of the app, where the authentication gate is displayed
        );
      },
    );
  }
}
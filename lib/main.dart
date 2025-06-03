import 'package:fit_rpg/Services/auth_gate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_rpg/Game/game_stats.dart';
import 'package:fit_rpg/Services/window_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
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

class FitRPGApp extends StatelessWidget {
  const FitRPGApp({super.key});

  // Widget is the application layout
  // MaterialApp is the main widget for Flutter apps, providing navigation and theming
  @override
   Widget build(BuildContext context) {
    // We’re using ScreenUtilInit to scale text/padding/etc. based on a design size of 412x915
    return ScreenUtilInit(
      designSize: const Size(412, 915),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // If we are on the web, wrap our entire MaterialApp inside a box of max 375x812
        if (kIsWeb) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 375,
                maxHeight: 812,
              ),
              child: MaterialApp(
                title: 'FitRPG',
                theme: _buildDarkTheme(),
                home: const AuthGate(),
              ),
            ),
          );
        } else {
          // Otherwise (mobile/desktop), just return the MaterialApp as before
          return MaterialApp(
            title: 'FitRPG',
            theme: _buildDarkTheme(),
            home: const AuthGate(),
          );
        }
      },
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'pixelFont',
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 180, 180, 180),
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          textStyle: TextStyle(
            fontFamily: 'pixelFont',
            fontSize: 32.sp,
          ),
          padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 8.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
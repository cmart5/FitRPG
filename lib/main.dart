import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_rpg/game_state.dart';
import 'package:fit_rpg/home_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(375, 812), // iPhone 13 size (mobile-like)
    minimumSize: Size(375, 812),
    maximumSize: Size(375, 812),
    center: true,
    //titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async
   {
    await windowManager.show();
    await windowManager.focus();
  });


  runApp(
    ChangeNotifierProvider(create: (context) => GameState(),
    child: const FitRPGApp(),
    ),
  );
}

class FitRPGApp extends StatelessWidget 
{
  const FitRPGApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'FitRPG',
      theme: ThemeData.dark(),
      home: const HomePage(), //Homepage as main screen
    );
  }
}
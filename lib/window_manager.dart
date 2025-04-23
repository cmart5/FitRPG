import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io' show Platform;

class WindowManagerInitializer extends StatefulWidget 
{
  final Widget child;
  const WindowManagerInitializer({super.key, required this.child});

  @override
  State<WindowManagerInitializer> createState() => _WindowManagerInitializerState();
}

class _WindowManagerInitializerState extends State<WindowManagerInitializer> with WindowListener 
{
  @override
  void initState() {
    super.initState();
    _initWindow();
  }

  Future<void> _initWindow() async
   {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS))
     {
      WidgetsFlutterBinding.ensureInitialized();
      await windowManager.ensureInitialized();

      WindowOptions options = const WindowOptions(
        size: Size(375, 812),
        minimumSize: Size(375, 812),
        maximumSize: Size(375, 812),
        center: true,
      );

      windowManager.waitUntilReadyToShow(options, () async
       {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return widget.child;
  }
}

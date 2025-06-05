import 'package:fit_rpg/Pages/Game/skills_page.dart';
import 'package:fit_rpg/Pages/Main/activity_page.dart';
import 'package:fit_rpg/Pages/Main/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/Pages/Game/turnbased_page.dart';
import 'package:fit_rpg/Services/audio_service.dart';
import 'package:fit_rpg/Services/widgets_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_rpg/Pages/Main/adventure_page.dart';

class HubPage extends StatefulWidget {
  const HubPage({super.key});

  @override
  State<HubPage> createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        AudioService().setTheme(GameAudio.mainBackground);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide the back button
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ResponsiveIconsOverBackground(               
        backgroundAsset: 'assets/images/Hub_BG.png',
        bgDesignWidth: 1000,   // your Hub_BG.png is 1000px wide
        bgDesignHeight: 1500,  // and 1500px tall
        icons: [
          // Each icon: assetPath, onTap, UL.x, UL.y, BR.x, BR.y
          IconInfo(
            assetPath: 'assets/images/battle_icon.png',
            onTap: () {
              AudioService().playSFX('touch.wav');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdventurePage(),
                ),
              );
            },
            ulx: 690, uly: 250, brx: 1000, bry: 850, // battle
          ),
          IconInfo(
            assetPath: 'assets/images/stats_icon.png',
            onTap: () {
              AudioService().playSFX('touch.wav');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GamePageStatic(),
                ),
              );
            },
            ulx: 560, uly: 880, brx: 975, bry: 1310, // stats
          ),
          IconInfo(
            assetPath: 'assets/images/activity_icon.png',
            onTap: () {
              AudioService().playSFX('touch.wav');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ActivityPage(),
                ),
              );
            },
            ulx: 15, uly: 285, brx: 710, bry: 940, // activity
          ),
          IconInfo(
            assetPath: 'assets/images/profile_icon.png',
            onTap: () {
              AudioService().playSFX('touch.wav');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(),
                ),
              );
            },
            ulx: 345, uly: 100, brx: 550, bry: 620, // profile
          ),
          IconInfo(
            assetPath: 'assets/images/crafting_icon.png',
            onTap: () {
              // TODO: Navigate to crafting page
            },
            ulx: 360, uly: 1130, brx: 710, bry: 1490, // crafting
          ),
          IconInfo(
            assetPath: 'assets/images/inventory_icon.png',
            onTap: () {
              // TODO: Navigate to inventory page
            },
            ulx: 35, uly: 990, brx: 290, bry: 1340, // inventory
          ),
          IconInfo(
            assetPath: 'assets/images/FitRPG_Logo.png',
            onTap: () { },
            ulx: 520, uly: 0, brx: 820, bry: 300, // example logo coords
          ),
        ],
      ),
    );
  }
}

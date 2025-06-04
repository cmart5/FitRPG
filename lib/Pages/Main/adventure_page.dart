import 'package:fit_rpg/Pages/Game/game_page_active.dart';
import 'package:fit_rpg/Pages/Main/hub_page.dart';
import 'package:fit_rpg/Services/audio_service.dart';
import 'package:fit_rpg/Services/widgets_ui.dart';
import 'package:flutter/material.dart';



class AdventurePage extends StatefulWidget {
    const AdventurePage({super.key});

    @override
    State<AdventurePage> createState() => _AdventurePageState();
}

class _AdventurePageState extends State<AdventurePage> {

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                elevation: 0,
            ),
            body: ResponsiveIconsOverBackground(
              backgroundAsset: 'assets/images/adventure_menu_bg.png',
              icons: [
                IconInfo(
                  assetPath: 'assets/images/adventure_icon.png',
                  onTap: () {
                    AudioService().playSFX('touch.wav');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GamePageActive(),
                      ),
                    );
                  },
                  ulx: 300, uly: 0, brx: 700, bry: 700, // battle
                ),
                IconInfo(
                  assetPath: 'assets/images/minigames_icon.png',
                  onTap: () {
                    AudioService().playSFX('touch.wav');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => const GamePageActive(),
                    //   ),
                    // );
                  },
                  ulx: 300, uly: 450, brx: 700, bry: 1150, // stats
                ),
                IconInfo(
                  assetPath: 'assets/images/FitRPG_Logo.png',
                  onTap: () {
                    AudioService().playSFX('touch.wav');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HubPage(),
                      ),
                    );
                  },
                  ulx: 400, uly: 900, brx: 600, bry: 1400, // settings
                ),
              ],
            ),
        );
    }
}
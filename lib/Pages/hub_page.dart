import 'package:fit_rpg/Game/game_page_static.dart';
import 'package:fit_rpg/Pages/activity_page.dart';
import 'package:fit_rpg/Pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/Game/game_page_active.dart';
import 'package:fit_rpg/Services/audio_service.dart';

class HubPage extends StatefulWidget {
  const HubPage({super.key});

  @override
  State<HubPage> createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {

  @override
  void initState() {
    super.initState();
    AudioService().setTheme(GameAudio.mainBackground);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              //Background
              Positioned.fill(
                child: Image.asset(
                  'assets/images/Hub_BG.png',
                  fit: BoxFit.cover,
                ),
              ),
              //Hub Logo
              Positioned(
                top: height * 0.0,
                left: (width) / 2, // Center horizontally
                child: Image.asset(
                  'assets/images/Hub_Logo.png',
                  width: 175,
                  height: 175,
                ),
              ),
              _iconButtonOverlay(
                context,
                label: 'Battle',
                assetPath: 'assets/images/door.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GamePageActive()),
                ),
                topPercent: 0.35,
                leftPercent: 0.8,
              ),
              _iconButtonOverlay(
                context,
                label: 'Stats',
                assetPath: 'assets/images/book.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GamePageStatic(),
                  ),
                ),
                topPercent: 0.60,
                leftPercent: 0.75,
              ),
              _iconButtonOverlay(
                context,
                label: 'Activity',
                assetPath: 'assets/images/bench.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ActivityPage(),
                  ),
                ),
                topPercent: 0.25,
                leftPercent: 0.05,
              ),
              _iconButtonOverlay(
                context,
                label: 'Profile',
                assetPath: 'assets/images/armor.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfilePage(),
                  ),
                ),
                topPercent: 0.15,
                leftPercent: 0.35,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _iconButtonOverlay(
    BuildContext context, {
    required String label,
    required String assetPath,
    required VoidCallback onTap,
    required double topPercent,
    required double leftPercent,
  }) {
    return Positioned(
      top: MediaQuery.of(context).size.height * topPercent,
      left: MediaQuery.of(context).size.width * leftPercent,
      child: GestureDetector(
        onTap: () {
          AudioService().playSFX('touch.wav'); // Play sound effect on touch
          Feedback.forTap(context);
          onTap();
        },
        child: Column(
          children: [
            Material(
              elevation: 8,
              shape: const CircleBorder(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                padding: const EdgeInsets.all(0),
                child: Image.asset(
                  assetPath,
                  width: 64,
                  height: 64,
                )
              ),
            )  ,
            const SizedBox(height: 0),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'pixelFont',
              ),
            ),         
          ],
        ),
      ),
    );
  }
}
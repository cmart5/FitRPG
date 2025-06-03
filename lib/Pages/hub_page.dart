import 'package:fit_rpg/Game/game_page_static.dart';
import 'package:fit_rpg/Pages/activity_page.dart';
import 'package:fit_rpg/Pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/Game/game_page_active.dart';
import 'package:fit_rpg/Services/audio_service.dart';
import 'package:fit_rpg/Services/widgets_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // Background
              Positioned.fill(
                child: Image.asset(
                  'assets/images/Hub_BG.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Hub Logo
              Positioned(
                top: height * -0.0, // Adjusted to fit the logo
                left: width / 1.95, // Center horizontally
                child: Image.asset(
                  'assets/images/FitRPG_Logo.png',
                  width: 190.w,
                  height: 190.h,
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
                topPercent: 0.172,
                leftPercent: 0.555,
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
                topPercent: 0.54,
                leftPercent: 0.44,
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
                topPercent: 0.14,
                leftPercent: -0.46,
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
                topPercent: 0.041,
                leftPercent: -0.025,
              ),
            ],
          );
        },
      ),
      );
    }
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
     top: 915.h * topPercent,
     left: 412.w * leftPercent,
     child: InteractiveIcon(
       label: label,
       assetPath: assetPath,
       onTap: onTap,
     ),
   );
}
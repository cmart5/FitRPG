import 'package:flutter/material.dart';
import 'package:fit_rpg/game_page_active.dart';
import 'package:fit_rpg/audio_service.dart';

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
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/Hub_BG.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 130,
            left:0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/Hub_Logo.png',
                width: 175,
                height: 175,
              ),
            ),
          ),        
          // Button Grid
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                shrinkWrap: true,
                children: [
                  _hubButton(context, "Battle", Icons.sports_martial_arts, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GamePageActive()),
                    );
                  }),
                  _hubButton(context, "Inventory(X)", Icons.backpack, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Inventory not implemented")),
                    );
                  }),
                  _hubButton(context, "Quests(X)", Icons.map, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Quest Board not implemented")),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hubButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withAlpha(120),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

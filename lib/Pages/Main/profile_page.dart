import 'package:fit_rpg/Services/audio_service.dart';
import 'package:fit_rpg/Game/game_stats.dart';
import 'package:fit_rpg/Pages/Main/login_page.dart';
import 'package:fit_rpg/Pages/Main/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/Services/auth_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();

  String username = '???';
  String email = '???';
  String created = 'XX-XX-XXXX';
  bool isEditing = false;
  bool isFemale = false;

  //final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AudioService().setTheme(GameAudio.mainBackground); // Set the background music theme
    _loadUserData(); // Loads username and isFemale
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.loadGameData(); // Re-fetch data for logged-in user
  }

  Future<void> _loadUserData() async {
    final data = await authService.loadUserData();
    print('🔄 Loaded data: $data');

    if (data == null) return;
    if (!mounted) return;

    setState(() {
      username = data['username'] ?? 'Unnamed';
      isFemale = data['isFemale'] ?? false;
      email = data['email'] ?? '_@_._';
      final rawDate = data['created_at'];
      if (rawDate != null) {
        final parsedDate = DateTime.parse(rawDate);
        created = '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
      } // only XX-XX-XXXX
    });
  }

  Future<bool> confirmLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(240, 230, 200, 150),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r), 
        ),
        title: Text(
          "Confirm Logout",
          style: TextStyle(fontSize: 32.sp, fontFamily: 'pixelFont'), 
        ),
        content: Text(
          "Are you sure you want to sign out?",
          style: TextStyle(fontSize: 24.sp, fontFamily: 'pixelFont'), 
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: TextStyle(fontSize: 24.sp, fontFamily: 'pixelFont'), 
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              textStyle: TextStyle(fontSize: 24.sp, fontFamily: 'pixelFont'), 
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Logout"),
          ),
        ],
      ),
    ) ?? false; // Default to false if dismissed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent automatic layout resize
      extendBodyBehindAppBar: true, // Extend body behind AppBar      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            style: IconButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () async {
              AudioService().playSFX('touch.wav'); // Play sound effect on logout

              final shouldLogout = await confirmLogoutDialog(context);
              if (shouldLogout) {
                await authService.signOut(context);
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            style: IconButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () {
              AudioService().playSFX('touch.wav'); // Play sound effect on settings
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],        
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Profile_BG.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Information',
                    style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold), 
                  ),
                  SizedBox(height: 16.h), 

                  Text('Username: $username', style: TextStyle(fontSize: 24.sp)),
                  SizedBox(height: 8.h), 
                  Text('Email: $email', style: TextStyle(fontSize: 24.sp)), 
                  SizedBox(height: 8.h), 
                  Text('Gender: ${isFemale ? "Female" : "Male"}', style: TextStyle(fontSize: 24.sp)), 
                  SizedBox(height: 16.h), 
                  Text('Created: $created', style: TextStyle(fontSize: 24.sp)), 
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        ],  
      )
    );
  }
}

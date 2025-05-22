import 'package:fit_rpg/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();

  String username = 'Loading...';
  String email = '???';
  String created = 'XX-XX-XXXX';
  bool isEditing = false;
  bool isFemale = false;

  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Loads username and isFemale
  }

  Future<void> _loadUserData() async {
    final data = await authService.loadUserData();
    print('🔄 Loaded data: $data');

    if (data == null) return;

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

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent automatic layout resize
      extendBodyBehindAppBar: true, // Extend body behind AppBar      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            style: IconButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () async {
              await authService.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false, // predicate removes all existing routes from stack,
              );                  //preventing user from using back button to reroute.
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // aligns text left
                children: [
                  const Text(
                    'Profile Information',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Basic Info Rows
                  Text('Username: $username', style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text('Email: $email', style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text('Gender: ${isFemale ? "Female" : "Male"}', style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 16),
                  Text('Created: $created', style: const TextStyle(fontSize: 24)),

                  Expanded(
                    child: Container(                      
                    ),
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

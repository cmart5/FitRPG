import 'package:flutter/material.dart';
import 'package:fit_rpg/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();

  String _username = 'Loading...';
  bool _isEditing = false;
  bool isFemale = false;

  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Loads username and isFemale
  }

  Future<void> _loadUserData() async {
    final data = await authService.loadUserData();
    if (data == null) return;

    setState(() {
      _username = data['username'] ?? 'Unnamed';
      isFemale = data['isFemale'] ?? false;
    });
  }

  Future<void> _toggleEdit() async {
    if (_isEditing) {
      final newUsername = _usernameController.text;
      await authService.updateUsername(newUsername);
      setState(() {
        _username = newUsername;
        _isEditing = false;
      });
    } else {
      _usernameController.text = _username;
      setState(() {
        _isEditing = true;
      });
    }
  }

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Stack(
        children: [
          // Background image based on gender
          Positioned.fill(
            child: Image.asset(
              isFemale
                  ? 'assets/images/FitRPG_ProfileBG_Female.png'
                  : 'assets/images/FitRPG_ProfileBG.png',
              fit: BoxFit.cover,
              key: ValueKey(isFemale),
            ),
          ),

          // Foreground content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 75),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _isEditing
                        ? Expanded(
                            child: TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          )
                        : Text(
                            _username,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                    IconButton(
                      onPressed: _toggleEdit,
                      icon: Icon(_isEditing ? Icons.check : Icons.edit),
                      tooltip: _isEditing ? 'Save' : 'Edit',
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

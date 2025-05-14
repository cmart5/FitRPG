import 'package:fit_rpg/auth_service.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();

  // Text controllers
  final _usernameController = TextEditingController();
  bool _isEditing = false; // Track whether the username is being edited
  String _username = "DefaultUsername"; // Initial username

  void logout() async {
    await authService.signOut();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        // Save the new username when exiting edit mode
        _username = _usernameController.text;
      } else {
        // Set the controller's text to the current username when entering edit mode
        _usernameController.text = _username;
      }
      _isEditing = !_isEditing;
    });
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          //logout button
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username display with edit button
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
                        ),
                      ),
                IconButton(
                  onPressed: _toggleEdit,
                  icon: Icon(_isEditing ? Icons.check : Icons.edit),
                  tooltip: _isEditing ? 'Save' : 'Edit',
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
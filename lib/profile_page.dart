import 'package:flutter/material.dart';
import 'package:fit_rpg/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

  String? email;
  String? displayName;
  bool isLoading = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), loadUserInfo); // Delay to ensure the UI is built before loading user info    
  }

  Future<void> loadUserInfo() async {
    try {
    // Fetch user row from "users" table using the user ID
    final userData = await _authService.getUserInfo();

    setState(() {
      email = userData?['email'];
      displayName = userData?['display_name'];
      isLoading = false;
    });
    } catch (error) {
      // Session is invalid or expired, log out
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Logging out...'),
        ),
      );

      await _authService.logout();

      setState(() {
        isLoading = false;
        email = null; // Reset email to null on logout
      });
    }
  }

  Future<void> loginOrRegister({required bool isLogin}) async {
    final emailText = _emailController.text.trim();
    final passwordText = _passwordController.text.trim();

    try {
      if (isLogin) {
        await _authService.login(emailText, passwordText);
      } else {
        await _authService.register(emailText, passwordText);
      }
      await loadUserInfo();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auth Error: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitRPG - Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: email == null ? _buildLoginOverlay() : _buildProfileInfo(),
      ),
    );
  }

  Widget _buildLoginOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Please Log In or Register",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Password"),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => loginOrRegister(isLogin: true),
              child: const Text("Login"),
            ),
            const SizedBox (width: 10),
            ElevatedButton(
              onPressed: () => loginOrRegister(isLogin: false),
              child: const Text("Register"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("Account",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text("Email: $email", style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        Text("Display Name: ${displayName ?? 'Not Set'}", 
          style: const TextStyle(fontSize: 18)),
      ]
    );
  }
}
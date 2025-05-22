import 'package:fit_rpg/main_navigation.dart';
import 'package:fit_rpg/register_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/auth_service.dart';
import 'package:fit_rpg/widgets_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Get auth service
  final authService = AuthService();

  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // login button pressed 
  void login() async {
    // Prepare data
    final email = _emailController.text;
    final password = _passwordController.text;

    // Attempt login
    try {
      await authService.signInWithEmailPassword(email, password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainNavigation(),
        ),
      );
    }

    // Catch errors
    catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  // BUILD UI
 @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false, // Prevent automatic layout resize
    body: Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/Login_BG2.png',
            fit: BoxFit.cover,
          ),
        ),

        // Safe fixed height scrollable area
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          "FitRPG",
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FrostedText(
                        color: Colors.white.withAlpha(32),
                        borderRadius: BorderRadius.circular(4),
                        padding: const EdgeInsets.all(0),
                        child: const Text(
                          " Welcome back! Please login to continue.",
                          style: TextStyle(fontSize: 28, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FrostedText(
                        color: Colors.black.withAlpha(64),
                        borderRadius: BorderRadius.circular(4),
                        padding: const EdgeInsets.all(3),
                        child: TextField(
                          controller: _emailController,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24
                            ),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 24
                            ),
                            labelText: "Email",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FrostedText(
                        color: Colors.black.withAlpha(64),
                        borderRadius: BorderRadius.circular(4),
                        padding: const EdgeInsets.all(3),
                        child: TextField(
                          controller: _passwordController,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24
                            ),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 24
                            ),
                            labelText: "Password",
                            border: OutlineInputBorder(),
                          ),
                        obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: login,
                        child: const Text("Login"),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: FrostedText(
                          color: Colors.white.withAlpha(32),
                          borderRadius: BorderRadius.circular(4),
                          padding: const EdgeInsets.all(0),
                          child: const Text(
                            "Dont have an account? Register here.",
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
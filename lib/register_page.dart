import 'package:fit_rpg/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Get auth service
  final authService = AuthService();
  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isFemale = false;

  // Register button pressed 
  void register() async {
    //prepare data
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    //attempt registration
    if (password != confirmPassword) {    
      //show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );
    }

    // attempt registration
    try {
      await authService.signUpWithEmailPassword(email, password, isFemale);

      // Navigate to login page
      Navigator.pop(context);

    }
    catch (e) {
      //show error message
      if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
      }
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
            'assets/images/FitRPG_BG_Login.png',
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
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Welcome to FitRPG! Register, Champion.",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: "Confirm Password",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      // Male or Female selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Choose Your Champion:",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ChoiceChip(
                                label: const Text("Male"),
                                selected: !isFemale,
                                onSelected: (selected) {
                                  setState(() {
                                    isFemale = false;
                                  });
                                },
                                selectedColor: Colors.blueAccent,
                                labelStyle: TextStyle(
                                  color: !isFemale ? Colors.white : Colors.black,
                                  fontFamily: 'PixelFont',
                                ),
                              ),
                              ChoiceChip(
                                label: const Text("Female"),
                                selected: isFemale,
                                onSelected: (selected) {
                                  setState(() {
                                    isFemale = true;
                                  });
                                },
                                selectedColor: Colors.pinkAccent,
                                labelStyle: TextStyle(
                                  color: isFemale ? Colors.white : Colors.black,
                                  fontFamily: 'PixelFont',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: register,
                        child: const Text("Register"),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(fontSize: 20, color: Colors.white),
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
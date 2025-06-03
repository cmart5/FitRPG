import 'package:fit_rpg/Services/audio_service.dart';
import 'package:fit_rpg/Pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/Services/auth_service.dart';
import 'package:fit_rpg/Services/widgets_ui.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  void initState() {
    super.initState();
    // Optionally, you can add any initialization logic here
    AudioService().setTheme(GameAudio.mainBackground); // Set the background music theme
  }
  // Get auth service
  final authService = AuthService();
  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isFemale = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
              'assets/images/Login_BG2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Safe fixed height scrollable area
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Image.asset(
                          'assets/images/FitRPG_Logo.png',
                          width: 275,
                          height: 275,
                        )
                      ),
                        // Frosted text background
                        FrostedText(
                            color: Colors.white.withAlpha(32),
                            borderRadius: BorderRadius.circular(4),
                            padding: const EdgeInsets.all(2),
                            child: const Text(
                              "Welcome to FitRPG! Register, Champion.",
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
                          obscureText: _obscurePassword,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24
                            ),
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 24
                            ),
                            labelText: "Password",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FrostedText(
                        color: Colors.black.withAlpha(64),
                        borderRadius: BorderRadius.circular(4),
                        padding: const EdgeInsets.all(3),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24
                            ),
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 24
                            ),
                            labelText: "Confirm Password",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Male or Female selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FrostedText(
                            sigmaX: 12,
                            sigmaY: 12,
                            color: Colors.white.withAlpha(32),
                            borderRadius: BorderRadius.circular(4),
                            padding: const EdgeInsets.all(2),
                            child: const Text(
                              "Choose Your Champion:",
                              style: TextStyle(fontSize: 28, color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ChoiceChip(
                                label: const Text(" Male"),
                                selected: !isFemale,
                                onSelected: (selected) {
                                  setState(() {
                                    isFemale = false;
                                  });
                                },
                                selectedColor: Colors.blueAccent,
                                labelStyle: TextStyle(
                                  color: !isFemale ? Colors.white : Colors.grey,
                                  fontFamily: 'pixelFont',
                                  fontSize: 24,
                                ),
                              ),
                              ChoiceChip(
                                label: const Text(
                                  "Female",
                                  style: TextStyle(fontFamily: 'pixelFont'),
                                ),
                                selected: isFemale,
                                onSelected: (selected) {
                                  setState(() {
                                    isFemale = true;
                                  });
                                },
                                selectedColor: Colors.pinkAccent,
                                labelStyle: TextStyle(
                                  color: isFemale ? Colors.white : Colors.grey,
                                  fontFamily: 'pixelFont',
                                  fontSize: 24,
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
                        child: FrostedText(
                          color: Colors.white.withAlpha(32),
                          borderRadius: BorderRadius.circular(4),
                          padding: const EdgeInsets.all(2),
                          child: const Text(
                            "Already have an account? Login",
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
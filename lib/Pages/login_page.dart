import 'package:fit_rpg/Pages/hub_page.dart';
import 'package:fit_rpg/Services/audio_service.dart';
import 'package:fit_rpg/Pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/Services/auth_service.dart';
import 'package:fit_rpg/Services/widgets_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    AudioService().setTheme(GameAudio.mainBackground); // Set the background music theme
  }

  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signInWithEmailPassword(email, password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HubPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Login_BG2.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/FitRPG_Logo.png',
                            width: 300.w, 
                            height: 300.h, 
                          ),
                        ),
                        SizedBox(height: 16.h), 
                        FrostedText(
                          color: Colors.white.withAlpha(32),
                          borderRadius: BorderRadius.circular(4.r), 
                          padding: EdgeInsets.all(0.w), 
                          child: Text(
                            " Welcome back! Please login to continue.",
                            style: TextStyle(fontSize: 28.sp, color: Colors.black), 
                          ),
                        ),
                        SizedBox(height: 16.h), 
                        FrostedText(
                          color: Colors.black.withAlpha(64),
                          borderRadius: BorderRadius.circular(4.r), 
                          padding: EdgeInsets.all(3.w),
                          child: TextField(
                            controller: _emailController,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.sp, 
                            ),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 24.sp, 
                              ),
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h), 
                        FrostedText(
                          color: Colors.black.withAlpha(64),
                          borderRadius: BorderRadius.circular(4.r), 
                          padding: EdgeInsets.all(3.w), 
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.sp, 
                            ),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 24.sp, 
                              ),
                              labelText: "Password",
                              border: OutlineInputBorder(),
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
                        SizedBox(height: 16.h), 
                        ElevatedButton(
                          onPressed: login,
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 20.sp), 
                          ),
                        ),
                        SizedBox(height: 16.h), 
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
                            borderRadius: BorderRadius.circular(4.r), 
                            padding: EdgeInsets.all(0.w), 
                            child: Text(
                              "Don't have an account? Register here.",
                              style: TextStyle(fontSize: 24.sp, color: Colors.black), 
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
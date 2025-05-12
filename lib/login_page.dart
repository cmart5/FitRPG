import 'package:fit_rpg/register_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/auth_service.dart';

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
    //prepare data
    final email = _emailController.text;
    final password = _passwordController.text;

    //attempt login
    try {
      await authService.signInWithEmailPassword(email, password);
    }

    //catch errors
    catch (e) {
      //show error message
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //logo
          const Center(
            child: Text(
              "FitRPG",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          //welcome message
          const Text(
            "Welcome back! Please login to continue.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          //email and password fields      
          //email
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
          ),
          //password
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: "Password",
            ),
            //obscureText: true,
          ),
          //button
          const SizedBox(height: 16),
          //login button
          ElevatedButton(
            onPressed: login,
            child: const Text("Login"),
          ),

          const SizedBox(height: 16),
          //register button
          TextButton(
            onPressed: () {
              // Navigate to register page
              Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ),
              );
            },
            child: const Text("Don't have an account? Register here."),
          ),         
        ]
      )
    );
  }
}
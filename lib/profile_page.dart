import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    final user = Supabase.instance.client.auth.currentUser;
    final supabase = Supabase.instance.client;

    if (user == null) {
      setState(() {
        isLoading = false;
        email = null;
      });
      return;
    }

    try {
    // Fetch user row from "users" table using the user ID
    final response = await supabase
        .from('users')
        .select('id')
        .eq('id', user.id)
        .single(); //only one row expected

    final userRow = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .single();

    setState(() {
      email = user.email;
      displayName = userRow['display_name'];
      isLoading = false;
    });
    } catch (error) {
      // Session is invalid or expired, log out
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Session expired. Logging out...'),
        ),
      );
      print('Session check failed. Logging out... Error: $error'); //debug

      await Supabase.instance.client.auth.signOut();

      setState(() {
        isLoading = false;
        email = null; // Reset email to null on logout
      });
    }
  }

  Future<void> loginOrRegister({required bool isLogin}) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (isLogin) {
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } else {
        final signUpReponse = await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
        );

        final user = signUpReponse.user;

        //Only insert if user creation is successful
        if (user != null) {
          await Supabase.instance.client.from('users').insert({
            'id': user.id,
            'email': user.email,
            'display_name': 'New Player', // Default display name
          });
        }
      }

      //Reload user info after login/register
      await loadUserInfo();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Auth Error: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitRPG - Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: email == null
            ? _buildLoginOverlay()
            : _buildProfileInfo(),
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
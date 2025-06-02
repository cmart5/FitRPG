// AUTH GATE - This will continuosly check if the user is logged in or not
// 
// unauthenticated -> login page
// authenticated -> account page


import 'package:fit_rpg/Pages/hub_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fit_rpg/Pages/login_page.dart';
import 'package:fit_rpg/Services/main_navigation.dart';

class AuthGate extends StatelessWidget { // This widget will continuously check if the user is logged in or not
  const AuthGate({super.key}); 

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,

      // build appropriate page base on auth state
      builder: (context, snapshot) {
        //loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // check if there is a valid session currently
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const HubPage();
        } else {
          return const LoginPage(); 
        }
      }
    );
  }
}
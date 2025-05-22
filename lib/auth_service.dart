import 'package:fit_rpg/game_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(
      String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmailPassword(
      String email, String password, bool isFemale) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user != null) {
      // User is signed up successfully
      await supabase.from('users').insert({
        'id': user.id,
        'email': email,
        'password': password,
        'isFemale': isFemale,
        'username': email.split('@')[0], // Default username from email
        'created_at': DateTime.now().toIso8601String(),
      });
      return response;
    } else {
      // Handle the case where user is null
      throw Exception('User sign up failed');
    }
  }

  // Sign out the user
  Future<void> signOut(BuildContext context) async {
    await supabase.auth.signOut();
    // Clear game state data
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.clear();
  }

  String? getUserId() {
    return supabase.auth.currentUser?.id;
  }

  Future<Map<String, dynamic>?> loadUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('No logged in user.');
    };

    final response = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      print("❌ User not found in users table");
      return null;
    }

    return {
      'username': response['username'],
      'email': response['email'],
      'isFemale': response ['isFemale'],
      'created_at': response ['created_at'],
    };
  }
  
  Future<void> updateUsername(String newUsername) async {
    final userId = getUserId();
    if (userId == null) throw Exception("User not logged in");

    await supabase.from('users').update({
      'username': newUsername,
    }).eq('id', userId);
  }

  Future<void> updateIsFemale(bool value) async {
    final userId = getUserId();
    if (userId == null) throw Exception("User not logged in");

    await supabase.from('users').update({
      'isFemale': value,
    }).eq('id', userId);
  }
}

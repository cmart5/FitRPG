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
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

    String? getUserId() {
    return supabase.auth.currentUser?.id;
  }

  Future<Map<String, dynamic>?> loadUserData() async {
  final userId = getUserId();
  if (userId == null) return null;

  final data = await supabase
      .from('users')
      .select()
      .eq('id', userId)
      .maybeSingle();

  return data;
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

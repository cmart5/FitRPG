import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<User?> login(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(email: email, password: password);
    return response.user;
  }

  Future<User?> register(String email, String password) async {
    final response = await supabase.auth.signUp(email: email, password: password);
    final user = response.user;

    if (user != null) {
      await supabase.from('users').insert({
        'id': user.id,
        'email': user.email,
        'display_name': 'New Player',
      });
    }

    return user;
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final userRow = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .single();

    return {
      'email': user.email,
      'display_name': userRow['display_name'],
    };
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}

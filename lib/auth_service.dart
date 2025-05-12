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
      String email, String password) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
      );
  }

  // Sign out the user
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // Get the user email
  String? getUserEmail() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
  
}

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  final SupabaseClient _supabase = Supabase.instance.client;

  // signin with email and password
  Future<AuthResponse> signInWithEmailandPassword(
      String email, String password) async {
    return await _supabase.auth
        .signInWithPassword(password: password, email: email);
  }

  // signup with email and password
  Future<AuthResponse> signUpWithEmailandPassword(
      String email, String password) async {
    return await _supabase.auth.signUp(password: password, email: email);
  }

  // get user email
  String? getuserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  // signout
  Future<void> signOut() async {
    return await _supabase.auth.signOut();
  }
}

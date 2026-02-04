import 'package:flutter/material.dart';
import 'package:laptop_checkout/features/pages/main_layout.dart';
import 'package:laptop_checkout/features/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Show loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF003366),
                    strokeWidth: 2,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Checking authentication...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Check if we have a valid session
        final hasSession = snapshot.data?.session != null;

        // If authenticated, go to MainLayout (Home page)
        if (hasSession) {
          return const MainLayout();
        }
        // If not authenticated, go to Login page
        else {
          return const LoginPage();
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:laptop_checkout/core/theme/app_theme.dart';
import 'package:laptop_checkout/features/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVxZXVvbHJpb3BzbmxocmRwbmZpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjcwMDQ3MjgsImV4cCI6MjA4MjU4MDcyOH0.rpTX--OezrMYUZUvyOYMplU-_diFb4Gr6rD9p-nnltc', // Your Supabase anon key
    url: 'https://uqeuolriopsnlhrdpnfi.supabase.co',
  );

  runApp(const ProviderScope(child: LaptopCheckoutApp()));
}

class LaptopCheckoutApp extends StatelessWidget {
  const LaptopCheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BIT Hardware Management',
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
    );
  }
}

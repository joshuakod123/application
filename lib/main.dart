import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Import SharedPreferences

import 'pages/loading_page.dart';
import 'login/login_page.dart';
import 'pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase
  await Supabase.initialize(
    url: 'https://xrcuotrkuzhwmakfncld.supabase.co',  // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhyY3VvdHJrdXpod21ha2ZuY2xkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAwMzIxMzEsImV4cCI6MjA1NTYwODEzMX0.JS22WLKMwMSGQwsNiT2YjlT-t08LlAPCvSMs7_uakh4',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<bool>(
        future: _checkLoginPreference(), // ✅ Check if user wants to stay logged in
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage();  // ✅ Show loading while checking session
          } else if (snapshot.hasData && snapshot.data == true) {
            return _isUserLoggedIn() ? MainPage() : LoginPage();
          } else {
            return LoginPage();  // ✅ Default to login if no preference is set
          }
        },
      ),
    );
  }

  /// ✅ Check if "Remember Me" is enabled in SharedPreferences
  Future<bool> _checkLoginPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('remember_me') ?? false;
  }

  /// ✅ Check if user is logged in (returns `true` if logged in)
  bool _isUserLoggedIn() {
    final session = supabase.auth.currentSession;
    return session != null;
  }
}

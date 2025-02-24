import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Import SharedPreferences
import '../pages/main_page.dart';
import '../login/register_page.dart';
import '../login/forgot_password.dart';
import '../fade_transition.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false; // ✅ "Remember Me" option

  /// ✅ Handles User Login & Saves Name
  Future<void> _login() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final response = await supabase.auth.signInWithPassword(email: email, password: password);
      if (response.user != null) {
        final userId = response.user!.id;
        final userEmail = response.user!.email;

        // ✅ Ensure user exists in "users" table
        await supabase.from('users').upsert({
          'id': userId,
          'email': userEmail,
        });

        // ✅ Proceed to MainPage
        Navigator.pushReplacement(context, fadeTransition(const MainPage()));
      }
      final user = response.user;

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_me', _rememberMe);

        // ✅ Fetch user name from database
        final userData = await supabase
            .from('users')
            .select('first_name, last_name')
            .eq('id', user.id)
            .single();

        if (userData != null) {
          String fullName = "${userData['first_name']} ${userData['last_name']}";
          await prefs.setString('user_name', fullName); // ✅ Save name in SharedPreferences
        }

        Navigator.pushReplacement(context, fadeTransition(const MainPage()));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // ✅ Prevents overflow when keyboard is open
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60), // Extra padding for better spacing
              const Icon(Icons.school, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text("Sign in", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Email TextField
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email Address"),
              ),

              // Password TextField
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              // ✅ Remember Me Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text("Remember Me"),
                ],
              ),

              // ✅ Login Button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Login"),
              ),

              const SizedBox(height: 10),

              // ✅ Forgot Password & Register Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                    },
                    child: const Text("Forgot Password?", style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                    },
                    child: const Text("Create Account", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

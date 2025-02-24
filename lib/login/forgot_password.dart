import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _supabase = Supabase.instance.client;
  final _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    try {
      final email = _emailController.text.trim();
      await _supabase.auth.resetPasswordForEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password reset email sent!")));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter your email and we'll send a link to reset your password."),
            SizedBox(height: 10),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email Address")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _resetPassword, child: Text("Submit"), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue)),
          ],
        ),
      ),
    );
  }
}

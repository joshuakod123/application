import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../login/login_page.dart';
import '../fade_transition.dart';
import '../sub_screens/profile_details_page.dart';
import '../sub_screens/settings_page.dart';

class ProfilePage extends StatelessWidget {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _signOut(BuildContext context) async {
    await supabase.auth.signOut();
    Navigator.pushReplacement(context, fadeTransition(LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")), // ✅ Added AppBar
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(radius: 50, backgroundColor: Colors.blue),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("Dark mode"),
              trailing: Switch(value: false, onChanged: (bool value) {}),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile details"),
              onTap: () {
                Navigator.push(context, fadeTransition(const ProfileDetailsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(context, fadeTransition(const SettingsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log out"),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Profil"), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text("Aicha", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Étudiante à l'ISN", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Paramètres"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Aide & Support"),
              onTap: () {},
            ),
            ListTile(
  leading: const Icon(Icons.logout, color: Colors.red),
  title: const Text(
    "Déconnexion",
    style: TextStyle(color: Colors.red),
  ),
  onTap: () {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  },
),
          ],
        ),
      ),
    );
  }
}

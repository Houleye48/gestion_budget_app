import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              decoration: const InputDecoration(
                labelText: "Nom",
              ),
            ),

            TextField(
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),

            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              child: const Text("S'inscrire"),
            )
          ],
        ),
      ),
    );
  }
}
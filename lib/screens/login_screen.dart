import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =
        TextEditingController();

    TextEditingController passwordController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.home);
              },
              child: const Text("Se connecter"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                    context,
                    AppRoutes.register);
              },
              child: const Text(
                "Créer un compte",
              ),
            )
          ],
        ),
      ),
    );
  }
}
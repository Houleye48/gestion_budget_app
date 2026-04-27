import 'package:flutter/material.dart';

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Budget',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text("Backend Ready"),
        ),
      ),
    );
  }
}
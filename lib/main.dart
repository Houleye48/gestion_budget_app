import 'package:flutter/material.dart';
import 'pages/stats_page.dart';

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Budget',
      debugShowCheckedModeBanner: false,
      home: const StatsPage(), // page normale
    );
  }
}
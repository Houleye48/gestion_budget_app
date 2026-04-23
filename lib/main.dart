import 'package:flutter/material.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const StatsPage(),
    );
  }
}

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard & Statistiques"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Carte du Solde Total
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(colors: [Colors.teal, Colors.teal.shade300]),
                  ),
                  child: const Column(
                    children: [
                      Text("Solde Actuel", style: TextStyle(color: Colors.white, fontSize: 18)),
                      SizedBox(height: 10),
                      Text("2 450,00 €", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Emplacement pour le futur graphique
              const Text("Répartition des dépenses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 100),
              const Icon(Icons.pie_chart, size: 100, color: Colors.grey),
              const Text("Le graphique fl_chart arrivera ici !", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
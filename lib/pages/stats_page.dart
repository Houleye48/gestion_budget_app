import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/budget_service.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Transaction> transactions = [
      Transaction(id: 1, montant: 1000, type: "revenu", categorie: "salaire", date: DateTime.now()),
      Transaction(id: 2, montant: 200, type: "depense", categorie: "food", date: DateTime.now()),
      Transaction(id: 3, montant: 150, type: "depense", categorie: "transport", date: DateTime.now()),
    ];

    final budgetService = BudgetService();

    final solde = budgetService.calculerSolde(transactions);
    final totalDepenses = budgetService.totalDepenses(transactions);
    final totalRevenus = budgetService.totalRevenus(transactions);

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

              // 💰 SOLDE
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
                  child: Column(
                    children: [
                      const Text("Solde Actuel", style: TextStyle(color: Colors.white, fontSize: 18)),
                      const SizedBox(height: 10),
                      Text(
                        "${solde.toStringAsFixed(2)} €",
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 📊 REVENUS / DEPENSES
              Row(
                children: [
                  _buildCard("Revenus", totalRevenus, Colors.green),
                  _buildCard("Dépenses", totalDepenses, Colors.red),
                ],
              ),

              const SizedBox(height: 30),

              const Text("Répartition des dépenses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 100),
              const Icon(Icons.pie_chart, size: 100, color: Colors.grey),
              const Text("Le graphique arrivera ici", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, double value, Color color) {
    return Expanded(
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 16, color: color)),
              const SizedBox(height: 10),
              Text(
                "${value.toStringAsFixed(2)} €",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
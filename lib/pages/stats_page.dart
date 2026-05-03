import 'package:flutter/material.dart';
import '../services/budget_service.dart';
import '../models/transaction.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = BudgetService();

    return Scaffold(
      appBar: AppBar(title: const Text("Statistiques")),
      body: FutureBuilder<List<Transaction>>(
        future: service.fetchTransactions(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }

          final transactions = snapshot.data ?? [];

          final revenus = service.totalRevenus(transactions);
          final depenses = service.totalDepenses(transactions);
          final solde = service.solde(transactions);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Revenus: $revenus"),
              Text("Dépenses: $depenses"),
              Text("Solde: $solde"),
            ],
          );
        },
      ),
    );
  }
}
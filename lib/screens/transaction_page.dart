import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key}); // Ajoute cette ligne

  @override
  Widget build(BuildContext context) {
    // Ta liste doit être à l'intérieur du build pour que la classe puisse être const
    final List<Map<String, dynamic>> transactions = [
      {"titre": "Achat Bijoux", "montant": "-2500", "date": "20 Avril", "icon": Icons.shopping_bag, "color": Colors.orange},
      {"titre": "Virement Reçu", "montant": "+15000", "date": "18 Avril", "icon": Icons.account_balance_wallet, "color": Colors.green},
      {"titre": "Restaurant", "montant": "-800", "date": "15 Avril", "icon": Icons.restaurant, "color": Colors.red},
    ];

    return Scaffold(
      // ... reste du code identique
      appBar: AppBar(title: Text("Mes Transactions"), backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final item = transactions[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: item['color'].withOpacity(0.1),
              child: Icon(item['icon'], color: item['color']),
            ),
            title: Text(item['titre'], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item['date']),
            trailing: Text(
              "${item['montant']} MRU",
              style: TextStyle(
                color: item['montant'].contains('+') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

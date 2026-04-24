
import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Liste de données "fictives" (En attendant le Backend)
    final List<Map<String, dynamic>> transactions = [
      {"titre": "Achat Bijoux", "montant": "-2500", "date": "20 Avril", "icon": Icons.shopping_bag, "color": Colors.orange},
      {"titre": "Virement Reçu", "montant": "+15000", "date": "18 Avril", "icon": Icons.account_balance_wallet, "color": Colors.green},
      {"titre": "Restaurant", "montant": "-800", "date": "15 Avril", "icon": Icons.restaurant, "color": Colors.red},
      {"titre": "Abonnement Internet", "montant": "-1200", "date": "12 Avril", "icon": Icons.wifi, "color": Colors.blue},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Transactions"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Petit résumé en haut de la liste
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Historique récent", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("${transactions.length} opérations", style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          
          // 2. La Liste dynamique
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final item = transactions[index];
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.grey.shade100),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item['color'].withValues(alpha: 0.1),
                      child: Icon(item['icon'], color: item['color']),
                    ),
                    title: Text(item['titre'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['date']),
                    trailing: Text(
                      "${item['montant']} MRU",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: item['montant'].startsWith('+') ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

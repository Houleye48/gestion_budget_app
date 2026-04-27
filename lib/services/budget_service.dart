import '../models/transaction.dart';

class BudgetService {

  // 🔹 Calcul du solde
  double calculerSolde(List<Transaction> transactions) {
    double revenus = 0;
    double depenses = 0;

    for (var t in transactions) {
      if (t.type == "revenu") {
        revenus += t.montant;
      } else {
        depenses += t.montant;
      }
    }

    return revenus - depenses;
  }

  // 🔹 Total des dépenses
  double totalDepenses(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == "depense")
        .fold(0, (sum, t) => sum + t.montant);
  }

  // 🔹 Total des revenus
  double totalRevenus(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == "revenu")
        .fold(0, (sum, t) => sum + t.montant);
  }
}
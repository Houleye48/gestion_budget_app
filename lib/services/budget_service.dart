import '../models/transaction.dart';

class BudgetService {

  // 🔹 Total des revenus
  double totalRevenus(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == 'revenu')
        .fold(0, (sum, t) => sum + t.montant);
  }

  // 🔹 Total des dépenses
  double totalDepenses(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == 'depense')
        .fold(0, (sum, t) => sum + t.montant);
  }

  // 🔹 Solde
  double solde(List<Transaction> transactions) {
    return totalRevenus(transactions) - totalDepenses(transactions);
  }

  // 🔹 Filtrer revenus
  List<Transaction> getRevenus(List<Transaction> transactions) {
    return transactions.where((t) => t.type == 'revenu').toList();
  }

  // 🔹 Filtrer dépenses
  List<Transaction> getDepenses(List<Transaction> transactions) {
    return transactions.where((t) => t.type == 'depense').toList();
  }

  // 🔹 Total par catégorie
  Map<String, double> totalParCategorie(List<Transaction> transactions) {
    Map<String, double> data = {};

    for (var t in transactions) {
      if (t.type == 'depense') {
        data[t.categorie] = (data[t.categorie] ?? 0) + t.montant;
      }
    }

    return data;
  }

  // 🔹 Total par mois
  Map<String, double> totalParMois(List<Transaction> transactions) {
    Map<String, double> data = {};

    for (var t in transactions) {
      String mois = "${t.date.month}-${t.date.year}";
      data[mois] = (data[mois] ?? 0) + t.montant;
    }

    return data;
  }

  // 🔹 Ajouter transaction
  void addTransaction(List<Transaction> list, Transaction t) {
    list.add(t);
  }

  // 🔹 Supprimer transaction
  void deleteTransaction(List<Transaction> list, Transaction t) {
    list.remove(t);
  }
}
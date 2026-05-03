import '../models/transaction.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BudgetService {

  // 🔹 URL de base API
  final String baseUrl = "http://127.0.0.1/budget_api";

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

  // ================================
  // 🔥 CRUD API
  // ================================

  // 🔹 READ (GET)
  Future<List<Transaction>> fetchTransactions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_transactions.php'),
    );

    final List data = jsonDecode(response.body);

    return data.map((e) => Transaction.fromJson(e)).toList();
  }

  // 🔹 CREATE (POST)
  Future<void> addTransaction(Transaction t) async {
    await http.post(
      Uri.parse('$baseUrl/add_transaction.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": t.userId,
        "montant": t.montant,
        "type": t.type,
        "categorie": t.categorie,
        "date": t.date.toIso8601String(),
      }),
    );
  }

  // 🔹 UPDATE (POST)
  Future<void> updateTransaction(Transaction t) async {
    await http.post(
      Uri.parse('$baseUrl/update_transaction.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": t.id,
        "user_id": t.userId,
        "montant": t.montant,
        "type": t.type,
        "categorie": t.categorie,
        "date": t.date.toIso8601String(),
      }),
    );
  }

  // 🔹 DELETE (POST)
  Future<void> deleteTransaction(int id) async {
    await http.post(
      Uri.parse('$baseUrl/delete_transaction.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
      }),
    );
  }
}
class Transaction {
  int id;
  final int userId;
  double montant;
  String type; // revenu ou depense
  String categorie;
  DateTime date;

  Transaction({
    required this.id,
    required this.userId,
    required this.montant,
    required this.type,
    required this.categorie,
    required this.date,
  });
}
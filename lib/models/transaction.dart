class Transaction {
  int id;
  double montant;
  String type; // revenu ou depense
  String categorie;
  DateTime date;

  Transaction({
    required this.id,
    required this.montant,
    required this.type,
    required this.categorie,
    required this.date,
  });
}
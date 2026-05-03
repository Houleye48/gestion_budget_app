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
  factory Transaction.fromJson(Map<String, dynamic> json) {
  return Transaction(
    id: int.parse(json['id'].toString()),
    userId: int.parse(json['user_id'].toString()),
    montant: double.parse(json['montant'].toString()),
    type: json['type'],
    categorie: json['categorie'],
    date: DateTime.parse(json['date']),
  );
}
}
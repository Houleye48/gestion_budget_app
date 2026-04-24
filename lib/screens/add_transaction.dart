import 'package:flutter/material.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  // 1. Les contrôleurs pour récupérer ce qui est tapé dans les cases
  final _titreController = TextEditingController();
  final _montantController = TextEditingController();

  // 2. Variable pour stocker la catégorie choisie
  String? _categorieSelectionnee;

  // 3. Liste des catégories pour le menu
  final List<String> _categories = [
    "Nourriture",
    "Transport",
    "Loisirs",
    "Santé",
    "Études",
    "Cadeau"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une opération"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Détails de la transaction",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // Champ : NOM DE LA DÉPENSE
            TextField(
              controller: _titreController,
              decoration: const InputDecoration(
                labelText: "Titre (ex: Déjeuner)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 20),

            // Champ : MONTANT
            TextField(
              controller: _montantController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Montant",
                prefixText: "MRU ",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 20),

            // Champ : CATÉGORIE (Menu déroulant)
            DropdownButtonFormField<String>(
              value: _categorieSelectionnee,
              decoration: const InputDecoration(
                labelText: "Choisir une catégorie",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((String cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (nouveauChoix) {
                // Met à jour l'interface quand on choisit une catégorie
                setState(() {
                  _categorieSelectionnee = nouveauChoix;
                });
              },
            ),
            const SizedBox(height: 40),

            // BOUTON VALIDER
            ElevatedButton(
              onPressed: () {
                // Logique simple pour vérifier si tout est rempli
                if (_titreController.text.isNotEmpty && 
                    _montantController.text.isNotEmpty && 
                    _categorieSelectionnee != null) {
                  
                  print("--- NOUVELLE TRANSACTION ---");
                  print("Titre : ${_titreController.text}");
                  print("Somme : ${_montantController.text} MRU");
                  print("Catégorie : $_categorieSelectionnee");
                  
                  // Retourne à l'écran précédent
                  Navigator.pop(context);
                } else {
                  // Petit message d'erreur si un champ est vide
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Merci de remplir tous les champs")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "ENREGISTRER",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Nettoyage des contrôleurs quand on quitte la page
  @override
  void dispose() {
    _titreController.dispose();
    _montantController.dispose();
    super.dispose();
  }
}

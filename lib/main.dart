import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/add_transaction.dart';
import 'screens/transaction_page.dart'; 
import 'screens/profile_page.dart';

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Budget',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      
      home: const MainNavigation(),
    );
  }
}

// --- NOUVELLE CLASSE POUR LA NAVIGATION (22031) ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Liste des pages qui inclut le travail de 23091 et le 22031
  final List<Widget> _pages = [
    const StatsPage(),        // Page de 23091
    const TransactionPage(),  //  page 22031
    const ProfilePage(),      //  profil 22031
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
      //  BOUTON POUR AJOUTER (22031)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --- LA PAGE DE 23091 (GARDÉE TELLE QUELLE) ---
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard & Statistiques"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(colors: [Colors.teal, Colors.teal.shade300]),
                  ),
                  child: const Column(
                    children: [
                      Text("Solde Actuel", style: TextStyle(color: Colors.white, fontSize: 18)),
                      SizedBox(height: 10),
                      Text("2 450,00 €", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text("Répartition des dépenses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 100),
              const Icon(Icons.pie_chart, size: 100, color: Colors.grey),
              const Text("Le graphique fl_chart arrivera ici !", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

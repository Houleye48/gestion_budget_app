import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  int currentIndex = 0;

  final List<Widget> pages = [
    const Center(child: Text("Tableau de bord")),
    const Center(child: Text("Revenus")),
    const Center(child: Text("Dépenses")),
    const Center(child: Text("Profil")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion Budget"),
      ),

      body: pages[currentIndex],

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: "Revenus",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            label: "Dépenses",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
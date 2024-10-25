import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/produits_page.dart';
import 'Pages/clients_page.dart'; // Importez vos autres pages ici
import 'Pages/comptes_page.dart';
import 'Pages/factures_page.dart';
import 'Pages/transactions_page.dart';
//import 'Pages/produits_page.dart';
import 'Pages/parametres_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Entreprise',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('fr'), // Spanish
      ],
      home:
          HomePage(), // Page principale avec un menu de navigation sur l'écran d'accueil
    );
  }
}

class HomePage extends StatelessWidget {
  // Liste des icônes, titres et couleurs pour le menu
  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.people,
      'title': 'Clients',
      'page': ClientsPage(),
      'color': const Color.fromARGB(255, 185, 95, 145)
    },
    {
      'icon': Icons.receipt,
      'title': 'Factures',
      'page': FacturesPage(),
      'color': const Color.fromARGB(255, 185, 95, 145)
    },
    {
      'icon': Icons.receipt,
      'title': 'Produits',
      'page': ProduitsPage(),
      'color': const Color.fromARGB(255, 185, 95, 145)
    },
    {
      'icon': Icons.account_balance_wallet,
      'title': 'Comptes',
      'page': ComptesPage(),
      'color': Colors.green
    },
    {
      'icon': Icons.swap_horiz,
      'title': 'Transactions',
      'page': TransactionsPage(),
      'color': Colors.green
    },
    {
      'icon': Icons.settings,
      'title': 'Paramètres',
      'page': ParametresPage(),
      'color': const Color.fromARGB(255, 97, 95, 95)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion Entreprise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Deux éléments par ligne
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.0, // Carré
          ),
          itemCount: _menuItems.length,
          itemBuilder: (context, index) {
            final menuItem = _menuItems[index];
            return GestureDetector(
              onTap: () {
                // Navigue vers la page correspondante lorsqu'on appuie
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => menuItem['page'],
                  ),
                );
              },
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      menuItem['icon'],
                      size: 50,
                      color: menuItem[
                          'color'], // Applique la couleur personnalisée
                    ),
                    SizedBox(height: 10),
                    Text(
                      menuItem['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: menuItem[
                            'color'], // Applique la couleur personnalisée
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

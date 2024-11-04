import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/Menu/clientsPageMain.dart';
import 'package:my_first_app/Pages/Menu/fournisseurPageMain.dart';
import 'package:my_first_app/Pages/transactionsPage.dart';
import 'Pages/comptesPage.dart';
import 'Pages/parametresPage.dart';
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
        Locale('en'), 
        Locale('fr'), 
      ],
      home:
          HomePage(), // Page principale avec un menu de navigation sur l'écran d'accueil
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.people,
      'title': 'Clients',
      'page': ClientMainPage(),
    },
    {
      'icon': Icons.people,
      'title': 'Fournisseurs',
      'page': FournisseurMainPage(),
    },
    {
      'icon': Icons.account_balance_wallet,
      'title': 'Comptes',
      'page': ComptesPage(),
    },
    {
      'icon': Icons.swap_horiz,
      'title': 'Transactions',
      'page': TransactionsPage(),
    },
    {
      'icon': Icons.settings,
      'title': 'Paramètres',
      'page': ParametresPage(),
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
                    ),
                    SizedBox(height: 10),
                    Text(
                      menuItem['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: menuItem[
                            'color'], 
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

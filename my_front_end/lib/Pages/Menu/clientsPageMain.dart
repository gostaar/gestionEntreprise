import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/clientsPage.dart';
import 'package:my_first_app/Pages/facturesPage.dart';
import 'package:my_first_app/Pages/produitsPage.dart';

class ClientMainPage extends StatefulWidget {
  @override
  _ClientMainPageState createState() => _ClientMainPageState();
}

class _ClientMainPageState extends State<ClientMainPage> {
  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.people,
      'title': 'Clients',
      'page': ClientsPage(),
    },
    {
      'icon': Icons.account_balance_wallet,
      'title': 'Factures',
      'page': FacturesPage(),
    },
    {
      'icon': Icons.receipt,
      'title': 'Produits',
      'page': ProduitsPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
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
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Décalage de l'ombre
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        menuItem['icon'],
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          menuItem['title'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

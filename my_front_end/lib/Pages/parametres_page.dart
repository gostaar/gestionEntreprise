import 'package:flutter/material.dart';
import 'utilisateurs_page.dart'; // Assurez-vous d'importer la page Utilisateurs ici

class ParametresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ParametresView();
  }
}

class ParametresView extends StatelessWidget {
  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.person,
      'title': 'Utilisateurs',
      'page': UtilisateursPage(),
      'color': const Color.fromARGB(255, 97, 95, 95),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          itemCount: _menuItems.length,
          itemBuilder: (context, index) {
            final menuItem = _menuItems[index]; // Correction ici
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => menuItem['page'], // Correction ici
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

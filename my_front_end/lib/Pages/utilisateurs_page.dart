import 'package:flutter/material.dart';

class UtilisateursPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utilisateurs'),
      ),
      body: Center(
        child: Text(
          'Voici la page des Utilisateurs',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

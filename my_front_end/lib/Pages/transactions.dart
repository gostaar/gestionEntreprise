import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Center(
        child: Text(
          'Voici la page des Transactions',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

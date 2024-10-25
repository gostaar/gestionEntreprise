import 'package:flutter/material.dart';
import 'package:my_first_app/constants.dart';

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Center(
        child: Text(
          'Voici la page des transactions',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

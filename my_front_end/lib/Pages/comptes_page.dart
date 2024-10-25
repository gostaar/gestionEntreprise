import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour le décodage JSON
import 'package:my_first_app/Forms/AddCompteForm.dart';
import 'package:my_first_app/constants.dart';

class ComptesPage extends StatefulWidget {
  @override
  _ComptesPageState createState() => _ComptesPageState();
}

class _ComptesPageState extends State<ComptesPage> {
  List comptes = [];

  @override
  void initState() {
    super.initState();
    fetchComptes();
  }

  Future<void> fetchComptes() async {
    final response = await http.get(Uri.parse('$apiUrl/comptes'));

    if (response.statusCode == 200) {
      setState(() {
        comptes = json.decode(response.body);
      });
    } else {
      throw Exception('Erreur lors du chargement des comptes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comptes'),
      ),
      body: comptes.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: comptes.length,
              itemBuilder: (context, index) {
                final compte = comptes[index];
                return ListTile(
                  title:
                      Text('${compte['nom_compte']} ${compte['type_compte']}'),
                  subtitle: Text(compte['solde']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCompteModal(context); // Ouvre le modal pour ajouter un client
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showAddCompteModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              AddCompteForm(), // Appelle un widget contenant le formulaire d'ajout
        );
      },
    );
  }
}

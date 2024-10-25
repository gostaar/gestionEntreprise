import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour le décodage JSON
import 'package:my_first_app/Forms/AddClientForm.dart';
import 'package:my_first_app/constants.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List clients = []; // Liste qui contiendra les clients récupérés

  @override
  void initState() {
    super.initState();
    fetchClients(); // Appel à la fonction qui récupère les clients à l'initialisation
  }

  // Fonction pour récupérer les clients depuis l'API
  Future<void> fetchClients() async {
    final response = await http.get(Uri.parse('$apiUrl/clients'));

    if (response.statusCode == 200) {
      setState(() {
        clients = json.decode(
            response.body); // Stockage des données dans la liste 'clients'
      });
    } else {
      // En cas d'erreur, on lève une exception
      throw Exception('Erreur lors du chargement des clients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients'),
      ),
      body: clients.isEmpty
          ? Center(
              child: Text(
                'Aucun client disponible',
                style: TextStyle(fontSize: 24),
              ),
            ) // Affiche un loader en attendant les données
          : ListView.builder(
              itemCount: clients.length, // Nombre de clients récupérés
              itemBuilder: (context, index) {
                final client = clients[index];
                return ListTile(
                  title: Text(
                      '${client['nom']} ${client['prenom']}'), // Affiche le nom et prénom
                  subtitle: Text(client['email']), // Affiche l'email du client
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddClientModal(context); // Ouvre le modal pour ajouter un client
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Fonction pour afficher le formulaire d'ajout de client
  void _showAddClientModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              AddClientForm(), // Appelle un widget contenant le formulaire d'ajout
        );
      },
    );
  }
}

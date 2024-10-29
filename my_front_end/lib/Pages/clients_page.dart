import 'package:flutter/material.dart';
import 'package:my_first_app/Service/client_service.dart';
import '../Widget/global.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List clients = []; // Liste qui contiendra les clients récupérés

  @override
  void initState() {
    super.initState();
    _loadClients(); // Appel à la fonction qui récupère les clients à l'initialisation
  }
  
  void _loadClients() async {
    try {
      final clientsList = await ClientService.fetchClients();
      setState(() {
        clients = clientsList;
      });
    } catch (error) {
      print('Erreur : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients'),
      ),
      body: clients.isEmpty
          ? Center(child: CircularProgressIndicator()) 
          : ListView.builder(
              itemCount: clients.length, 
              itemBuilder: (context, index) {
                final client = clients[index];
                return ListTile(
                  title: Text(
                      '${client['nom']} ${client['prenom']}'), 
                  subtitle: Text(client['email']), 
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return const AddClientModal();
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

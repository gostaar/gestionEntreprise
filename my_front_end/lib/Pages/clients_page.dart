import 'package:flutter/material.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/models/client.dart';
import '../Widget/Functions.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Client> clients = []; 

  @override
  void initState() {
    super.initState();
    _loadClients(); 
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
                      '${client.nom} ${client.prenom}'), 
                  subtitle: Text(client.email ?? ""), 
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return const AddClientModal();
            },
          );
          if (result == true) { 
            _loadClients();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

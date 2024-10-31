import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/detailsClients.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/ligne_facture.dart';
import '../Widget/Functions.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Client> clients = []; 
  final factureService = FactureService();

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

  void _openDetailsClient(BuildContext context, Client client) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      final List<Facture> factures = await FactureService.getFacturesByClientId(client.clientId);
      Navigator.pop(context);

      List<LigneFacture> lignesFacturesData = [];
      for (var facture in factures) {
        final lignes = await factureService.getLignesFacture(facture.id);
        lignesFacturesData.addAll(lignes);
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClientDetailPage(
            factures: factures,
            client: client, 
            //lignesFacture: lignesFacturesData ?? [], 
          ),
        ),
      );
    } catch (error) {
      Navigator.pop(context);
      _showError(context, 'Erreur lors de la récupération des données: $error');
    }
  }
    
  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

  void _showInfo(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InfoDialog(message: message);
      },
    );
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
                  onTap:() => _openDetailsClient(context, client), 
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

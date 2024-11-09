import 'package:flutter/material.dart';
import 'package:my_first_app/Forms/Add/ClientForm.dart';
import 'package:my_first_app/Pages/Details/clientsPageDetails.dart';
import 'package:my_first_app/Service/clientService.dart';
import 'package:my_first_app/Service/factureService.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/factureModel.dart';
import 'package:my_first_app/models/ligneFactureModel.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Client> clients = []; 
    List<Client> filteredClients = [];
  final factureService = FactureService();
    final TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadClients(); 
    searchController.addListener(_filterClients);

  }
  
 @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadClients() async {
    try {
      final clientsList = await ClientService.fetchClients();
      if(mounted){setState(() {
        clients = clientsList;
        filteredClients = clientsList;  // Initialisation de la liste filtrée
      });}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors du chargement des clients: $e')),);
    }
  }

   void _filterClients() {
    final query = searchController.text.toLowerCase();
    setState(() {
       filteredClients = clients.where((client) {
      final clientName = client.nom.toLowerCase();
      final clientPrenom = client.prenom?.toLowerCase();
      return clientName.contains(query) || clientPrenom!.contains(query);
    }).toList();
    });
  }


  void _openDetailsClient(BuildContext context, Client client) async {
   try {
    final List<Facture> factures = await FactureService.getFacturesByClientId(client.clientId);
    final bool? isReload = await Navigator.push(context, MaterialPageRoute(builder: (context) => ClientDetailPage(factures: factures, client: client),)); 

    if(isReload != null && isReload){
      _loadClients(); 
    }
      
    
    List<LigneFacture> lignesFacturesData = [];
    for (var facture in factures) {
      final lignes = await factureService.getLignesFacture(facture.factureId);
      lignesFacturesData.addAll(lignes);
    }
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la récupération des données: $e')),);
  }
}

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Nom / Prénom',
                hintStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: filteredClients.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = filteredClients[index];
                      return ListTile(
                        title: Text('${client.nom} ${client.prenom}'),
                        subtitle: Text('Email: ${client.email ?? "Non renseigné"}\nNuméro client: ${client.clientId}'),
                        onTap: () => _openDetailsClient(context, client),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AddClientForm(createClientFunction: ClientService.createClient,),
                );
              },
            );
            _loadClients();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout du client: $e')),);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
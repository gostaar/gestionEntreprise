import 'package:flutter/material.dart';
import 'package:my_first_app/Forms/Add/CompteForm.dart';
import 'package:my_first_app/Service/clientService.dart';
import 'package:my_first_app/Service/compteService.dart';
import 'package:my_first_app/Service/factureFournisseurService.dart';
import 'package:my_first_app/Service/factureService.dart';
import 'package:my_first_app/Service/fournisseurService.dart';
import 'package:my_first_app/Widget/Compte/buildCompteListWidget.dart';
import 'package:my_first_app/Widget/Compte/createAccountFactureWidget.dart';
import 'package:my_first_app/Widget/Compte/createAccountFournisseurWidget.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/compteModel.dart';
import 'package:my_first_app/models/fournisseursModel.dart';

class ComptesPage extends StatefulWidget {
  @override
  _ComptesPageState createState() => _ComptesPageState();
}

class _ComptesPageState extends State<ComptesPage> {
  //List<Compte> comptes = []; 
  List<Compte> clientsComptes = []; 
  List<Compte> fournisseursComptes = []; 
  List<Client> client = [];
  List<Fournisseur> fournisseur = [];
  final CompteService compteService = CompteService();
  final factureService = FactureService();
  final factureFournisseurService = FactureFournisseurService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComptes();
  }

 Future<void> fetchComptes() async {
  try {
    client = await ClientService.fetchClients();
    fournisseur = await FournisseurService.fetchFournisseurs();
    final fetchedFacturesClients = await factureService.fetchFactures();
    final fetchedFacturesFournisseurs = await FactureFournisseurService.fetchFactureFournisseur();
    final fetchedComptesClients = await createAccountsFromInvoices(fetchedFacturesClients);
    final fetchedComptesFournisseurs = await createAccountsFromFournisseurInvoices(fetchedFacturesFournisseurs);

    setState(() {
      clientsComptes = fetchedComptesClients;
      fournisseursComptes = fetchedComptesFournisseurs; 
      isLoading = false; 
    });
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    throw Exception('Erreur lors du chargement des comptes : $e'); 
  }
}



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comptes'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Clients'),
              Tab(text: 'Fournisseurs'),
            ],
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: <Widget>[
                  buildComptesList(clientsComptes, 'client', client, fournisseur),
                  buildComptesList(fournisseursComptes, 'fournisseur', client, fournisseur),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AddCompteForm(addCompteFunction: CompteService.addCompte,),
                );
              },
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  
}

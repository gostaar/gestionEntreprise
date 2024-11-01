import 'package:flutter/material.dart';
import 'package:my_first_app/Forms/AddCompteForm.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Service/compte_service.dart';
import 'package:my_first_app/Service/facture_fournisseur_service.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/Widget/Functions.dart';
import 'package:my_first_app/Widget/Rendered.dart';
import 'package:my_first_app/models/compte.dart';

class ComptesPage extends StatefulWidget {
  @override
  _ComptesPageState createState() => _ComptesPageState();
}

class _ComptesPageState extends State<ComptesPage> {
  List<Compte> comptes = []; 
  List<Compte> clientsComptes = []; 
  List<Compte> fournisseursComptes = []; 
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
    final fetchedClients = await ClientService.fetchClients();
    final fetchedFacturesClients = await factureService.fetchFactures();
    final fetchedFacturesFournisseurs = await factureFournisseurService.fetchFactureFournisseur();

    final fetchedComptesClients = createAccountsFromInvoices(fetchedFacturesClients, fetchedClients);
    
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
    print('Erreur lors du chargement des comptes : $e'); 
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
                  buildComptesList(clientsComptes),
                  buildComptesList(fournisseursComptes),
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
                  child: AddCompteForm(),
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
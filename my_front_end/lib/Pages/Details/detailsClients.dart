import 'package:flutter/material.dart';
import 'package:my_first_app/Forms/Edit/ClientForm.dart';
import 'package:my_first_app/Pages/Details/detailsFacture.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/ligne_facture.dart';
import 'package:my_first_app/Widget/Functions.dart';
import 'package:my_first_app/Widget/Rendered.dart';

class ClientDetailPage extends StatefulWidget {
  final Client client; 
  final List<Facture> factures;

  const ClientDetailPage({
    required this.client,
    required this.factures,
  });

  @override
  _ClientDetailPageState createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  late Client client;
  late List<Facture> factures;
  bool isEditing = false;
  final Map<String, TextEditingController> controllers = {};
  
  @override
  void initState() {
    super.initState();
    client = widget.client;
    factures = widget.factures;
    _initializeControllers();
  }

  void _toggleEditMode() {
    setState(() {
      if (isEditing) _updateClient();
      isEditing = !isEditing;
    });
  }

  void _initializeControllers() {
    const fields = [
      'nom', 'prenom', 'email', 'telephone', 
      'adresse', 'ville', 'codePostal', 'pays', 'numeroTva'
    ];
    for (var field in fields) {
      controllers[field] = TextEditingController(text: _getFieldValue(field));
    }
  }

  String _getFieldValue(String field) {return client.toJson()[field] ?? ''; }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _updateClient() async {
    final updatedClientData = controllers.map((key, controller) => MapEntry(key, controller.text)).cast<String, String>();
    final updatedClient = client.copyWith(
      nom: updatedClientData['nom'] ?? client.nom,
      prenom: updatedClientData['prenom'] ?? client.prenom,
      email: updatedClientData['email'] ?? client.email,
      telephone: updatedClientData['telephone'] ?? client.telephone,
      adresse: updatedClientData['adresse'] ?? client.adresse,
      ville: updatedClientData['ville'] ?? client.ville,
      codePostal: updatedClientData['codePostal'] ?? client.codePostal,
      pays: updatedClientData['pays'] ?? client.pays,
      numeroTva: updatedClientData['numeroTva'] ?? client.numeroTva,
    );

    try {
      await ClientService.updateClient(updatedClient);
      final reloadedClient = await ClientService.getClientById(updatedClient.clientId);
      setState(() {
        client = reloadedClient;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Client mis à jour avec succès')),
      );
    } catch (error) {
      showError(context, 'Erreur lors de la mise à jour du client: $error');
    }
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _navigateToFacturesPage(BuildContext context, Facture f) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final lignesFacture = await _fetchLignesFacture(f.id);
      final clientDetails = await ClientService.getClientById(f.clientId);
      Navigator.pop(context);
      _navigateTo(
        context,
        FactureDetailPage(
          facture: f,
          lignesFacture: lignesFacture,
          client: clientDetails,
        ),
      );
    } catch (error) {
      Navigator.pop(context);
      showError(context, 'Erreur lors de la récupération des factures: $error');
    }
  }

  Future<List<LigneFacture>> _fetchLignesFacture(int factureId) async {
    return await FactureService().getLignesFacture(factureId);
  }

  Widget buildFacturesTab(BuildContext context, List<Facture> factures, Function(BuildContext, Facture) onNavigate) {
    if (factures.isEmpty) {
      return Center(child: Text('Aucune facture pour ce client'));
    }

    return ListView.builder(
      itemCount: factures.length,
      itemBuilder: (context, index) {
        final facture = factures[index];
        return ListTile(
          title: Text('Facture ${facture.id}'),
          subtitle: FactureInfoSection(facture: facture),
          onTap: () => _navigateToFacturesPage(context, facture),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fiche de ${client.nom}'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          actions: [
            IconButton(
              icon: Icon(isEditing ? Icons.save : Icons.edit),
              color: isEditing ? Colors.red : Colors.black,
              onPressed: _toggleEditMode,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Détails'),
              Tab(text: 'Factures'),
            ],
          ),
        ),
        body: FutureBuilder<Client>(
          future: ClientService.getClientById(client.clientId),
          builder: (BuildContext context, AsyncSnapshot<Client> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Aucun client trouvé.'));
            } else {
              //final updatedClient = snapshot.data!;
              return TabBarView(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: controllers.entries
                          .map((entry) => buildDetailRowRendered(entry.key, entry.value, isEditing))
                          .toList(),
                    ),
                  ),
                  buildFacturesTab(context, factures, _navigateToFacturesPage),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}



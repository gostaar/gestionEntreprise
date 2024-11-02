import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/Details/detailsFacture.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/Widget/Functions.dart';
import 'package:my_first_app/models/ligne_facture.dart';

class ClientDetailPage extends StatelessWidget {
  final Client client; 
  final List<Facture> factures;

  ClientDetailPage({
    required this.client,
    required this.factures,
  });

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
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

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FactureDetailPage(
            facture: f,
            lignesFacture: lignesFacture,
            client: clientDetails,
          ),
        ),
      );
    } catch (error) {
      Navigator.pop(context); 
      _showError(context, 'Erreur lors de la récupération des factures: $error');
    }
  }

  // Méthode pour récupérer les lignes de facture
  Future<List<LigneFacture>> _fetchLignesFacture(int factureId) async {
    final factureService = FactureService();
    return await factureService.getLignesFacture(factureId);
  }

  Widget buildFacturesTab(BuildContext context, List<Facture> factures, Function(BuildContext, Facture) onNavigate) {
    if (factures.isEmpty) {
      return Column(
        children: [
          SizedBox(height: 16),
          Text(
            'Aucune facture pour ce client',
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: factures.length,
      itemBuilder: (context, index) {
        final facture = factures[index];
        
        return ListTile(
          title: Text('Facture ${facture.id}'),
          subtitle: FactureInfoSection(facture: facture),
          onTap: () => onNavigate(context, facture),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Deux onglets : Détails et Factures
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fiche de ${client.nom}'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Détails'),
              Tab(text: 'Factures'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            clientDetailWidget(context, client),
            buildFacturesTab(context, factures, _navigateToFacturesPage),
          ],
        ),
      ),
    );
  }
}

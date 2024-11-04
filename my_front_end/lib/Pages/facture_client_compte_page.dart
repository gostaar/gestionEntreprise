import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/Details/detailsFacture.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/Widget/dialogs.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/facture.dart';

class FacturesClientComptePage extends StatelessWidget {
  final Client client;
  final List<Facture> factures;

  FacturesClientComptePage({
    required this.client,
    required this.factures,
  });

  @override
  Widget build(BuildContext context) {
    // Sépare les factures en fonction de leur statut
    final facturesPayees = factures.where((facture) => facture.statut == 'Payée').toList();
    final facturesNonPayees = factures.where((facture) => facture.statut != 'Payée').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Factures de ${client.nom}'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Payé'),
              Tab(text: 'Non Payé'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FactureListView(factures: facturesPayees, title: 'Factures Payées'),
            FactureListView(factures: facturesNonPayees, title: 'Factures Non Payées'),
          ],
        ),
      ),
    );
  }
}

class FactureListView extends StatelessWidget {
  final List<Facture> factures;
  final String title;
  final factureService = FactureService();

  FactureListView({
    required this.factures,
    required this.title,
  });

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

  void _navigateToDetailPage(BuildContext context, Facture facture) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final lignesFactureData = await factureService.getLignesFacture(facture.id);
      final client = await ClientService.getClientById(facture.clientId);

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FactureDetailPage(
            facture: facture,
            client: client,
            lignesFacture: lignesFactureData,
          ),
        ),
      );
    } catch (error) {
      Navigator.pop(context);
      _showError(context, 'Erreur lors de la récupération des données: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return factures.isEmpty
        ? Center(child: Text('Aucune facture pour $title'))
        : ListView.builder(
            itemCount: factures.length,
            itemBuilder: (context, index) {
              final facture = factures[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('Facture N°${facture.id}'),
                  subtitle: Text('Montant: ${facture.montantTotal?.toStringAsFixed(2)} €'),
                  trailing: Text(facture.statut ?? 'Non renseigné', style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () => _navigateToDetailPage(context, facture),
                ),
              );
            },
          );
  }
}

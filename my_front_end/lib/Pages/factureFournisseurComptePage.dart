import 'package:flutter/material.dart';
import 'package:my_first_app/models/factureFournisseurModel.dart';
import 'package:my_first_app/models/fournisseursModel.dart';

class FacturesFournisseurComptePage extends StatelessWidget {
  final Fournisseur fournisseur;
  final List<FactureFournisseur> facturesFournisseur;

  FacturesFournisseurComptePage({
    required this.fournisseur,
    required this.facturesFournisseur,
  });

  @override
  Widget build(BuildContext context) {
    // Sépare les factures en fonction de leur statut
    final facturesPayees = facturesFournisseur.where((facture) => facture.statut == 'Payée').toList();
    final facturesNonPayees = facturesFournisseur.where((facture) => facture.statut != 'Payée').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Factures de ${fournisseur.nom}'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Payé'),
              Tab(text: 'Non Payé'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FactureFournisseurListView(factures: facturesPayees, title: 'Factures Payées'),
            FactureFournisseurListView(factures: facturesNonPayees, title: 'Factures Non Payées'),
          ],
        ),
      ),
    );
  }
}

class FactureFournisseurListView extends StatelessWidget {
  final List<FactureFournisseur> factures;
  final String title;

  FactureFournisseurListView({
    required this.factures,
    required this.title,
  });

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
                ),
              );
            },
          );
  }
}

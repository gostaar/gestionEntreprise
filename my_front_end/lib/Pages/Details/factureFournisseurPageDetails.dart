import 'package:flutter/material.dart';
import 'package:my_first_app/models/factureFournisseurModel.dart';
import 'package:my_first_app/models/fournisseursModel.dart';

class FactureFournisseurDetailPage extends StatelessWidget {
  final List<FactureFournisseur> factures;
  final Fournisseur fournisseur;

  FactureFournisseurDetailPage({
    required this.factures,
    required this.fournisseur,
  });

@override
  Widget build(BuildContext context) {
    // Display the list of invoices (factures) here
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de ${fournisseur.nom}'),
      ),
      body: ListView.builder(
        itemCount: factures.length,
        itemBuilder: (context, index) {
          final facture = factures[index];
          return ListTile(
            title: Text('Facture ID: ${facture.id}'), // Example field
            subtitle: Text('Montant: ${facture.montantTotal}'), // Example field
          );
        },
      ),
    );
  }
}

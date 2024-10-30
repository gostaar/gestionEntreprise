import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/Service/produit_service.dart';
import 'package:my_first_app/Widget/Functions.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/ligne_facture.dart';
import 'package:my_first_app/models/produit.dart';

class FactureClientDetailPage extends StatelessWidget {
  final Client client;

  FactureClientDetailPage({
    required this.client,
  });

 Future<void> _showFactureDetails(BuildContext context, Facture facture) async {
  // Affiche un indicateur de chargement pendant que les données sont récupérées
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );
  final factureService = FactureService();

  try {
    // Récupérer les lignes de la facture
    List<LigneFacture> lignesFacture = await factureService.getLignesFacture(facture.id);

    // Fermer le dialogue de chargement
    Navigator.pop(context);

    // Afficher les détails de la facture dans une popup
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Détails Facture ${facture.id}'),
          content: SingleChildScrollView( // Utiliser un SingleChildScrollView pour éviter les débordements
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Date : ${facture.dateFacture}'),
                Text('Montant : ${facture.montantTotal} €'),
                const SizedBox(height: 10), // Espace entre les sections
                Text('Lignes de la Facture:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10), // Espace entre les sections
                // Afficher les lignes de la facture
                FutureBuilder<List<Widget>>(
                  future: _buildProductRows(lignesFacture),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Erreur lors du chargement des lignes de facture'));
                    }

                    return Column(children: snapshot.data!);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  } catch (error) {
    // Fermer le dialogue de chargement en cas d'erreur
    Navigator.pop(context);
    // Afficher un message d'erreur
    _showError(context, 'Erreur lors de la récupération des lignes de la facture: $error');
  }
}


Future<List<Widget>> _buildProductRows(List<LigneFacture> lignesFacture) async {
  List<Widget> rows = [];

  // Vérifiez si les lignes de facture sont nulles ou vides
  if (lignesFacture == null || lignesFacture.isEmpty) {
    // Ajoutez un message à la liste si aucune ligne n'est renseignée
    rows.add(Text('Aucun produit'));
  } else {
    for (var ligne in lignesFacture) {
      // Récupérer le produit associé à la ligne de facture
      List<Produit>? produits = await ProduitService.getProduitsById(ligne.produitId);
      Produit? produit = (produits != null && produits.isNotEmpty) ? produits.first : null;

      // Créer un widget pour afficher les détails de la ligne de facture et du produit
      rows.add(
        ListTile(
          title: Text('Produit: ${produit?.description ?? "Inconnu"}'), // Nom du produit
          subtitle: Text('Quantité: ${ligne.quantite} - Prix: ${produit?.prix ?? 0} €'),
        ),
      );
    }
  }

  return rows;
}


void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

  Future<List<Facture>> _fetchFactures() async {
    return await FactureService.getFacturesByClientId(client.clientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Factures de ${client.nom}'),
      ),
      body: FutureBuilder<List<Facture>>(
        future: _fetchFactures(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune facture trouvée pour ce client.'));
          }

          final factures = snapshot.data!;
          return ListView.builder(
            itemCount: factures.length,
            itemBuilder: (context, index) {
              final facture = factures[index];
              return ListTile(
                title: Text('Facture ${facture.id}'),
                subtitle: Text('Montant : ${facture.montantTotal} €'),
                onTap: () => _showFactureDetails(context, facture),
              );
            },
          );
        },
      ),
    );
  }
}

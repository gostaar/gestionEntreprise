import 'package:flutter/material.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/ligne_facture.dart';
import 'package:my_first_app/models/produit.dart';
import 'package:my_first_app/Service/produit_service.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Widget/Functions.dart';

class FactureDetailPage extends StatelessWidget {
  final Facture facture;
  final List<LigneFacture> lignesFacture;

  FactureDetailPage({
    required this.facture,
    required this.lignesFacture,
    required Client client,
  });

  String formatDate(DateTime? date) {
    if (date == null) return 'Non spécifiée';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<List<Widget>> _buildProductRows() async {
    List<Widget> rows = [];
    for (var ligne in lignesFacture) {
      Produit? produit = await _getProduit(ligne.produitId);
      rows.add(ProductDescriptionRow(produit: produit));
      rows.add(ProductDetailsRow(ligne: ligne));
    }
    return rows;
  }

  Future<Produit?> _getProduit(int produitId) async {
    List<Produit>? produits = await ProduitService.getProduitsById(produitId);
    return produits != null && produits.isNotEmpty ? produits.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Facture #${facture.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Client?>(
          future: ClientService.getClientById(facture.clientId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Erreur lors de la récupération du client'));
            }

            final Client client = snapshot.data!;
            return ListView(
              children: [
                ClientInfoSection(client: client),
                FactureInfoSection(facture: facture),
                const SizedBox(height: 20),
                const TableHeader(),
                Divider(thickness: 2),
                FutureBuilder<List<Widget>>(
                  future: _buildProductRows(),
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
            );
          },
        ),
      ),
    );
  }
}

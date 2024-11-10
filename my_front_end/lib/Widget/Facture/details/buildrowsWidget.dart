import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Service/produitService.dart';
import 'package:my_first_app/models/ligneFactureModel.dart';
import 'package:my_first_app/models/produitModel.dart';

class ProductRowsWidget extends StatelessWidget {
  final List<LigneFacture> lignesFacture;

  const ProductRowsWidget({Key? key, required this.lignesFacture}) : super(key: key);

  Future<List<Widget>> _buildProductRows() async {
    List<Widget> rows = [];
    List<Produit?> produits = await Future.wait(
      lignesFacture.map((ligne) => _getProduit(ligne.produitId)),
    );

    for (int i = 0; i < lignesFacture.length; i++) {
      var ligne = lignesFacture[i];
      var produit = produits[i];

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(child: Text(produit?.description ?? 'Produit non trouvé')),
            ],
          ),
        ),
      );

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: SizedBox()), // Cellule vide pour le produit
              Text(
                NumberFormat.decimalPattern('fr_FR').format(ligne.quantite),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 16),
              Text(
                NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(ligne.prixUnitaire),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 16),
              Text(
                NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(ligne.sousTotal),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    return rows;
  }

  Future<Produit?> _getProduit(int produitId) async {
    List<Produit>? produits = await ProduitService.getProduitsById(produitId);
    return produits != null && produits.isNotEmpty ? produits.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: _buildProductRows(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun produit à afficher.'));
        } else {
          return Column(
            children: snapshot.data!,
          );
        }
      },
    );
  }
}

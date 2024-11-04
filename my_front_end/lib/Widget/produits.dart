import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/models/ligne_facture.dart';
import 'package:my_first_app/models/produit.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(height: 10),
        Expanded(child: Text('Produit', style: TextStyle(fontWeight: FontWeight.bold))),
        SizedBox(width: 16),
        Text('Quantité', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 16),
        Text('Prix Unitaire', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 16),
        Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class ProductDescriptionRow extends StatelessWidget {
  final Produit? produit;

  const ProductDescriptionRow({Key? key, required this.produit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: Text(produit?.description ?? 'Produit non trouvé')),
        ],
      ),
    );
  }
}
class ProductDetailsRow extends StatelessWidget {
  final LigneFacture ligne;

  const ProductDetailsRow({Key? key, required this.ligne}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int quantite = ligne.quantite; // Default to 0 if null
    final String formattedQuantite = NumberFormat.decimalPattern('fr_FR').format(quantite);
    final double prixUnitaire = double.tryParse(ligne.prixUnitaire) ?? 0.0; // Default to 0.0 if null
    final String formattedPrixUnitaire = NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(prixUnitaire);
    final double sousTotal = double.tryParse(ligne.sousTotal) ?? 0.0; // Default to 0.0 if null
    final String formattedSousTotal = NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(sousTotal);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Ajout d'un espacement vertical
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacement entre les éléments
        children: [
          Expanded(child: SizedBox()), // Cellule vide pour le produit
          Text(formattedQuantite, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 16),
          Text(formattedPrixUnitaire, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 16),
          Text(formattedSousTotal, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

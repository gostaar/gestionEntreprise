import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/models/ligneFactureModel.dart';
import 'package:my_first_app/models/produitModel.dart';

Future<List<Widget>> BuildProductRows(
  List<LigneFacture> lignesFacture,
  Future<Produit?> Function(int produitId) getProduit
) async {
    List<Widget> rows = [];
    
    List<Produit?> produits = await Future.wait(
      lignesFacture.map((ligne) => getProduit(ligne.produitId)),
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
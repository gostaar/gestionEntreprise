import 'package:flutter/material.dart';
import 'package:my_first_app/Widget/customWidget/buildDetailRowWidget.dart';
import 'package:my_first_app/models/fournisseursModel.dart';

Widget fournisseurDetailWidget(BuildContext context, Fournisseur fournisseur) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildDetailRow('Nom', fournisseur.nom),
          buildDetailRow('Prénom', fournisseur.prenom),
          buildDetailRow('Email', fournisseur.email),
          buildDetailRow('Téléphone', fournisseur.telephone),
          buildDetailRow('Adresse', fournisseur.adresse),
          buildDetailRow('Ville', fournisseur.ville),
          buildDetailRow('Code postal', fournisseur.codePostal),
          buildDetailRow('Pays', fournisseur.pays),
          buildDetailRow('Numéro de TVA', fournisseur.numeroTva),
        ],
      ),
    ),
  );
}
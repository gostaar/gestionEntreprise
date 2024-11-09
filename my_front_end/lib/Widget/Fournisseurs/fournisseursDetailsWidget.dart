import 'package:flutter/material.dart';
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

Widget buildDetailRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120, 
          child: Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value ?? 'Non renseigné'),
        ),
      ],
    ),
  );
}
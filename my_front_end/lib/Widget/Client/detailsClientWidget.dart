import 'package:flutter/material.dart';
import 'package:my_first_app/Widget/customWidget/buildDetailRowWidget.dart';
import 'package:my_first_app/models/clientModel.dart';

Widget clientDetailWidget(BuildContext context, Client client) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildDetailRow('Nom', client.nom),
          buildDetailRow('Prénom', client.prenom),
          buildDetailRow('Email', client.email),
          buildDetailRow('Téléphone', client.telephone),
          buildDetailRow('Adresse', client.adresse),
          buildDetailRow('Ville', client.ville),
          buildDetailRow('Code postal', client.codePostal),
          buildDetailRow('Pays', client.pays),
          buildDetailRow('Numéro de TVA', client.numeroTva),
        ],
      ),
    ),
  );
}
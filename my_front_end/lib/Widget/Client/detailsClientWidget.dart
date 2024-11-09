import 'package:flutter/material.dart';
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/clientModel.dart';

Widget clientDetailWidget(BuildContext context, Client client) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildDetailRow(nomLabel, client.nom),
          buildDetailRow(prenomLabel, client.prenom),
          buildDetailRow(emailLabel, client.email),
          buildDetailRow(telephoneLabel, client.telephone),
          buildDetailRow(adresseLabel, client.adresse),
          buildDetailRow(villeLabel, client.ville),
          buildDetailRow(codePostalLabel, client.codePostal),
          buildDetailRow(paysLabel, client.pays),
          buildDetailRow(tvaLabel, client.numeroTva),
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
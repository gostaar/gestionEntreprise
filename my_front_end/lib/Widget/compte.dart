import 'package:flutter/material.dart';
import 'package:my_first_app/Widget/widgets.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/compte.dart';
import 'package:my_first_app/models/fournisseurs.dart';

Widget buildComptesList(List<Compte> comptes, String typeCompte, List<Client> clients, List<Fournisseur> fournisseurs) {
  if (comptes.isEmpty) {
    return Center(child: Text('Aucun compte disponible'));
  }

  return ListView.builder(
    itemCount: comptes.length,
    itemBuilder: (context, index) {
      final compte = comptes[index];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: InkWell(
          onTap: () {
            navigateToFacturePage(context, compte, clients, fournisseurs);
          },
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      compte.nomCompte,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('Débit', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 4),
                          Text('${compte.montantDebit.toStringAsFixed(2)} €', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Crédit', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 4),
                          Text('${compte.montantCredit.toStringAsFixed(2)} €', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

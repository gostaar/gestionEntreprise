import 'package:flutter/material.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Service/fournisseur_service.dart';
import 'package:my_first_app/Widget/widgets.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/compte.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/factureFournisseur.dart';
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

Future<List<Compte>> createAccountsFromFournisseurInvoices(List<FactureFournisseur> fetchedFacturesFournisseurs) async {
  Map<String, Map<String, double>> compteMap = {}; // Map pour agréger les montants
  Map<String, int> fournisseurIds = {};

  for (var factureFournisseur in fetchedFacturesFournisseurs) {
    // Récupérer le fournisseur à partir de son ID
    Fournisseur fournisseur = await FournisseurService.getFournisseursById(factureFournisseur.fournisseurId);

    // Initialiser l’entrée dans la Map si elle n'existe pas encore
    if (!compteMap.containsKey(fournisseur.nom)) {
      compteMap[fournisseur.nom] = {'Débit': 0.0, 'Crédit': 0.0, };
      fournisseurIds[fournisseur.nom] = fournisseur.fournisseurId;
    }

    // Calculer le montant à ajouter
    double montant = factureFournisseur.montantTotal ?? 0.0;

    // Ajouter le montant au crédit ou au débit selon la logique métier
    if (factureFournisseur.statut == 'Payée') {
      compteMap[fournisseur.nom]!['Débit'] = (compteMap[fournisseur.nom]!['Débit'] ?? 0.0) + montant;
    } else {
      compteMap[fournisseur.nom]!['Crédit'] = (compteMap[fournisseur.nom]!['Crédit'] ?? 0.0) + montant;
    }
}
  // Convertir le Map en liste de comptes
  List<Compte> comptes = [];
  compteMap.forEach((nomFournisseur, montants) {
    comptes.add(Compte(
      compteId: fournisseurIds[nomFournisseur]!,
      nomCompte: nomFournisseur,
      typeCompte: 'Fournisseur',
      montantDebit: montants['Débit']!,
      montantCredit: montants['Crédit']!,
      dateCreation: DateTime.now().toIso8601String(),
    ));
  });

  return comptes;
}

Future<List<Compte>> createAccountsFromInvoices(List<Facture> fetchedFactures) async {
  Map<String, Map<String, double>> compteMap = {}; // Map pour stocker les montants par client
  Map<String, int> clientIds = {};

  for (var factureClient in fetchedFactures) {
    Client client = await ClientService.getClientById(factureClient.clientId);

    // Initialiser le client dans la map si ce n'est pas déjà fait
    if (!compteMap.containsKey(client.nom)) {
      compteMap[client.nom] = {'Débit': 0.0, 'Crédit': 0.0};
      clientIds[client.nom] = client.clientId;
    }

    // Ajouter les montants en fonction du statut de la facture
    if (factureClient.statut == 'Payée') {
      compteMap[client.nom]!['Débit'] = compteMap[client.nom]!['Débit']! + (factureClient.montantTotal ?? 0.0);
    } else {
      compteMap[client.nom]!['Crédit'] = compteMap[client.nom]!['Crédit']! + (factureClient.montantTotal ?? 0.0);
    }
  }
    // Convertir le Map en liste de comptes
    List<Compte> comptes = [];
    compteMap.forEach((nomClient, montants) {
      comptes.add(Compte(
        compteId: clientIds[nomClient]!, // Assurez-vous que `client.clientId` est défini dans chaque boucle.
        nomCompte: nomClient,
        typeCompte: 'Client',
        montantDebit: montants['Débit']!,
        montantCredit: montants['Crédit']!,
        dateCreation: DateTime.now().toIso8601String(),
      ));
    });

    return comptes;
  }

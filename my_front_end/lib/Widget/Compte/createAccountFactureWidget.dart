import 'package:my_first_app/Service/clientService.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/compteModel.dart';
import 'package:my_first_app/models/factureModel.dart';

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
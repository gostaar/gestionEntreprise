//utilisé dans compte/buildCompteListWidget
import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/factureClientComptePage.dart';
import 'package:my_first_app/Pages/factureFournisseurComptePage.dart';
import 'package:my_first_app/Service/factureFournisseurService.dart';
import 'package:my_first_app/Service/factureService.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/compteModel.dart';
import 'package:my_first_app/models/factureFournisseurModel.dart';
import 'package:my_first_app/models/factureModel.dart';
import 'package:my_first_app/models/fournisseursModel.dart';

void navigateToFacturePage(BuildContext context, Compte compte, List<Client> clients, List<Fournisseur> fournisseurs) async {
  if (compte.typeCompte == 'Client') {
    final matchingClients = clients.where((c) => c.clientId == compte.compteId);
    final Client? client = matchingClients.isNotEmpty ? matchingClients.first : null;
    if (client != null) {
      // Récupération des factures pour le client
      try {
        final List<Facture> facturesClient = await FactureService.getFacturesByClientId(client.clientId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FacturesClientComptePage(client: client, factures: facturesClient),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la récupération des factures du client: $e')),);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('client non trouvé pour le compte: ${compte.nomCompte}')),);
    }
  } else if (compte.typeCompte == 'Fournisseur') {
    final matchingFournisseurs = fournisseurs.where((f) => f.fournisseurId == compte.compteId);
    final Fournisseur? fournisseur = matchingFournisseurs.isNotEmpty ? matchingFournisseurs.first : null;
    if (fournisseur != null) {
      // Récupération des factures pour le fournisseur
      try {
        final List<FactureFournisseur> facturesFournisseur = await FactureFournisseurService.getFactureFournisseurByFournisseurId(fournisseur.fournisseurId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FacturesFournisseurComptePage(fournisseur: fournisseur, facturesFournisseur: facturesFournisseur),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors du chargement des fournisseurs: $e')),);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fournisseur non trouvé pour le compte : ${compte.nomCompte}')),);
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Type de compte non reconnu : ${compte.typeCompte}')),);
  }
}
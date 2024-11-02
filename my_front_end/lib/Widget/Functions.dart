import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Forms/AddClientForm.dart';
import 'package:my_first_app/Forms/AddFournisseurForm.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Service/fournisseur_service.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/compte.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/factureFournisseur.dart';
import 'package:my_first_app/models/fournisseurs.dart';
import 'package:my_first_app/models/ligne_facture.dart';
import 'package:my_first_app/models/produit.dart';

// Dialogue d'erreur
class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Erreur'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class InfoDialog extends StatelessWidget {
  final String message;

  const InfoDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Info'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

// Modal pour ajouter un client
class AddClientModal extends StatelessWidget {
  const AddClientModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AddClientForm(),
    );
  }
}

class AddFournisseurModal extends StatelessWidget {
  const AddFournisseurModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AddFournisseurForm(),
    );
  }
}

// Section Info du Client
class ClientInfoSection extends StatelessWidget {
  final Client client;

  const ClientInfoSection({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Client: ${client.nom} ${client.prenom}', style: TextStyle(fontSize: 20)),
        Text('Email: ${client.email}', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

class FournisseurInfoSection extends StatelessWidget {
  final Fournisseur fournisseur;

  const FournisseurInfoSection({Key? key, required this.fournisseur}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fournisseur: ${fournisseur.nom} ${fournisseur.prenom}', style: TextStyle(fontSize: 20)),
        Text('Email: ${fournisseur.email}', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

// Section Info de la Facture
class FactureInfoSection extends StatelessWidget {
  final Facture facture;

  const FactureInfoSection({Key? key, required this.facture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double montantTotal = facture.montantTotal ?? 0.0; 
    final String formattedMontant = NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(montantTotal);
    String formattedDate = facture.dateFacture != null
      ? DateFormat('dd/MM/yyyy').format(facture.dateFacture!)
      : 'Date non renseignée';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Montant Total: ${formattedMontant}\nDate: ${formattedDate}'),
        Divider(thickness: 1, color: Colors.grey[400]),   
      ],
    );
  }
}

class FactureFournisseurInfoSection extends StatelessWidget {
  final FactureFournisseur facture;

  const FactureFournisseurInfoSection({Key? key, required this.facture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double montantTotal = facture.montantTotal ?? 0.0; 
    final String formattedMontant = NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(montantTotal);
    String formattedDate = facture.dateFacture != null
      ? DateFormat('dd/MM/yyyy').format(facture.dateFacture!)
      : 'Date non renseignée';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Montant Total: ${formattedMontant}\nDate: ${formattedDate}'),
        Divider(thickness: 1, color: Colors.grey[400]),   
      ],
    );
  }
}

// En-tête du tableau des produits
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

// Widget pour afficher la description du produit
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

// Widget pour afficher les détails du produit
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

// Fonction auxiliaire pour créer une ligne de détail avec un label en gras et alignement vertical
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

//fonctions pour afficher les factures par rapport au client
Widget buildFacturesTab(BuildContext context, List<Facture> factures, Function navigateToFacturesPage) {
  if (factures.isEmpty) {
    return Center(
      child: Text('Aucune facture trouvée pour ce client.'),
    );
  } else {
    return ListView.builder(
      itemCount: factures.length,
      itemBuilder: (context, index) {
        final facture = factures[index];
        return ListTile(
          title: Text('Facture #${facture.id}'),
          subtitle: FactureInfoSection(facture: facture),
          onTap: () => navigateToFacturesPage(context), // Navigation vers les détails de la facture
        );
      },
    );
  }
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


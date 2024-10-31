import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Forms/AddClientForm.dart';
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
  List<Compte> comptes = [];

  for (var factureFournisseur in fetchedFacturesFournisseurs) {
    // Récupérer le fournisseur à partir de son ID
    Fournisseur fournisseur = await FournisseurService.getFournisseursById(factureFournisseur.fournisseurId);
    // Supposons que montantDebit et montantCredit soient extraits de la facture ou définis par défaut
    double montantDebit = 0.0; // Vous pouvez définir cela selon votre logique
    double montantCredit = factureFournisseur.montantTotal ?? 0.0; // Montant total de la facture
    String dateCreation = DateTime.now().toIso8601String(); // Date actuelle


    comptes.add(Compte(
      compteId: fournisseur.fournisseurId, // ou un ID approprié pour le compte
      nomCompte: fournisseur.nom,
      typeCompte: 'Fournisseur',
      montantDebit: montantDebit,
      montantCredit: montantCredit,
      dateCreation: dateCreation,
    ));
  }

  return comptes;
}


List<Compte> createAccountsFromInvoices(List<Facture> factures, List<Client> clients) {
  Map<String, Map<String, double>> compteMap = {}; // Map pour stocker débit et crédit par client

  Map<int, String> clientMap = {};
  for (var client in clients) {
    clientMap[client.clientId] = '${client.nom} ${client.prenom}';
  }

  for (var facture in factures) {
    String nomClient = clientMap[facture.clientId] ?? 'Client Inconnu';
    double montant = facture.montantTotal ?? 0.0;

    // Initialiser le compte si nécessaire
    if (!compteMap.containsKey(nomClient)) {
      compteMap[nomClient] = {'Débit': 0.0, 'Crédit': 0.0};
    }

    // Ajouter au bon montant selon le statut de la facture
    if (facture.statut == 'Payée') {
      compteMap[nomClient]!['Crédit'] = (compteMap[nomClient]!['Crédit'] ?? 0) + montant;
    } else {
      compteMap[nomClient]!['Débit'] = (compteMap[nomClient]!['Débit'] ?? 0) + montant;
    }
  }

  // Convertir le Map en liste de comptes
  List<Compte> comptes = [];
  compteMap.forEach((nomClient, montants) {
    comptes.add(Compte(
      compteId: comptes.length + 1,
      nomCompte: nomClient,
      typeCompte: 'Client',
      montantDebit: montants['Débit']!,
      montantCredit: montants['Crédit']!,
      dateCreation: DateTime.now().toIso8601String(),
    ));
  });

  return comptes;
}

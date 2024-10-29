import 'package:flutter/material.dart';
import 'package:my_first_app/Forms/AddClientForm.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/ligne_facture.dart';
import 'package:my_first_app/models/produit.dart';

void circleAwait(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: CircularProgressIndicator(),
    ),
  );
}

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

  const ClientInfoSection({required this.client});

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

  const FactureInfoSection({required this.facture});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Montant Total: ${facture.montantTotal} €', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        Text('Détails de la facture:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
      ],
    );
  }
}

// En-tête du tableau des produits
class TableHeader extends StatelessWidget {
  const TableHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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

  const ProductDescriptionRow({required this.produit});

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

  const ProductDetailsRow({required this.ligne});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox()), // Cellule vide pour le produit
        Text(ligne.quantite.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 16),
        Text('${ligne.prixUnitaire} €', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 16),
        Text('${ligne.sousTotal} €', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
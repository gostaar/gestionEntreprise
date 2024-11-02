import 'package:flutter/material.dart';
import 'package:my_first_app/Service/facture_fournisseur_service.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/compte.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/factureFournisseur.dart';
import 'package:my_first_app/models/fournisseurs.dart';
import 'package:my_first_app/models/produit.dart';

import '../Pages/Intermediaire/facture_client_compte_page.dart';
import '../Pages/Intermediaire/facture_fournisseur_compte_page.dart';

//Bouton avec action
Widget actionButton(String text, VoidCallback action) {
  return Align(
    alignment: Alignment.centerRight,
    child: TextButton(
      onPressed: () {
        action();
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
}

Widget textButtonDangerClient(List<Client> arg, String text) {
  return arg.isEmpty
      ? Text(
          text,
          style: TextStyle(color: Colors.red), 
        )
      : SizedBox.shrink(); 
}

Widget textButtonDangerFournisseur(List<Fournisseur> arg, String text) {
  return arg.isEmpty
      ? Text(
          text,
          style: TextStyle(color: Colors.red), 
        )
      : SizedBox.shrink(); 
}

Widget textButtonDangerProduit(List<Produit> arg, String text) {
  return arg.isEmpty
      ? Text(
          text,
          style: TextStyle(color: Colors.red), 
        )
      : SizedBox.shrink(); 
}

//Date Picker
Widget datePickerFull(TextEditingController controller, BuildContext context,
  String labelText, Future <void> Function(BuildContext, TextEditingController) selectDate) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(Icons.calendar_today),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
    readOnly: true,
    onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
      selectDate(context, controller);
    },
  );
}

//DropDownClient
Widget clientDropdown(int? selectedClient, String text,
    List<Client> clients, Function(int?) onChanged) {
  return DropdownButtonFormField<int>(
    value: selectedClient,
    decoration: InputDecoration(labelText: text),
    items: clients.isNotEmpty
        ? clients.map((client) {
            return DropdownMenuItem<int>(
              value: client.clientId,
              child: Text(client.nom),
            );
          }).toList()
        : [], 
    onChanged: clients.isNotEmpty
        ? onChanged
        : null, 
  );
}

Widget FournisseurDropdown(int? selectedFournisseur, String text,
    List<Fournisseur> fournisseurs, Function(int?) onChanged) {
  return DropdownButtonFormField<int>(
    value: selectedFournisseur,
    decoration: InputDecoration(labelText: text),
    items: fournisseurs.isNotEmpty
        ? fournisseurs.map((Fournisseur) {
            return DropdownMenuItem<int>(
              value: Fournisseur.fournisseurId,
              child: Text(Fournisseur.nom),
            );
          }).toList()
        : [], 
    onChanged: fournisseurs.isNotEmpty
        ? onChanged
        : null, 
  );
}

//DropDownClient
Widget produitDropdown(int? selectedProduit, String text,
    List<Produit> produits, Function(int?) onChanged) {
  return DropdownButtonFormField<int>(
    value: selectedProduit,
    decoration: InputDecoration(labelText: text),
    items: produits.isNotEmpty
        ? produits.map((produit) {
            return DropdownMenuItem<int>(
              value: produit.produitId,
              child: Text(produit.nomProduit),
            );
          }).toList()
        : [],
    onChanged: produits.isNotEmpty
        ? onChanged
        : null, 
  );
}

//DropDownStatut
Widget statutDropdown(
    String? selectedStatut, Function(String?) onChanged) {
  List<String> statuts = ['Non Payée', 'Payée', 'En Cours'];

  return DropdownButtonFormField<String>(
    value: selectedStatut,
    decoration: InputDecoration(labelText: 'Statut'),
    items: statuts.map((String statut) {
      return DropdownMenuItem<String>(
        value: statut,
        child: Text(statut),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

Widget textQuantity(TextEditingController controller, VoidCallback calculateSousTotal, Function(String) updateQuantity) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(labelText: 'Quantité'),
    keyboardType: TextInputType.number,
    onChanged: (value) {
      updateQuantity(value);
      calculateSousTotal();
    },
  );
}

Widget customElevatedButton({
  required bool isEnabled,
  required VoidCallback? onPressed,
  required String buttonText,
}) {
  return ElevatedButton(
    onPressed: isEnabled ? onPressed : null,
    child: Text(buttonText),
  );
}


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
      } catch (error) {
        print("Erreur lors de la récupération des factures du client : $error");
        _showError(context, "Erreur lors de la récupération des factures du client");
      }
    } else {
      print("Client non trouvé pour le compte : ${compte.nomCompte}");
      _showError(context, "Client non trouvé");
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
      } catch (error) {
        print("Erreur lors de la récupération des factures du fournisseur : $error");
        _showError(context, "Erreur lors de la récupération des factures du fournisseur");
      }
    } else {
      print("Fournisseur non trouvé pour le compte : ${compte.nomCompte}");
      _showError(context, "Fournisseur non trouvé");
    }
  } else {
    print("Type de compte non reconnu : ${compte.typeCompte}");
  }
}

void _showError(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Erreur"),
      content: Text(message),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop(); // Fermer le dialogue
          },
        ),
      ],
    ),
  );
}

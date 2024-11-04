import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/factureClientComptePage.dart';
import 'package:my_first_app/Pages/factureFournisseurComptePage.dart';
import 'package:my_first_app/Service/factureFournisseurService.dart';
import 'package:my_first_app/Service/factureService.dart';
import 'package:my_first_app/Widget/modalesWidgets.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/compteModel.dart';
import 'package:my_first_app/models/factureFournisseurModel.dart';
import 'package:my_first_app/models/factureModel.dart';
import 'package:my_first_app/models/fournisseursModel.dart';
import 'package:my_first_app/models/produitModel.dart';

//Formulaires
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

Widget datePickerFull(TextEditingController controller, BuildContext context,
  String labelText, String fieldName,Future <void> Function(BuildContext, TextEditingController, String) selectDate) {
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
      selectDate(context, controller, fieldName);
    },
  );
}

Widget datePickerFullAdd(TextEditingController controller, BuildContext context,
  String labelText,Future <void> Function(BuildContext, TextEditingController) selectDateAdd) {
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
      selectDateAdd(context, controller);
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

//Spécifiques réutilisables
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
        showError(context, "Erreur lors de la récupération des factures du client");
      }
    } else {
      print("Client non trouvé pour le compte : ${compte.nomCompte}");
      showError(context, "Client non trouvé");
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
        showError(context, "Erreur lors de la récupération des factures du fournisseur");
      }
    } else {
      print("Fournisseur non trouvé pour le compte : ${compte.nomCompte}");
      showError(context, "Fournisseur non trouvé");
    }
  } else {
    print("Type de compte non reconnu : ${compte.typeCompte}");
  }
}

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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

Widget buildDetailRowRendered(String field, TextEditingController controller, bool isEditing) {
  return isEditing
    ? buildDetailRowEditing(field.capitalize(), controller)
    : buildDetailRow(field.capitalize(), controller.text);
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

Widget buildDetailRowEditing(String label, TextEditingController value) {
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
          child:TextFormField(
                  controller: value,
                  decoration: InputDecoration(
                    // Ajoutez un soulignement au champ pour indiquer l'édition
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                )
        ),
      ],
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:my_first_app/Service/facture_fournisseur_service.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/Widget/modales.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/compte.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/factureFournisseur.dart';
import 'package:my_first_app/models/fournisseurs.dart';
import '../Pages/facture_client_compte_page.dart';
import '../Pages/facture_fournisseur_compte_page.dart';

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





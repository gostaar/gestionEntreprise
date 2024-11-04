import 'package:flutter/material.dart';
import 'package:my_first_app/Widget/customWidgets.dart';
import 'package:my_first_app/models/fournisseursModel.dart';

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
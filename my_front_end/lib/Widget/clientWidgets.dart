import 'package:flutter/material.dart';
import 'package:my_first_app/Widget/customWidgets.dart';
import 'package:my_first_app/Widget/factureWidgets.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/factureModel.dart';

Widget clientDropdown(int? selectedClient, String text, List<Client> clients, Function(int?) onChanged) {
  return DropdownButtonFormField<int>(
    value: selectedClient, // Utilise selectedClient comme valeur par défaut
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
        ? (newValue) {
            print("Client sélectionné : $newValue"); // Affiche le nouveau client sélectionné
            onChanged(newValue); // Appelle la fonction onChanged passée en paramètre
          }
        : null,
  );
}

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
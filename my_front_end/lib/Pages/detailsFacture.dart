import 'package:flutter/material.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/ligne_facture.dart';
import 'package:my_first_app/Service/client_service.dart'; // Assurez-vous d'avoir ce service pour récupérer les données

// Page de Détails de la Facture
class FactureDetailPage extends StatelessWidget {
  final Facture facture;
  final List<LigneFacture> lignesFacture; // Ajout de lignesFacture

  FactureDetailPage({
    required this.facture,
    required this.lignesFacture,
    required Client client,
  });

  Future<Client?> _fetchClient(int clientId) async {
    // Remplacez ceci par votre logique pour récupérer le client à partir de son ID
    return await ClientService.getClientById(clientId);
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Non spécifiée';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Facture #${facture.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Client?>(
          future: _fetchClient(facture.clientId), // Récupération du client
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Erreur lors de la récupération du client'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Client non trouvé'));
            }

            final Client client = snapshot.data!;

            return ListView(
              children: [
                // Informations du Client
                Text('Client: ${client.nom} ${client.prenom}',
                    style: TextStyle(fontSize: 20)),
                Text('Email: ${client.email}', style: TextStyle(fontSize: 16)),
                Text('Téléphone: ${client.telephone}',
                    style: TextStyle(fontSize: 16)),
                Text(
                    'Adresse: ${client.adresse}, ${client.ville}, ${client.codePostal}',
                    style: TextStyle(fontSize: 16)),
                Text('Pays: ${client.pays}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),

                // Informations de la Facture
                Text('Montant Total: ${facture.montantTotal} €',
                    style: TextStyle(fontSize: 20)),
                Text('Statut: ${facture.statut}',
                    style: TextStyle(fontSize: 18)),
                if (facture.dateFacture != null)
                  Text('Date Facture: ${formatDate(facture.dateFacture)}',
                      style: TextStyle(fontSize: 18)),
                if (facture.datePaiement != null)
                  Text('Date Paiement: ${formatDate(facture.datePaiement)}',
                      style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),

                // Détails des Lignes de Facture
                Text('Détails de la facture:',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ...lignesFacture.map((ligne) {
                  return ListTile(
                    title: Text(
                        'Produit ID: ${ligne.produitId}, Quantité: ${ligne.quantite}'),
                    subtitle: Text(
                        'Prix Unitaire: ${ligne.prixUnitaire} €, Sous-total: ${ligne.sousTotal} €'),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}

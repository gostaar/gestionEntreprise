import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/facture_client_page.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/ligne_facture.dart';
import 'package:my_first_app/Widget/Functions.dart';

class ClientDetailPage extends StatelessWidget {
  final Client client; 
  final List<Facture> factures;
  final List<LigneFacture> lignesFacture;
  final factureService = FactureService();
  
  ClientDetailPage({
    required this.client,
    required this.factures,
    required this.lignesFacture,
  });
  

void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

   void _navigateToFacturesPage(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      Navigator.pop(context); 
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FactureClientDetailPage(
            client: client,
          ),
        ),
      );
    } catch (error) {
      Navigator.pop(context);
      _showError(context, 'Erreur lors de la récupération des factures: $error');
    }
  }

  void _showClientDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fiche de ${client.nom}'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Nom: ${client.nom}'),
              Text('Email: ${client.email}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fiche de ${client.nom}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                ElevatedButton(
                  onPressed: () => _showClientDetails(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), 
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  child: Text('Détails'),
                ),
                SizedBox(height: 16), 
                ElevatedButton(
                  onPressed: () => _navigateToFacturesPage(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), 
                    textStyle: TextStyle(fontSize: 20), 
                  ),
                  child: Text('Factures'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  


}

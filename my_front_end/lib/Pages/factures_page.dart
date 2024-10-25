import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/Forms/AddFactureForm.dart';
import 'package:my_first_app/Pages/detailsFacture.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/ligne_facture.dart';
import 'package:my_first_app/constants.dart';

class FacturesPage extends StatefulWidget {
  @override
  _FacturesPageState createState() => _FacturesPageState();
}

class _FacturesPageState extends State<FacturesPage> {
  //variables
  List<Facture> _factures = [];
  Map<int, Client> clients = {};

  //déclaration de fonctions Fututres
  Future<void> _fetchFactures() async {
  try {
    final response = await http.get(Uri.parse('$apiUrl/factures'));
    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      // Vérifiez si la réponse est une liste
      if (jsonResponse is List) {

        List<Facture> factures = jsonResponse.map((json) {
          return Facture.fromJson(json);
        }).toList();

        for (var facture in factures) {
          if (!clients.containsKey(facture.clientId)) {
            final client = await _getClient(facture.clientId);
            clients[facture.clientId] = client; // Stockez le client dans le Map
          }
        }

        setState(() {
          _factures = factures;
        });
      } else {
        print('Erreur : la réponse n\'est pas une liste.');
      }
    } else {
      print('Erreur lors de la récupération des factures : statut ${response.statusCode}');
      print('Contenu de la réponse : ${response.body}');
      throw Exception('Échec de la récupération des factures');
    }
  } catch (error) {
    print('Erreur lors de la récupération des factures depuis factures_page : $error');
  }
}


  Future<dynamic> _getData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
print(response);
      // Vérifiez si la requête a réussi
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Décodez la réponse JSON
      } else {
        throw Exception(
            'Erreur lors de la récupération des données: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des données: $e');
    }
  }

  Future<List<LigneFacture>> _getLignesFacture(int factureId) async {
    final response = await _getData(
        '$apiUrl/lignes_facture/$factureId'); // Modifiez l'URL si nécessaire

    if (response != null) {
      return (response as List)
          .map((ligne) => LigneFacture.fromJson(ligne as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erreur lors de la récupération des lignes de facture');
    }
  }

  Future<Client> _getClient(int clientId) async {
    final response = await http.get(Uri.parse('$apiUrl/clients/$clientId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Client.fromJson(json);
    } else {
      throw Exception('Échec de la récupération du client');
    }
  }

  //déclaration de fonction
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToDetailPage(BuildContext context, Facture facture) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Récupérer les lignes de facture associées à la facture (triées par `facture.id`)
      final lignesFactureData = await _getLignesFacture(facture.id);

      // Récupérer le client associé à la facture (en utilisant `facture.clientId`)
      final client = await _getClient(facture.clientId);

      // Créer une liste de lignes de facture à partir des données récupérées
      List<LigneFacture> lignesFacture =
          lignesFactureData.map<LigneFacture>((ligne) {
        return LigneFacture.fromJson(ligne as Map<String, dynamic>);
      }).toList();

      Navigator.pop(context); // Fermer le dialog de chargement

      // Naviguer vers la page de détails de la facture avec les informations du client et des lignes de facture
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FactureDetailPage(
            facture: facture, // Facture originale (sans client ou lignes)
            client: client, // Passer le client récupéré
            lignesFacture:
                lignesFacture, // Passer les lignes de facture récupérées
          ),
        ),
      );
    } catch (error) {
      Navigator.pop(context); // Fermer le dialog de chargement
      _showError('Erreur lors de la récupération des données');
    }
  }

  void _openAddFactureForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddFactureForm(),
      ),
    ).then((_) =>
        _fetchFactures()); // Récupérer les factures à nouveau après l'ajout
  }

  //méthode d'initialisation
  @override
  void initState() {
    super.initState();
    _fetchFactures();
  }

  //affichage principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Factures')),
      body: _factures.isEmpty
          ? Center(
              child: Text('Aucune facture disponible', style: TextStyle(fontSize: 24)))
          : ListView.builder(
              itemCount: _factures.length,
              itemBuilder: (context, index) {
                final facture = _factures[index];
                return ListTile(
                  title: Text('Numéro de Facture: ${facture.id}'),
                  subtitle: Text('Statut: ${facture.statut}'),
                  onTap: () => _navigateToDetailPage(context, facture),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddFactureForm(
            context), // Ouvre le modal pour ajouter une facture
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

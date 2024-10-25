import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour le décodage JSON
import 'package:my_first_app/Forms/AddProduitForm.dart';
import 'package:my_first_app/constants.dart';

class ProduitsPage extends StatefulWidget {
  @override
  _ProduitsPageState createState() => _ProduitsPageState();
}

class _ProduitsPageState extends State<ProduitsPage> {
  List Produits = []; // Liste qui contiendra les Produits récupérés

  @override
  void initState() {
    super.initState();
    fetchProduits(); // Appel à la fonction qui récupère les Produits à l'initialisation
  }

  // Fonction pour récupérer les Produits depuis l'API
  Future<void> fetchProduits() async {
    final response = await http.get(Uri.parse('$apiUrl/produits'));

    if (response.statusCode == 200) {
      setState(() {
        Produits = json.decode(
            response.body); // Stockage des données dans la liste 'Produits'
      });
    } else {
      // En cas d'erreur, on lève une exception
      throw Exception('Erreur lors du chargement des Produits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produits'),
      ),
      body: Produits.isEmpty
          ? Center(
              child: Text('Aucun produit disponible'),
            )
          : ListView.builder(
              itemCount: Produits.length, // Nombre de Produits récupérés
              itemBuilder: (context, index) {
                final Produit = Produits[index];
                return ListTile(
                  title: Text('Nom : ${Produit['nom_produit']}'),
                  subtitle: Text('Description : ${Produit['description']}'),
                  onTap: () {
                    // Action lors du clic sur une facture
                    // Vous pouvez ajouter une page de détails ou d'édition ici
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProduitModal(
              context); // Ouvre le modal pour ajouter un Produit
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Fonction pour afficher le formulaire d'ajout de Produit
  void _showAddProduitModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              AddProduitForm(), // Appelle un widget contenant le formulaire d'ajout
        );
      },
    );
  }
}

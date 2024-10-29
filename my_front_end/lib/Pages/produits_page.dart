import 'package:flutter/material.dart';
import 'package:my_first_app/Forms/AddProduitForm.dart';
import 'package:my_first_app/models/produit.dart';
import 'package:my_first_app/Service/produit_service.dart';

class ProduitsPage extends StatefulWidget {
  @override
  _ProduitsPageState createState() => _ProduitsPageState();
}

class _ProduitsPageState extends State<ProduitsPage> {
  List<Produit> produits = []; 
  final produitService = ProduitService();

  @override
  void initState() {
    super.initState();
    _fetchProduits(); 
  }

  Future<void> _fetchProduits() async {
    try {
      final fetchedProduits = await produitService.fetchProduits();
      setState(() {
        produits = fetchedProduits;
      });
    } catch (e) {
      print('Erreur lors de la récupération des produits : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produits'),
      ),
      body: produits.isEmpty
          ? Center(
              child: Text('Aucun produit disponible'),
            )
          : ListView.builder(
              itemCount: produits.length, 
              itemBuilder: (context, index) {
                final produit = produits[index];
                return ListTile(
                  title: Text('Nom : ${produit.nomProduit}'),
                  subtitle: Text('Description : ${produit.description}'),
                  onTap: () {
                    // Action lors du clic sur un produit
                    // Vous pouvez ajouter une page de détails ou d'édition ici
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ouvre le modal pour ajouter un Produit
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: AddProduitForm(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

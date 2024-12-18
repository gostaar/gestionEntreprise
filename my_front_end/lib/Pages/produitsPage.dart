import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Forms/Add/ProduitForm.dart';
import 'package:my_first_app/models/produitModel.dart';
import 'package:my_first_app/Service/produitService.dart';

class ProduitsPage extends StatefulWidget {
  @override
  _ProduitsPageState createState() => _ProduitsPageState();
}

class _ProduitsPageState extends State<ProduitsPage> {
  List<Produit> produits = []; 
  List<Produit> _filteredProduits = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProduits(); 
    _searchController.addListener(_filterProduits);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProduits() async {
    try {
      final fetchedProduits = await ProduitService.fetchProduits();
      if(mounted){setState(() {
        produits = fetchedProduits;
        _filteredProduits = produits; // Initialise la liste filtrée avec tous les produits
      });}
    } catch (e) {
      throw Exception('Erreur lors de la récupération des produits : $e');
    }
  }

void _filterProduits() {
  final query = _searchController.text;
  if (query.isNotEmpty) {
    final priceQuery = double.tryParse(query); // Essaie de convertir le texte en double
    setState(() {
      _filteredProduits = produits.where((produit) {
        // Vérifie si le nom du produit contient la recherche ou si le prix contient la recherche
        return produit.nomProduit.contains(query) || 
               (priceQuery != null && produit.prix.toString().contains(query));
      }).toList();
    });
  } else {
    setState(() {
      _filteredProduits = produits;
    });
  }
}

  Future<void> _refreshProduits() async {
    try {
      final _produits = await ProduitService.fetchProduits();
      if(mounted){setState(() {
        produits = _produits;
        _filteredProduits = produits; // Réinitialise la liste filtrée
      });}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la récupération des produits: $e')),);
    }
  }

  void _openAddProduitForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddProduitForm(createProduitFunction: ProduitService.createProduit,),
      ),
    ).then((_) => _refreshProduits());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produits'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nom / Prix',
                hintStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _filteredProduits.isEmpty
          ? Center(
              child: Text('Aucun produit disponible'),
            )
          : ListView.builder(
              itemCount: _filteredProduits.length, // Utilise la liste filtrée
              itemBuilder: (context, index) {
                final produit = _filteredProduits[index];
                String formattedPrice = NumberFormat.simpleCurrency(locale: 'fr_FR').format(produit.prix);
                return ListTile(
                  title: Text('Nom : ${produit.nomProduit}'),
                  subtitle: Text('Description : ${produit.description}\nPrix : $formattedPrice'),
                  onTap: () {
                    // Action lors du clic sur un produit
                    // Vous pouvez ajouter une page de détails ou d'édition ici
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddProduitForm(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

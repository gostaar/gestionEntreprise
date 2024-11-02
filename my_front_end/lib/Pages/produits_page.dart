import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Forms/AddProduitForm.dart';
import 'package:my_first_app/Widget/Functions.dart';
import 'package:my_first_app/models/produit.dart';
import 'package:my_first_app/Service/produit_service.dart';

class ProduitsPage extends StatefulWidget {
  @override
  _ProduitsPageState createState() => _ProduitsPageState();
}

class _ProduitsPageState extends State<ProduitsPage> {
  List<Produit> produits = []; 
  List<Produit> _filteredProduits = [];
  final TextEditingController _searchController = TextEditingController();
  final produitService = ProduitService();

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
      final fetchedProduits = await produitService.fetchProduits();
      setState(() {
        produits = fetchedProduits;
        _filteredProduits = produits; // Initialise la liste filtrée avec tous les produits
      });
    } catch (e) {
      print('Erreur lors de la récupération des produits : $e');
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
      final _produits = await produitService.fetchProduits();
      setState(() {
        produits = _produits;
        _filteredProduits = produits; // Réinitialise la liste filtrée
      });
    } catch (error) {
      _showError(context, 'Erreur lors de la récupération des produits: $error');
    }
  }

  void _openAddProduitForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddProduitForm(),
      ),
    ).then((_) => _refreshProduits());
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
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

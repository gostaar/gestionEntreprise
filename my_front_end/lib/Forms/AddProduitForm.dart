import 'dart:convert'; // Pour utiliser jsonEncode
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AddProduitForm extends StatefulWidget {
  @override
  _AddProduitFormState createState() => _AddProduitFormState();
}

class _AddProduitFormState extends State<AddProduitForm> {
  // Controllers pour récupérer les valeurs saisies
  final TextEditingController _nom_produitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _quantite_stockController =
      TextEditingController();

  // Variable pour la catégorie
  String? _categorie; // Pour stocker la catégorie sélectionnée

  // Liste des catégories
  final List<String> _categories = [
    'Service',
    'Produit',
    'Immobilier',
    'Location'
  ];

  // Fonction pour gérer l'ajout du Produit
  void _addProduit() async {
    final String nom_produit = _nom_produitController.text;
    final String description = _descriptionController.text;
    final String prix = _prixController.text;
    final String quantite_stock = _quantite_stockController.text;

    // Vérification de la validité des champs
    if (_categorie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner une catégorie')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(
          'https://efe9-2a01-cb1c-d1f-ea00-8120-15cc-b628-c6c3.ngrok-free.app/produits'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom_produit': nom_produit,
        'description': description,
        'prix': prix,
        'quantite_en_stock': quantite_stock,
        'categorie':
            _categorie, // Utilisez la valeur de la catégorie sélectionnée
      }),
    );

    if (response.statusCode == 200) {
      // Si l'ajout est réussi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produit ajouté avec succès')),
      );
    } else {
      // Si l'ajout échoue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout du Produit')),
      );
    }

    Navigator.pop(context, true); // Fermer la fenêtre après l'ajout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Ajout d'un produit")),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nom_produitController,
                  decoration: InputDecoration(labelText: 'Nom du Produit'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _prixController,
                  decoration: InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true), // Permettre les décimales
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d+\.?\d*')), // Valider le format numérique avec décimales
                  ],
                ),
                TextField(
                  controller: _quantite_stockController,
                  decoration: InputDecoration(labelText: 'Quantité en stock'),
                  keyboardType: TextInputType.number, // Entier uniquement
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // N'autoriser que les chiffres
                  ],
                ),
                // Champ pour la catégorie
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Catégorie'),
                  value: _categorie, // La valeur actuelle
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _categorie =
                          newValue; // Met à jour la catégorie sélectionnée
                    });
                  },
                  validator: (value) => value == null
                      ? 'Veuillez sélectionner une catégorie'
                      : null,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addProduit,
                  child: Text('Ajouter'),
                ),
              ],
            ),
          ),
        ));
  }
}

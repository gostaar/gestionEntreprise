import 'dart:convert'; // Pour utiliser jsonEncode
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/Service/produit_service.dart';
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/produit.dart';

class AddProduitForm extends StatefulWidget {
  @override
  _AddProduitFormState createState() => _AddProduitFormState();
}

class _AddProduitFormState extends State<AddProduitForm> {

  final produitService = ProduitService();
  final TextEditingController nom_produitController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController quantite_en_stockController = TextEditingController();
  String? categorie;
  final TextEditingController dateAjoutController = TextEditingController(text: DateTime.now().toLocal().toString().split(' ')[0],);
  final List<String> _categories = [
    'Service',
    'Produit',
    'Immobilier',
    'Location'
  ];

  void _addProduit() async {
    try {
      if (nom_produitController.text.isEmpty || 
        descriptionController.text.isEmpty || 
        _prixController.text.isEmpty || 
        quantite_en_stockController.text.isEmpty || 
        categorie == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tous les champs doivent être remplis')),
          );
          return; 
        }

      double finalPrix = double.tryParse(_prixController.text)?? 0.0;
      int finalQuantite = int.tryParse(quantite_en_stockController.text)?? 0;

      final newProduit = Produit(
        produitId: 0,
        nomProduit: nom_produitController.text,
        description: descriptionController.text,
        prix: finalPrix,
        quantiteEnStock: finalQuantite,
        categorie: categorie ?? 'Non spécifiée',
      );

      await http.post(
        Uri.parse('$apiUrl/produits'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newProduit.toJson()),
      );

      Navigator.pop(context, true);
    } catch(e) {
      print ("Erreur lors de l'ajout du produit, $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajout d'un produit")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                  controller: nom_produitController,
                  decoration: InputDecoration(labelText: 'Nom du produit'),
              ),
              TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description')
              ),
              TextField(
                  controller: _prixController,
                  decoration: InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), 
                  ],
              ),
              TextField(
                  controller: quantite_en_stockController,
                  decoration: InputDecoration(labelText: 'Quantité en stock'),
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), 
                  ],
              ),
              TextField(
                controller: dateAjoutController,
                decoration: InputDecoration(labelText: 'Date d\'ajout'),
                readOnly: true, 
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Catégorie'),
                value: categorie, // La valeur actuelle
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    categorie = newValue; 
                  });
                },
                validator: (value) => value == null ? 'Veuillez sélectionner une catégorie' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addProduit,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
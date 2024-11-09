import 'package:flutter/material.dart';
import 'package:my_first_app/Widget/Produit/addProduitsWidgets.dart';

class AddProduitForm extends StatefulWidget {
   final Future<void> Function({
    required int produitId,
    required String nomProduit,
    required String description,
    required double prix,
    required int quantiteEnStock,
    required String categorie,
  }) createProduitFunction;

  const AddProduitForm({Key? key, required this.createProduitFunction}) : super(key: key);


  @override
  _AddProduitFormState createState() => _AddProduitFormState();
}

class _AddProduitFormState extends State<AddProduitForm> {

  //final produitService = ProduitService();
  final Map <String, TextEditingController> _controllers = {
    'nom': TextEditingController(),
    'description': TextEditingController(),
    'prix': TextEditingController(),
    'quantiteStock': TextEditingController(),
  };
  String? _selectedCategorie;
  //final TextEditingController _controllers['nom']! = TextEditingController();
  //final TextEditingController _controllers['description']! = TextEditingController();
  //final TextEditingController _controllers['prix']! = TextEditingController();
  //final TextEditingController _controllers['quantiteStock']! = TextEditingController();
  //
  //final TextEditingController dateAjoutController = TextEditingController(text: DateTime.now().toLocal().toString().split(' ')[0],);


  void _createProduit() async {
    try{
      await widget.createProduitFunction(
        produitId: 0,
        nomProduit: _controllers['nom']!.text,
        description: _controllers['description']!.text,
        prix: double.tryParse(_controllers['prix']!.text)??0.0,
        quantiteEnStock: int.tryParse(_controllers['quantiteStock']!.text)??0,
        categorie: _selectedCategorie!,
      );
      Navigator.pop(context, true);
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout du produit: $e')),);
    }
  }

  void _updateQuantity(String value) { setState(() { _controllers['quantiteStock']?.text = value.isNotEmpty ? int.tryParse(value)?.toString() ?? '' : '';  });}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajout d'un produit")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              addProduit(
                _controllers, 
                _updateQuantity, 
                _createProduit 
              ),
            ],           
          ),
        ),
      ),
    );
  }
}
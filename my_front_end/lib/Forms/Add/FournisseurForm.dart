import 'package:flutter/material.dart';
import 'package:my_first_app/Service/fournisseurService.dart';
import 'package:my_first_app/Widget/Fournisseurs/AddFournisseursWidgets.dart';

class AddFournisseurForm extends StatefulWidget {
 final Future<void> Function({
    required int fournisseurId,
    required String nom,
   required String? prenom,
    required String? email,
    required String? telephone,
    required String? adresse,
    required String? ville,
    required String? codePostal,
    required String? pays,
    required String? numeroTva,
  }) createFournisseurFunction;

  const AddFournisseurForm({Key? key, required this.createFournisseurFunction}) : super(key: key);

  @override
  _AddFournisseurFormState createState() => _AddFournisseurFormState();
}

class _AddFournisseurFormState extends State<AddFournisseurForm> {

  final List<TextEditingController> _controllers = List.generate(
    9,
    (_) => TextEditingController(),
  );

  final List<String> _labels = [
    'Nom',
    'Prénom',
    'Email',
    'Téléphone',
    'Adresse',
    'Ville',
    'Code Postal',
    'Pays',
    'Numéro de TVA',
  ];

  Future<void> _createFournisseur() async {
    try {
      final lastFournisseurId = await FournisseurService.getLastFournisseurId() +1;
      await widget.createFournisseurFunction(
        fournisseurId: lastFournisseurId, 
        nom: _controllers[0].text,
        prenom: _controllers[1].text,
        email: _controllers[2].text,
        telephone: _controllers[3].text,
        adresse: _controllers[4].text,
        ville: _controllers[5].text,
        codePostal: _controllers[6].text,
        pays: _controllers[7].text,
        numeroTva: _controllers[8].text,
      );
      Navigator.pop(context, true);
    } catch (e){ 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout du fournisseur: $e')),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajout d\'un Fournisseur')),
      body: SingleChildScrollView(
        child: Padding(
          padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: <Widget> [
              addFournisseurWidget(
                _labels,
                _controllers,
                _createFournisseur,
              )
            ],
          ),
        ),
      ),
    );
  }
}

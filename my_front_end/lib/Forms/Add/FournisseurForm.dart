import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/fournisseurs.dart';

class AddFournisseurForm extends StatefulWidget {
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
    'Numéro de TVA', // Ajout du label pour la TVA
  ];

  Future<void> _addFournisseur() async {
    try {
      final lastFournisseurId = await _getLastFournisseurId();
      final newFournisseurId = lastFournisseurId + 1;

      final newFournisseur = Fournisseur(
        fournisseurId: newFournisseurId, // Assurez-vous de convertir en chaîne si nécessaire
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
      await http.post(
        Uri.parse('$apiUrl/fournisseurs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newFournisseur.toJson()),
      );

      Navigator.pop(context, true);

    } catch (e){ 
      print('Erreur lors de l\'ajout du fournisseur ,$e');
    }
  }

 Future<int> _getLastFournisseurId() async {
  final response = await http.get(Uri.parse('$apiUrl/fournisseurs'));

  if (response.statusCode == 200) {
    final List<dynamic> fournisseurs = jsonDecode(response.body);

    if (fournisseurs.isNotEmpty) {
      // Filtre les fournisseurs ayant un clientId non nul et de type int
      final validFournisseurIds = fournisseurs
          .map((fournisseur) => fournisseur['fournisseurId'])
          .whereType<int>(); // Exclut les valeurs nulles et non int

      if (validFournisseurIds.isNotEmpty) {
        // Trouve l'ID maximum parmi les IDs valides
        return validFournisseurIds.reduce((a, b) => a > b ? a : b);
      }
    }
  }

  return 0; // Retourne 0 si aucun client n'est trouvé ou si aucun ID valide n'est trouvé
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ..._labels.map((label) => TextField(
                    controller: _controllers[_labels.indexOf(label)],
                    decoration: InputDecoration(labelText: label),
                  )),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addFournisseur,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

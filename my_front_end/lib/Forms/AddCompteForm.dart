import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/constants.dart';

class AddCompteForm extends StatefulWidget {
  @override
  _AddCompteFormState createState() => _AddCompteFormState();
}

class _AddCompteFormState extends State<AddCompteForm> {
  final TextEditingController _nom_compteController = TextEditingController();
  final TextEditingController _soldeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false; 
  String? _selectedTypeCompte;
  List<String> _typesDeCompte = ['Actif', 'Passif', 'Revenu', 'Dépense'];

  void _addCompte() async {
    if (_formKey.currentState!.validate()) {
      final String nom_compte = _nom_compteController.text.trim();
      final String type_compte = _selectedTypeCompte!;
      final String solde = _soldeController.text.trim();

      setState(() {
        _isLoading = true; 
      });

      final response = await http.post(
        Uri.parse('$apiUrl/comptes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nom_compte': nom_compte,
          'type_compte': type_compte,
          'solde': solde,
        }),
      );

      setState(() {
        _isLoading = false; 
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compte ajouté avec succès')),
        );
        Navigator.pop(context); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erreur lors de l\'ajout du compte : ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey, 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nom_compteController,
                decoration: InputDecoration(labelText: 'Nom du compte'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de compte'; 
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedTypeCompte,
                decoration: InputDecoration(labelText: 'Type du compte'),
                items: _typesDeCompte.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTypeCompte = newValue;
                  });
                },
                validator: (value) => value == null
                    ? 'Veuillez sélectionner un type de compte'
                    : null,
              ),
              TextFormField(
                controller: _soldeController,
                decoration: InputDecoration(labelText: 'Solde'),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true), 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un solde'; 
                  }
                  if (double.tryParse(value) == null) {
                    return 'Le solde n\'a pas un format valide'; 
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _addCompte, 
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors
                            .white) 
                    : Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

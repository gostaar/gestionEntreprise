import 'package:flutter/material.dart';
import 'package:my_first_app/constants.dart';

Widget addCompteWidget(
  Map<String, TextEditingController> controllers,
  Map<String, double> variables,
  String? selectedType,
  bool isLoading,
  Function() updateSolde,
  Function() addCompte,
  Function(String?) onChangedType,
  Function(String) onChangedSolde,
){
  final types = ['Actif', 'Passif', 'Revenu', 'Dépense'];
  final _formKey = GlobalKey<FormState>();
  return Form(
    key: _formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextFormField(
          controller: controllers['nom'],
          decoration: InputDecoration(labelText: 'Nom du compte'),
          keyboardType: TextInputType.text,
          validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un nom de compte' : null,
        ),
        DropdownButtonFormField<String>(
          value: selectedType,
          decoration: InputDecoration(labelText: 'Type du compte'),
          items: types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
          onChanged: onChangedType,
          validator: (value) => value == null ? 'Veuillez sélectionner un type de compte' : null,
        ),
        TextFormField(
          controller: controllers['solde'],
          decoration: InputDecoration(labelText: 'Solde'),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          validator:  (value)  {
            if (value == null || value.isEmpty) return 'Veuillez entrer un solde';
            if (double.tryParse(value) == null) return 'Le solde n\'a pas un format valide';
            return null;},
          onChanged: onChangedSolde,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : ()  {
            addCompte;
            updateSolde();
          },
          child: isLoading ? CircularProgressIndicator(color: customColors['white']) : Text('Ajouter'),
        ),
      ],
    )
  );
}
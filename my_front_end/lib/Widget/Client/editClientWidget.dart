import 'package:flutter/material.dart';
import 'package:my_first_app/constants.dart';

Widget editClientWidget(
  Map<String, String> formData,
  Function() updateClient,
){
  return Column(
    children: <Widget>[
      for(String field in formData.keys)
        TextFormField(
          initialValue: formData[field],
          decoration: InputDecoration(
            labelText: field[0].toUpperCase() + field.substring(1),
          ),
          onSaved: (value) {
            formData[field] = value ?? '';
          },
          validator: (value) {
            if (field == 'nom' && (value == null || value.isEmpty)){
              return 'Veuillez entrer un nom';
            }
            return null;
          }
        ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: updateClient,
        child: Text('Enregistrer'),
        style: ElevatedButton.styleFrom(
          foregroundColor: customColors['white'],
          backgroundColor: customColors['blue'], // Couleur du bouton
        ),
      )
    ],
  );
}
import 'package:flutter/material.dart';

Widget addClientWidget(
  List<String> labels,
  List<TextEditingController> controllers,
  Function() addClient,
){
  final _formKey = GlobalKey<FormState>(); 
  return Form(
    key: _formKey, 
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ...labels.map((label) => 
        TextFormField(
          controller: controllers[labels.indexOf(label)],
          decoration: InputDecoration(labelText: label),
          validator: (value) => value == null || value.isEmpty ? 'Le champs ne peut pas être vide' : null,
        )),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: addClient,
          child: Text('Ajouter'),
        ),
      ],
    )
  );
}


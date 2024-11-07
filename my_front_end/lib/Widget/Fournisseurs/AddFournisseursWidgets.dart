import 'package:flutter/material.dart';

Widget addFournisseurWidget(
  List<String> labels,
  List<TextEditingController> controller,
  Function() addFournisseur,
) {
  final _formKey = GlobalKey<FormState>();
  return Form(
    key: _formKey,
    child:Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ...labels.map((label) => TextFormField(
          controller: controller[labels.indexOf(label)],
          decoration: InputDecoration(labelText: label), 
          validator:(value) => value == null || value.isEmpty ? 'Le champs est requis' : null, 
        )),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: addFournisseur, 
          child: Text('Ajouter')
        ),
      ]
    )
  );
}
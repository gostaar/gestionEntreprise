import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Widget addProduit(
  Map<String, TextEditingController> controllers, 
  Function(String) updateQuantity, 
  Function() addProduitForm
){
  final _formKey = GlobalKey<FormState>();
  return Form(
    key: _formKey,
    child: Column(
      children: <Widget>[
      TextFormField(
        controller: controllers['nom'],
        decoration: InputDecoration(labelText: 'Nom du produit'),
        validator:(value) => value == null ? 'Le nom du produit est requis' : null,
      ),
      TextFormField(
        controller: controllers['description'],
        decoration: InputDecoration(labelText: 'Description'),
        validator:(value) => value == null ? 'La description du produit est requise' : null,
      ),
      TextFormField(
        controller: controllers['quantiteStock'],
        decoration: InputDecoration(labelText: 'Quantité en stock'),
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), 
        ],
        onChanged: (value) {updateQuantity(value);},
        validator:(value) => value == null ? 'La quantité est requise' : null,
      ),
      Text('Date d\'ajout:  ${DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()}'),
      //Text('Prix : $prix'),
      SizedBox(height: 16),
      ElevatedButton(onPressed: addProduitForm, child: Text('Ajouter'))
    ])
  );
} 




import 'package:flutter/material.dart';
import 'package:my_first_app/Widget/customWidget/selectDateWidget.dart';
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/produitModel.dart';

Widget addFactureWidget(

  BuildContext context,
  Map <String, TextEditingController> controllers,
  //Future <void> Function(BuildContext, TextEditingController) selectDate,
  Function() addClient,
  Function() addProduit,
  Function() addFacture,
  Function() calculateSousTotal, 
  Function(String) updateQuantity,
  Function(int?) onChangedClient,
  Function(String?) onChangedStatut,
  Function(int?) onChangedProduit,
  List<Client> client,
  List<Produit> produit,
  int? selectedClient,
  String? selectedStatut,
  int? selectedProduit,
  double? prixUnitaire,
  double? sousTotal,
  int? quantity,
  bool isEnabled,
){
  List<String> statuts = ['Non Payée', 'Payée', 'En Cours'];
  final _formKey = GlobalKey<FormState>();
  return Form(
    key: _formKey,
    child: Column(
      children: <Widget>[
        TextFormField(
          controller: controllers['dateFacture']!,
          decoration: InputDecoration(
            labelText: 'Date de Facture',
            prefixIcon: Icon(Icons.calendar_today),
            filled: true,
            fillColor: customColors['borderGrey'],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: customColors['grey']!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: customColors['blue']!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: customColors['grey']!),
            ),
          ),
          readOnly: true,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            selectDate(context, controllers['dateFacture']!);
          },
          validator: (value) => value == null || value.isEmpty ? 'La date de facture est requise' : null,
        ),
        DropdownButtonFormField<int>(
          value: selectedClient, // Utilise selectedClient comme valeur par défaut
          decoration: InputDecoration(labelText: 'Client'),
          items: client.isNotEmpty
              ? client.map((client) {
                  return DropdownMenuItem<int>(
                    value: client.clientId,
                    child: Text(client.nom),
                  );
                }).toList()
              : [],
          onChanged: client.isNotEmpty
              ? (newValue) {
                  onChangedClient(newValue); // Appelle la fonction onChanged passée en paramètre
                  throw Exception("Client sélectionné : $newValue"); // Affiche le nouveau client sélectionné
                }
              : null,
          validator: (value) => value == null ? 'Le client est requis' : null,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              addClient();
            },
            child: Text(
              "Créer un client",
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
        client.isEmpty
          ? Text(
              'Aucun client disponible. Veuillez ajouter un client.',
              style: TextStyle(color: customColors['red']), 
            )
          : SizedBox.shrink(),
        TextFormField(
          controller: controllers['datePaiement']!,
          decoration: InputDecoration(
            labelText: 'Date de paiement',
            prefixIcon: Icon(Icons.calendar_today),
            filled: true,
            fillColor: customColors['borderGrey'],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: customColors['grey']!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: customColors['blue']!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: customColors['grey']!),
            ),
          ),
          readOnly: true,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            selectDate(context, controllers['datePaiement']!);
          },
          validator: (value) => value == null || value.isEmpty ? 'La date de paiement est requise' : null ,
        ),
        DropdownButtonFormField<String>(
          value: selectedStatut,
          decoration: InputDecoration(labelText: 'Statut'),
          items: statuts.map((String statut) {
            return DropdownMenuItem<String>(
              value: statut,
              child: Text(statut),
            );
          }).toList(),
          onChanged: onChangedStatut,
          validator: (value) {
            if(value == null){return 'le statut est requis';}
            return null;  
          },
        ),
        DropdownButtonFormField<int>(
          value: selectedProduit,
          decoration: InputDecoration(labelText: 'Produit'),
          items: produit.isNotEmpty
              ? produit.map((produit) {
                  return DropdownMenuItem<int>(
                    value: produit.produitId,
                    child: Text(produit.nomProduit),
                  );
                }).toList()
              : [],
          onChanged: produit.isNotEmpty
              ? onChangedProduit
              : null, 
          validator: (value) => value == null ? 'Le produit est requis' : null,
        ),
        produit.isEmpty
        ? Text(
            'Aucun produit disponible. Veuillez ajouter un produit.',
            style: TextStyle(color: customColors['red']), 
          )
        : SizedBox.shrink(),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              addProduit();
            },
            child: Text(
              'Créer un produit',
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
        TextFormField(
          controller: controllers['quantite']!,
          decoration: InputDecoration(labelText: 'Quantité'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            updateQuantity(value);
            calculateSousTotal();
          },
          validator: (value)  => value == null || value.isEmpty ? 'La quantité est requise' : null,
        ),
        Text('Prix Unitaire: ${prixUnitaire?.toStringAsFixed(2) ?? 'indisponible'}'),
        Text('Sous Total: ${sousTotal?.toStringAsFixed(2) ?? 'Indisponible'}'),
        ElevatedButton(
          onPressed: isEnabled ? addFacture : null,
          child: Text('Ajouter Facture'),
        ),
      ]
    )
  );
}
import 'package:flutter/material.dart';
import 'package:my_first_app/Widget/customWidget/selectDateWidget.dart';
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/produitModel.dart';

Widget editFactureWidget(
  BuildContext context,
  Map<String, TextEditingController> controllers,
  Map<String, String> formData,
  List<Client> clients,
  List<Produit> produits,
  int? selectedProduit,
  double? prixUnitaire,
  double? sousTotal,
  bool isEnabled,
  Function(DateTime?) onChangeDateFacture,
  Function(DateTime?) onChangeDatePaiement,
  Function(int?) onChangedClient,
  Function(String?) onChangedStatut,
  Function(int?) onChangedProduit,
  Function() addClient,
  Function() calculateSousTotal,
  Function(String) updateQuantity,
  Function() addProduit,
  Function() updateFacture,
){
  List<String> statuts = ['Non Payée', 'Payée', 'En Cours'];
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      TextField(
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
        onTap: ()  {
          FocusScope.of(context).requestFocus(FocusNode());
          selectDate(context, controllers['dateFacture']!, onChangeDateFacture);
        },
      ),
      DropdownButtonFormField<int>(
        value: int.parse(formData['cliend_id']!),
        decoration: InputDecoration(labelText: 'Client'),
        items: clients.isNotEmpty
            ? clients.map((client) {
                return DropdownMenuItem<int>(
                  value: client.clientId,
                  child: Text(client.nom),
                );
              }).toList()
            : [],
        onChanged: clients.isNotEmpty
            ? (newValue) {
                onChangedClient(newValue);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Client sélectionné: $newValue')),);
              }
            : null,
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
      clients.isEmpty
        ? Text(
            'Aucun client disponible. Veuillez ajouter un client.',
            style: TextStyle(color: customColors['red']), 
          )
        : SizedBox.shrink(),
      TextField(
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
        onTap: ()  {
          FocusScope.of(context).requestFocus(FocusNode());
          selectDate(context, controllers['datePaiement']!, onChangeDatePaiement);
        },
      ),
      DropdownButtonFormField<String>(
        value: formData['statut'],
        decoration: InputDecoration(labelText: 'Statut'),
        items: statuts.map((String statut) {
          return DropdownMenuItem<String>(
            value: statut,
            child: Text(statut),
          );
        }).toList(),
        onChanged: onChangedStatut,
      ),
      DropdownButtonFormField<int>(
        value: selectedProduit,
        decoration: InputDecoration(labelText: 'Produit'),
        items: produits.map((produit) {
          return DropdownMenuItem<int>(
            value: produit.produitId,
            child: Text(produit.nomProduit),
          );
        }).toList(),
        onChanged: produits.isNotEmpty
          ? onChangedProduit
          : null,
      ),
      produits.isEmpty
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
      TextField(
        controller: controllers['quantite']!,
        decoration: InputDecoration(labelText: 'Quantité'),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          updateQuantity(value);
          calculateSousTotal();
        },
      ),
      Text('Prix Unitaire: ${prixUnitaire?.toStringAsFixed(2) ?? 'indisponible'}'),
      Text('Sous Total: ${sousTotal?.toStringAsFixed(2) ?? 'Indisponible'}'),
      ElevatedButton(
        onPressed: isEnabled ? updateFacture : null,
        child: Text('Enregistrer Facture'),
      ),
    ],
  );
}
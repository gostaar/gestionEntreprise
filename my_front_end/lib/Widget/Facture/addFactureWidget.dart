import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Widget/customWidget/selectDateWidget.dart';
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/produitModel.dart';

Widget createFactureWidget(
  BuildContext context,
  Map <String, TextEditingController> controllers,
  Map <String, int?> selected,
  DateTime? datePaiement,
  Function() createClient,
  Function() createProduit,
  Function() createFacture,
  Function() calculateSousTotal, 
  Function(DateTime?) onChangeDatePaiement,
  Function(int?) updateQuantity,
  Function(int?) onChangedClient,
  Function(String?) onChangedStatut,
  Function(int?) onChangedProduit,
  List<Client> client,
  List<Produit> produit,
  bool isEnabled,
){
  List<String> statuts = ['Non Payée', 'Payée', 'En Cours'];
  TextEditingController dateController = TextEditingController();
  dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  return Form(
    child: Column(
      children: <Widget>[
        //TextFormField(
        //  controller: dateController,
        //  decoration: InputDecoration(
        //    labelText: 'Date de Facture',
        //    prefixIcon: Icon(Icons.calendar_today),
        //    filled: true,
        //    fillColor: customColors['borderGrey'],
        //    border: OutlineInputBorder(
        //      borderRadius: BorderRadius.circular(8.0),
        //      borderSide: BorderSide(color: customColors['grey']!),
        //    ),
        //    focusedBorder: OutlineInputBorder(
        //      borderRadius: BorderRadius.circular(8.0),
        //      borderSide: BorderSide(color: customColors['blue']!),
        //    ),
        //    enabledBorder: OutlineInputBorder(
         //     borderRadius: BorderRadius.circular(8.0),
        //      borderSide: BorderSide(color: customColors['grey']!),
        //    ),
        //  ),
        //  enabled: false,
        //  readOnly: true,
        //  onTap: () {
        //    FocusScope.of(context).requestFocus(FocusNode());
        //    selectDate(context, controllers['dateFacture']!, (pickedDate) {});
        //  },
        //  validator: (value) => value == null || value.isEmpty ? 'La date de facture est requise' : null,
        //),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligne à gauche
          children: [
            Text(
              'Date de facture: ${dateController.text}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left, // Alignement à gauche
            ),
          ],
        ),
        DropdownButtonFormField<int>(
          value: selected['client'], 
          decoration: InputDecoration(labelText: 'Client'),
          items: client.isNotEmpty
              ? client.map((client) {
                  return DropdownMenuItem<int>(
                    value: client.clientId,
                    child: Text(client.nom),
                  );
                }).toList()
              : [],
           onChanged: client.isNotEmpty ? onChangedClient : null,
          validator: (value) => value == null ? 'Le client est requis' : null,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              createClient();
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
          controller: controllers['datePaiement'],
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
            selectDate(context, controllers['datePaiement']!, onChangeDatePaiement);
          },
          validator: (value) => value == null || value.isEmpty ? 'La date de paiement est requise' : null ,
        ),
        DropdownButtonFormField<String>(
          value: null,
          decoration: InputDecoration(labelText: 'Statut'),
          items: statuts.map((String statut) {
            return DropdownMenuItem<String>(
              value: statut,
              child: Text(statut),
            );
          }).toList(),
          onChanged: onChangedStatut,
          validator: (value) => value == null ? 'le statut est requis' : null,
        ),        
        DropdownButtonFormField<int>(
          value: selected['Produit'],
          decoration: InputDecoration(labelText: 'Produit'),
          items: produit.isNotEmpty
              ? produit.map((produit) {
                  return DropdownMenuItem<int>(
                    value: produit.produitId,
                    child: Text(produit.nomProduit),
                  );
                }).toList()
              : [],
          onChanged: produit.isNotEmpty ? onChangedProduit : null, 
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
              createProduit();
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
            updateQuantity(int.parse(value));
            calculateSousTotal();
          },
          validator: (value)  => value == null || value.isEmpty ? 'La quantité est requise' : null,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligne à gauche
          children: [
            Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0), // Espaces en haut et en bas
              child: Text(
                'Prix Unitaire: ${controllers['prixUnitaire']!.text ?? 'indisponible'} \nSous Total: ${controllers['sous_total']!.text ?? 'Indisponible'}',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left, // Alignement à gauche
              )
            ),
          ],
        ),
        ElevatedButton(
          onPressed: isEnabled ? createFacture : null,
          child: Text('Ajouter Facture'),
        ),
      ]
    )
  );
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Widget/Facture/details/buildrowsWidget.dart';
import 'package:my_first_app/constants.dart';

Widget factureDetailsWidget(
  BuildContext context,
  Map<String, dynamic> formData,
  Function(BuildContext) openEditFactureForm,
  ProductRowsWidget productRowsWidget,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children:  <Widget>[
      _factureDetailsHeader(formData),
      const SizedBox(height: 20),
      _productTableHeader(),
      Divider(thickness: 2),
      productRowsWidget,
    ]
  ); 
}

Widget _factureDetailsHeader(Map<String, dynamic> formData) {
  bool isEditing = false;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$clientLabel: ${formData[clientFormData].nom} ${formData[clientFormData].prenom}',
        style: TextStyle(fontSize: 20),
      ),
      Text(
        'Email: ${formData[clientFormData].email}',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        'Montant Total: ${NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(formData[factureFormData].montantTotal ?? 0.0)}',
      ),
      Text(
        'Date: ${formData[factureFormData].dateFacture != null ? DateFormat('dd/MM/yyyy').format(formData[factureFormData].dateFacture) : 'Date non renseignée'}',
      ),
      Divider(thickness: 1, color: customColors['lineGrey']),
    ],
  );
}

Widget _productTableHeader() {
  return Row(
    children: [
      const SizedBox(height: 10),
      Expanded(child: Text('Produit', style: TextStyle(fontWeight: FontWeight.bold))),
      SizedBox(width: 16),
      Text('Quantité', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(width: 16),
      Text('Prix Unitaire', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(width: 16),
      Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}

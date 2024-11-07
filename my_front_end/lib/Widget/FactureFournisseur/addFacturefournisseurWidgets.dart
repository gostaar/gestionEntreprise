import 'package:flutter/material.dart';
import 'package:my_first_app/Widget/customWidget/selectDateWidget.dart';
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/fournisseursModel.dart';



Widget addFactureFournisseurWidget(
  BuildContext context,
  Map<String, TextEditingController> controllers,
  int? selectedFournisseur,
  String? selectedStatut,
  List<Fournisseur> fournisseurs,
  double? sousTotal,
  bool isEnabled,
  Function(int?) onChangedFournisseur,
  Function(String?) onChangedStatut,
  Function() addFournisseur,
  Function() addFournisseurFacture,
){
  List<String> statuts = ['Non Payée', 'Payée', 'En Cours'];
  final _formKey = GlobalKey<FormState>();
  return Form(
    key: _formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget> [
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
          validator:(value) => value == null || value.isEmpty ? 'La date de la facture est requise' : null,
        ),
        DropdownButtonFormField<int>(
          value: selectedFournisseur,
          decoration: InputDecoration(labelText: 'Fournisseur'),
          items: fournisseurs.isNotEmpty
              ? fournisseurs.map((fournisseur) {
                  return DropdownMenuItem<int>(
                    value: fournisseur.fournisseurId,
                    child: Text(fournisseur.nom),
                  );
                }).toList()
              : [], 
          onChanged: fournisseurs.isNotEmpty
              ? onChangedFournisseur
              : null, 
          validator:(value) => value == null ? 'Le fournisseur est requis' : null,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () { addFournisseur; },
            child: Text(
              'Créer un fournisseur',
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
        fournisseurs.isEmpty
          ? Text(
              'Aucun fournisseur disponible. Veuillez ajouter un fournisseur.',
              style: TextStyle(color: customColors['red']), 
            )
          : SizedBox.shrink(),
        TextFormField(
          controller: controllers['datePaiement']!,
          decoration: InputDecoration(
            labelText: 'Date de Paiement',
            prefixIcon: Icon(Icons.calendar_today),
            filled: true,
            fillColor: customColors['borderGrey']!,
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
          validator:(value) => value == null || value.isEmpty ? 'La date de paiement est requise' : null,
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
          validator:(value) => value == null || value.isEmpty ? 'Le statut est requis' : null,
        ),
        Text(
          'Montant: ${sousTotal?.toStringAsFixed(2) ?? 'indisponible'}'
        ),
        ElevatedButton(
          onPressed: isEnabled ? addFournisseurFacture : null,
          child: Text('Ajouter Facture'),
        ),
      ],
    )
  );
}

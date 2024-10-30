import 'package:flutter/material.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/produit.dart';

//Bouton avec action
Widget actionButton(String text, VoidCallback action) {
  return Align(
    alignment: Alignment.centerRight,
    child: TextButton(
      onPressed: () {
        action();
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12, // Taille de la police
          fontWeight: FontWeight.bold, // Gras,
        ),
      ),
    ));
}

Widget textButtonDangerClient(List<Client> arg, String text) {
  return arg.isEmpty
      ? Text(
          text,
          style: TextStyle(color: Colors.red), // Correction de la syntaxe ici
        )
      : SizedBox.shrink(); // Retourne un widget vide si arg n'est pas vide
}

Widget textButtonDangerProduit(List<Produit> arg, String text) {
  return arg.isEmpty
      ? Text(
          text,
          style: TextStyle(color: Colors.red), // Correction de la syntaxe ici
        )
      : SizedBox.shrink(); // Retourne un widget vide si arg n'est pas vide
}

//Date Picker
Widget datePickerFull(TextEditingController controller, BuildContext context,
  String labelText, Future <void> Function(BuildContext, TextEditingController) selectDate) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(Icons.calendar_today),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
    readOnly: true,
    onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
      selectDate(context, controller);
    },
  );
}

//DropDownClient
Widget clientDropdown(int? selectedClient, String text,
    List<Client> clients, Function(int?) onChanged) {
  return DropdownButtonFormField<int>(
    value: selectedClient,
    decoration: InputDecoration(labelText: text),
    items: clients.isNotEmpty
        ? clients.map((client) {
            return DropdownMenuItem<int>(
              value: client.clientId,
              child: Text(client.nom),
            );
          }).toList()
        : [], // Aucune entrée si clients est vide
    onChanged: clients.isNotEmpty
        ? onChanged
        : null, // Désactiver le Dropdown si clients est vide
  );
}

//DropDownClient
Widget produitDropdown(int? selectedProduit, String text,
    List<Produit> produits, Function(int?) onChanged) {
  return DropdownButtonFormField<int>(
    value: selectedProduit,
    decoration: InputDecoration(labelText: text),
    items: produits.isNotEmpty
        ? produits.map((produit) {
            return DropdownMenuItem<int>(
              value: produit.produitId,
              child: Text(produit.nomProduit),
            );
          }).toList()
        : [], // Aucune entrée si clients est vide
    onChanged: produits.isNotEmpty
        ? onChanged
        : null, // Désactiver le Dropdown si clients est vide
  );
}

//DropDownStatut
Widget statutDropdown(
    String? selectedStatut, Function(String?) onChanged) {
  List<String> statuts = ['Non Payée', 'Payée', 'En Cours'];

  return DropdownButtonFormField<String>(
    value: selectedStatut,
    decoration: InputDecoration(labelText: 'Statut'),
    items: statuts.map((String statut) {
      return DropdownMenuItem<String>(
        value: statut,
        child: Text(statut),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

Widget textQuantity(TextEditingController controller, VoidCallback calculateSousTotal, Function(String) updateQuantity) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(labelText: 'Quantité'),
    keyboardType: TextInputType.number,
    onChanged: (value) {
      updateQuantity(value);
      calculateSousTotal();
    },
  );
}

Widget customElevatedButton({
  required bool isEnabled,
  required VoidCallback? onPressed,
  required String buttonText,
}) {
  return ElevatedButton(
    onPressed: isEnabled ? onPressed : null,
    child: Text(buttonText),
  );
}


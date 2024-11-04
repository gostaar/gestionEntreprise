import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/fournisseurs.dart';
import 'package:my_first_app/models/produit.dart';

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
          fontSize: 12, 
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
}

Widget textButtonDangerClient(List<Client> arg, String text) {
  return arg.isEmpty
      ? Text(
          text,
          style: TextStyle(color: Colors.red), 
        )
      : SizedBox.shrink(); 
}

Widget textButtonDangerFournisseur(List<Fournisseur> arg, String text) {
  return arg.isEmpty
      ? Text(
          text,
          style: TextStyle(color: Colors.red), 
        )
      : SizedBox.shrink(); 
}

Widget textButtonDangerProduit(List<Produit> arg, String text) {
  return arg.isEmpty
      ? Text(
          text,
          style: TextStyle(color: Colors.red), 
        )
      : SizedBox.shrink(); 
}

Widget datePickerFull(TextEditingController controller, BuildContext context,
  String labelText, String fieldName,Future <void> Function(BuildContext, TextEditingController, String) selectDate) {
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
      selectDate(context, controller, fieldName);
    },
  );
}

Widget datePickerFullAdd(TextEditingController controller, BuildContext context,
  String labelText,Future <void> Function(BuildContext, TextEditingController) selectDateAdd) {
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
      selectDateAdd(context, controller);
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

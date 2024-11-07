import 'package:flutter/material.dart';

void showError(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Erreur"),
      content: Text(message),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop(); // Fermer le dialogue
          },
        ),
      ],
    ),
  );
}
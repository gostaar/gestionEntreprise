import 'package:flutter/material.dart';
import 'package:my_first_app/models/client.dart';

Widget clientDropdown(int? selectedClient, String text, List<Client> clients, Function(int?) onChanged) {
  return DropdownButtonFormField<int>(
    value: selectedClient, // Utilise selectedClient comme valeur par défaut
    decoration: InputDecoration(labelText: text),
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
            print("Client sélectionné : $newValue"); // Affiche le nouveau client sélectionné
            onChanged(newValue); // Appelle la fonction onChanged passée en paramètre
          }
        : null,
  );
}

import 'package:flutter/material.dart';
import 'package:my_first_app/constants.dart';

Widget buildDetailRowRendered(String field, TextEditingController controller, bool isEditing) {
  return isEditing
    ? buildDetailRowEditing(field[0].toUpperCase().substring(1), controller)
    : buildDetailRow(field[0].toUpperCase().substring(1), controller.text);
}

//utilisé dans Client/detailRowClientWidget
Widget buildDetailRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120, 
          child: Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value ?? 'Non renseigné'),
        ),
      ],
    ),
  );
}

Widget buildDetailRowEditing(String label, TextEditingController value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120, 
          child: Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
       Expanded(
          child:TextFormField(
                  controller: value,
                  decoration: InputDecoration(
                    // Ajoutez un soulignement au champ pour indiquer l'édition
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: customColors['blue']!),
                    ),
                  ),
                )
        ),
      ],
    ),
  );
}
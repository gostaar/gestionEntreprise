import 'package:flutter/material.dart';
import 'package:my_first_app/constants.dart';  // Assurez-vous que ce chemin est correct

Widget updateDetailWidget(
  Map<String, TextEditingController> controllers,
  bool isEditing,
) {
  return ListView.builder(
    padding: const EdgeInsets.all(16.0),
    itemCount: controllers.length,
    itemBuilder: (context, index) {
      final label = clientLabels[index]; // Le label du champ
      final controller = controllers.values.elementAt(index); // Le contrôleur associé au champ

      // Utilisation du widget approprié en fonction du mode (édition ou affichage)
       if(isEditing){
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
                  controller: controller,
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
      } else {
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
                child: Text(controller.text ?? 'Non renseigné'),
              ),
            ],
          ),
        );
      }
    },
  );
}

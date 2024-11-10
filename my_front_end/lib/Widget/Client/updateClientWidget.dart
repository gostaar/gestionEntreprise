import 'package:flutter/material.dart';
import 'package:my_first_app/constants.dart';  

Widget buildDetailTab(
  Map<String, TextEditingController> controllers,
  bool isEditing,
) {
  return ListView.builder(
    padding: const EdgeInsets.all(16.0),
    itemCount: controllers.length,
    itemBuilder: (context, index) {
      final label = clientLabels[index]; 
      final controller = controllers.values.elementAt(index); 

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
    }
  );
}

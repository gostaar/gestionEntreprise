import 'package:flutter/material.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/Service/client_service.dart';

class EditClientForm extends StatefulWidget {
  final Client client;

  EditClientForm({required this.client});

  @override
  _EditClientFormState createState() => _EditClientFormState();
}

class _EditClientFormState extends State<EditClientForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};

  @override
  void initState() {
    super.initState();
    // Initialiser les valeurs avec les données du client
    _formData = {
      'nom': widget.client.nom,
      'prenom': widget.client.prenom ?? '',
      'email': widget.client.email ?? '',
      'telephone': widget.client.telephone ?? '',
      'adresse': widget.client.adresse ?? '',
      'ville': widget.client.ville ?? '',
      'codePostal': widget.client.codePostal ?? '',
      'pays': widget.client.pays ?? '',
      'numeroTva': widget.client.numeroTva ?? '',
    };
  }

  Future<void> _updateClient() async {
    //print(_formData);
    //print(_formData['telephone']!); //ici c'est vide comme dans la base de donnée mais l'utilisateur a entrer une valeur
    
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedClient = Client(
        clientId: widget.client.clientId,
        nom: _formData['nom']!,
        prenom: _formData['prenom']!,
        email: _formData['email']!,
        telephone: _formData['telephone']!,
        adresse: _formData['adresse'],
        ville: _formData['ville'],
        codePostal: _formData['codePostal'],
        pays: _formData['pays'],
        numeroTva: _formData['numeroTva'],
      );
    
      try {
        await ClientService.updateClient(updatedClient);
        Navigator.pop(context, true); // Ferme le formulaire
      } catch (error) {
        _showError(context, 'Erreur lors de la mise à jour du client: $error');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

@override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Boucle pour générer les champs de formulaire
            for (String field in _formData.keys)
              TextFormField(
                initialValue: _formData[field],
                decoration: InputDecoration(
                  labelText: field[0].toUpperCase() + field.substring(1),
                ),
                onSaved: (value) {
                  // Sauvegarde la valeur du champ
                  _formData[field] = value ?? '';
                },
                validator: (value) {
                  // Validation uniquement pour le champ 'nom'
                  if (field == 'nom' && (value == null || value.isEmpty)) {
                    return 'Veuillez entrer un nom';
                  }
                  return null; // Pas d'erreur pour les autres champs
                },
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateClient,
              child: Text('Enregistrer'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Couleur du bouton
              ),
            ),
          ],
        ),
      ),
    );
  }
}

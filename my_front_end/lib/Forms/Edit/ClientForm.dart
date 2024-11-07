import 'package:flutter/material.dart';
import 'package:my_first_app/Widget/Client/editClientWidget.dart';
import 'package:my_first_app/Widget/customWidget/showErrorWidget.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/Service/clientService.dart';

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
        showError(context, 'Erreur lors de la mise à jour du client: $error');
      }
    }
  }

@override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            editClientWidget(
              _formData,
              _updateClient,
            )
          ],
        ),
      ),
    );
  }
}

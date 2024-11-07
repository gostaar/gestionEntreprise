import 'package:flutter/material.dart';
import 'package:my_first_app/Service/clientService.dart';
import 'package:my_first_app/Widget/Client/addClientWidget.dart';

class AddClientForm extends StatefulWidget {
  final Future<void> Function({
    required int clientId,
    required String? nom,
    required String? prenom,
    required String? email,
    required String? telephone,
    required String? adresse,
    required String? ville,
    required String? codePostal,
    required String? pays,
    required String? numeroTva,
  }) addClientFunction;

  const AddClientForm({Key? key, required this.addClientFunction}) : super(key: key);

  @override
  _AddClientFormState createState() => _AddClientFormState();
}

class _AddClientFormState extends State<AddClientForm> {
  final List<TextEditingController> _controllers = List.generate(
    9,
    (_) => TextEditingController(),
  );

  Future<void> _addClient() async {
    try {
      final lastClientId = await ClientService.getLastClientId()+1;
      await widget.addClientFunction(
        clientId: lastClientId, 
        nom: _controllers[0].text,
        prenom: _controllers[1].text,
        email: _controllers[2].text,
        telephone: _controllers[3].text,
        adresse: _controllers[4].text,
        ville: _controllers[5].text,
        codePostal: _controllers[6].text,
        pays: _controllers[7].text,
        numeroTva: _controllers[8].text,
      );
      Navigator.pop(context, true);
    } catch (e){ 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout du client: $e')),);
    }
  }

  final List<String> _labels = [
    'Nom',
    'Prénom',
    'Email',
    'Téléphone',
    'Adresse',
    'Ville',
    'Code Postal',
    'Pays',
    'Numéro de TVA',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajout d\'un Client')),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              addClientWidget(
                _labels,
                _controllers,
                _addClient,
              ),
            ]
          ),
        ),
      ),
    );
  }
}

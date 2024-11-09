import 'package:flutter/material.dart';
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/clientModel.dart';

class ClientInfoSection extends StatelessWidget {
  final Client client;

  const ClientInfoSection({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${clientLabel}: ${client.nom} ${client.prenom}', style: TextStyle(fontSize: 20)),
        Text('${emailLabel}: ${client.email}', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
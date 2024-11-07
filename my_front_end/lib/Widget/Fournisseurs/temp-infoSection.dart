import 'package:flutter/material.dart';
import 'package:my_first_app/models/fournisseursModel.dart';

class FournisseurInfoSection extends StatelessWidget {
  final Fournisseur fournisseur;

  const FournisseurInfoSection({Key? key, required this.fournisseur}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fournisseur: ${fournisseur.nom} ${fournisseur.prenom}', style: TextStyle(fontSize: 20)),
        Text('Email: ${fournisseur.email}', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
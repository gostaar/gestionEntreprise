import 'package:flutter/material.dart';
import 'package:my_first_app/Widget/Facture/InfoSection.dart';
import 'package:my_first_app/models/factureModel.dart';

Widget buildFacturesTab(
  BuildContext context, 
  List<Facture> factures, 
  Function(BuildContext, Facture) onNavigate,
) {
    if (factures.isEmpty) {
      return Center(child: Text('Aucune facture pour ce client'));
    }

    return ListView.builder(
      itemCount: factures.length,
      itemBuilder: (context, index) {
        final facture = factures[index];
        return ListTile(
          title: Text('Facture ${facture.factureId}'),
          subtitle: FactureInfoSection(facture: facture),
          onTap: () => onNavigate(context, facture),
        );
      },
    );
  }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/factureFournisseurModel.dart';

class FactureFournisseurInfoSection extends StatelessWidget {
  final FactureFournisseur facture;

  const FactureFournisseurInfoSection({Key? key, required this.facture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double montantTotal = facture.montantTotal ?? 0.0; 
    final String formattedMontant = NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(montantTotal);
    String formattedDate = facture.dateFacture != null
      ? DateFormat('dd/MM/yyyy').format(facture.dateFacture!)
      : 'Date non renseignée';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Montant Total: ${formattedMontant}\nDate: ${formattedDate}'),
        Divider(thickness: 1, color: customColors['lineGrey']),   
      ],
    );
  }
}
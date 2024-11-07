import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/factureModel.dart';

Widget buildFacturesTab(BuildContext context, List<Facture> factures, Function navigateToFacturesPage) {
 
  if (factures.isEmpty) {
    return Center(
      child: Text('Aucune facture trouvée pour ce client.'),
    );
  } else {
    return ListView.builder(
      itemCount: factures.length,
      itemBuilder: (context, index) {
        final facture = factures[index];
        final String formattedMontant = NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(facture.montantTotal ?? 0.0);
        final String formattedDate = facture.dateFacture != null
          ? DateFormat('dd/MM/yyyy').format(facture.dateFacture!)
          : 'Date non renseignée';
        return ListTile(
          title: Text('Facture #${facture.factureId}'),
          subtitle: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Montant Total: ${formattedMontant}\nDate: ${formattedDate}'),
                Divider(thickness: 1, color: customColors['lineGrey']),   
              ],
            ),
          onTap: () => navigateToFacturesPage(context), // Navigation vers les détails de la facture
        );
      },
    );
  }
}
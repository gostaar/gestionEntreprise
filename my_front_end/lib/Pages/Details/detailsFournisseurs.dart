import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/Details/detailsFactureFournisseur.dart';
import 'package:my_first_app/Service/fournisseur_service.dart';
import 'package:my_first_app/Widget/Functions.dart';
import 'package:my_first_app/models/factureFournisseur.dart';
import 'package:my_first_app/models/fournisseurs.dart';

class FournisseurDetailPage extends StatelessWidget {
  final Fournisseur fournisseur; 
  final List<FactureFournisseur> factures;

  FournisseurDetailPage({
    required this.fournisseur,
    required this.factures,
  });

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

  void _navigateToFacturesPage(BuildContext context, FactureFournisseur f) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      //final lignesFacture = await _fetchLignesFacture(f.id);
      final fournisseurDetails = await FournisseurService.getFournisseursById(f.id);

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FactureFournisseurDetailPage(
            factures: [f],
            //lignesFacture: lignesFacture,
            fournisseur: fournisseurDetails,
          ),
        ),
      );
    } catch (error) {
      Navigator.pop(context); 
      _showError(context, 'Erreur lors de la récupération des factures fournisseur: $error');
    }
  }

  // Méthode pour récupérer les lignes de facture
  //Future<List<LigneFacture>> _fetchLignesFacture(int factureId) async {
  //  final factureService = FactureService();
  //  return await factureService.getLignesFacture(factureId);
  //}

  Widget buildFacturesTab(BuildContext context, List<FactureFournisseur> factures, Function(BuildContext, FactureFournisseur) onNavigate) {
    if (factures.isEmpty) {
      return Column(
        children: [
          SizedBox(height: 16),
          Text(
            'Aucune facture pour ce fournisseur',
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: factures.length,
      itemBuilder: (context, index) {
        final facture = factures[index];
        
        return ListTile(
          title: Text('Facture ${facture.id}'),
          subtitle: FactureFournisseurInfoSection(facture: facture),
          onTap: () => onNavigate(context, facture),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Deux onglets : Détails et Factures
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fiche de ${fournisseur.nom}'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Détails'),
              Tab(text: 'Factures'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            fournisseurDetailWidget(context, fournisseur),
            buildFacturesTab(context, factures, _navigateToFacturesPage),
          ],
        ),
      ),
    );
  }
}

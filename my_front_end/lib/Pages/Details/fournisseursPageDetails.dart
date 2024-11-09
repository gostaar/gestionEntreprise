import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/Details/factureFournisseurPageDetails.dart';
import 'package:my_first_app/Service/fournisseurService.dart';
import 'package:my_first_app/Widget/FactureFournisseur/temp-InfoSection.dart';
import 'package:my_first_app/Widget/Fournisseurs/fournisseursDetailsWidget.dart';
import 'package:my_first_app/models/factureFournisseurModel.dart';
import 'package:my_first_app/models/fournisseursModel.dart';

class FournisseurDetailPage extends StatelessWidget {
  final Fournisseur fournisseur; 
  final List<FactureFournisseur> factures;

  FournisseurDetailPage({
    required this.fournisseur,
    required this.factures,
  });

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
    } catch (e) {
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la récupération des factures fournisseur: $e')),);
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

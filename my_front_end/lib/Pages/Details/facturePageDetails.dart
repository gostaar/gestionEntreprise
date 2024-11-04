import 'package:flutter/material.dart';
import 'package:my_first_app/Forms/Edit/FactureForm.dart';
import 'package:my_first_app/Service/factureService.dart';
import 'package:my_first_app/Widget/clientWidgets.dart';
import 'package:my_first_app/Widget/factureWidgets.dart';
import 'package:my_first_app/Widget/produitsWidgets.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/factureModel.dart';
import 'package:my_first_app/models/ligneFactureModel.dart';
import 'package:my_first_app/models/produitModel.dart';
import 'package:my_first_app/Service/produitService.dart';

class FactureDetailPage extends StatefulWidget {
  Facture facture;
  final List<LigneFacture> lignesFacture;
  final Client client;

  FactureDetailPage({
    required this.facture,
    required this.lignesFacture,
    required this.client,
  });

  @override
  _FactureDetailPageState createState() => _FactureDetailPageState();
}

class _FactureDetailPageState extends State<FactureDetailPage> {

  String formatDate(DateTime? date) {
    if (date == null) return 'Non spécifiée';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<List<Widget>> _buildProductRows() async {
    List<Widget> rows = [];
    for (var ligne in widget.lignesFacture) {  // Utiliser widget.lignesFacture
      Produit? produit = await _getProduit(ligne.produitId);
      rows.add(ProductDescriptionRow(produit: produit));
      rows.add(ProductDetailsRow(ligne: ligne));
    }
    return rows;
  }

  Future<Produit?> _getProduit(int produitId) async {
    List<Produit>? produits = await ProduitService.getProduitsById(produitId);
    return produits != null && produits.isNotEmpty ? produits.first : null;
  }

  void _openEditFactureForm(BuildContext context) {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: EditFactureForm(
          facture: widget.facture, // Utiliser widget.facture
          lignesFacture: widget.lignesFacture,
        ),
      ),
    ).then((_) async {
      final updatedFacture = await FactureService.getFactureById(widget.facture.id);
      if (updatedFacture != null) {
        setState(() {
          widget.facture = updatedFacture; // Mise à jour de la facture
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facture ${widget.facture.id}'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _openEditFactureForm(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ClientInfoSection(client: widget.client),
            FactureInfoSection(facture: widget.facture),
            const SizedBox(height: 20),
            const TableHeader(),
            Divider(thickness: 2),
            FutureBuilder<List<Widget>>(
              future: _buildProductRows(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun produits renseigné'));
                }
                return Column(children: snapshot.data!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Forms/Edit/FactureForm.dart';
import 'package:my_first_app/Service/factureService.dart';
import 'package:my_first_app/Widget/Facture/factureDetailsWidgets.dart';
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
    required  this.facture,
    required this.lignesFacture,
    required this.client,
  });

  @override
  _FactureDetailPageState createState() => _FactureDetailPageState();
}

class _FactureDetailPageState extends State<FactureDetailPage> {
  Map<String, dynamic> _formData = {};
  
  @override
  void initState(){
    super.initState();
    _formData = {
      'client': widget.client, 
      'facture': widget.facture,
      'ligneFacture': widget.lignesFacture,
    };
  }

  Future<List<Widget>> _buildProductRows() async {
    List<Widget> rows = [];
    
    // Fetch all products in parallel
    List<Produit?> produits = await Future.wait(
      widget.lignesFacture.map((ligne) => _getProduit(ligne.produitId)),
    );

    for (int i = 0; i < widget.lignesFacture.length; i++) {
      var ligne = widget.lignesFacture[i];
      var produit = produits[i];

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(child: Text(produit?.description ?? 'Produit non trouvé')),
            ],
          ),
        ),
      );

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: SizedBox()), // Cellule vide pour le produit
              Text(
                NumberFormat.decimalPattern('fr_FR').format(ligne.quantite),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 16),
              Text(
                NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(ligne.prixUnitaire),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 16),
              Text(
                NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(ligne.sousTotal),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
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
          facture: _formData['facture'], // Utiliser widget.facture
          lignesFacture: _formData['lignesFacture'],
        ),
      ),
    ).then((_) async {
      final updatedFacture = await FactureService.getFactureById(_formData['facture'].id);
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
      appBar: AppBar(title: Text('Facture ${_formData['facture'].id}'),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
            factureDetailsWidget(
              context,
              _formData,
              _openEditFactureForm,
              _buildProductRows,
            ),
          ],)
        ),
      )       
    );
  }
}

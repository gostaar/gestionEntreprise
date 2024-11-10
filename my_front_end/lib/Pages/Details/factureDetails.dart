import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Service/factureService.dart';
import 'package:my_first_app/Widget/Facture/details/buildrowsWidget.dart';
import 'package:my_first_app/Widget/Facture/factureDetailsWidgets.dart';
import 'package:my_first_app/constants.dart';
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
  void initState() {
    super.initState();
    _formData = {
      clientFormData: widget.client,
      factureFormData: widget.facture,
      ligneFactureFormData: widget.lignesFacture,
    };
  }

  void _openEditFactureForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
      ),
    ).then((_) async {
      final updatedFacture = await FactureService.getFactureById(_formData[factureFormData].factureId);
      if (updatedFacture != null) {
        if (mounted) {
          setState(() {
            widget.facture = updatedFacture;
          });
        }
      }
    });
  }

  Future<Produit?> _getProduit(int produitId) async {
    List<Produit>? produits = await ProduitService.getProduitsById(produitId);
    return produits != null && produits.isNotEmpty ? produits.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$factureLabel ${_formData[factureFormData].factureId}'),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              factureDetailsWidget(
                context,
                _formData,
                _openEditFactureForm,
                ProductRowsWidget(lignesFacture: widget.lignesFacture),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

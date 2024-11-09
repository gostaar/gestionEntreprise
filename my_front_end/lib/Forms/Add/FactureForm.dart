import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Forms/Add/ClientForm.dart';
import 'package:my_first_app/Forms/Add/ProduitForm.dart';
import 'package:my_first_app/Service/clientService.dart';
import 'package:my_first_app/Service/factureService.dart';
import 'package:my_first_app/Service/produitService.dart';
import 'package:my_first_app/Widget/Facture/addFactureWidget.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/produitModel.dart';

class AddFactureForm extends StatefulWidget {
  final Future<void> Function({
    required int factureId,
    required int clientId,
    //required DateTime? dateFacture,
    required double? montantTotal,
    required String? statut,
    required String? datePaiement,
  }) createFactureFunction;

  final Future<void> Function({
    required int ligneId,
    required int factureId,
    required int produitId,
    required int quantite,
    required double prixUnitaire,
  }) createLigneFactureFunction;

  const AddFactureForm({Key? key, required this.createFactureFunction, required this.createLigneFactureFunction}) : super(key: key);

  @override
  _AddFactureFormState createState() => _AddFactureFormState();
}

class _AddFactureFormState extends State<AddFactureForm> {
  final Map<String, TextEditingController> _controllers = {
    'datePaiement': TextEditingController(), //dateTime
    'dateFacture': TextEditingController(), //dateTime
    'quantite': TextEditingController(), //int
    'prixUnitaire': TextEditingController(), //double
    'sous_total': TextEditingController(), //double
    'selectedStatut': TextEditingController(), //string
  };

  final Map<String, int?> _selected = {
    'Produit': null, //int
    'Client': null, //int
  };

  DateTime? datePaiement;

  List<Client> _clients = [];
  List<Produit> _produits = [];

  @override
  void initState() {
    super.initState();
    _fetchClients();
    _fetchProduits();
  }

  void _updateQuantity(int? value) {setState(() { _controllers['quantite']!.text = value.toString();});}

  void _calculateSousTotal() {
    setState(() { 
      double? sousTotal = calculateSousTotal(
        _controllers['prixUnitaire']!.text, 
        _controllers['quantite']!.text,
      );

      _controllers['sous_total']!.text = sousTotal?.toStringAsFixed(2) ?? '0.00';
    });
  }

  double? calculateSousTotal(String prixUnitaireText, String quantiteText) {
    if (quantiteText.isNotEmpty) {
      double prixUnitaire = double.parse(prixUnitaireText);
      int quantite = int.parse(quantiteText);
      return prixUnitaire * quantite;
    }
    return 0.0; 
  }

  Future<void> _createFacture() async {
    try {
    final lastFactureId = await FactureService.getLastFactureId() + 1;
      await widget.createFactureFunction(
        factureId: lastFactureId,
        clientId: _selected['Client']!,
        //dateFacture: dateFactureField,
        montantTotal: double.parse(_controllers['sous_total']!.text),
        statut: _controllers['selectedStatut']!.text,
        datePaiement: datePaiement!.toIso8601String(),
      );
      _createLigneFacture(lastFactureId);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout de la facture: $e')),);
    }
  }

  Future<void> _createLigneFacture(int factureId) async{
    try {
      final lastLigneId = await FactureService.getLastLigneId() +1;
      await widget.createLigneFactureFunction(
        ligneId: lastLigneId,
        factureId: factureId,
        produitId: _selected['Produit']!,
        quantite: int.parse(_controllers['quantite']!.text),
        prixUnitaire: double.parse(_controllers['prixUnitaire']!.text),
      );
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout de la ligne de facture: ${e.toString()}')),);
    }
  }

  Future<void> _fetchClients() async {
    try{
      final response = await ClientService.fetchClients();
      if(mounted){setState(() {_clients = response;});}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors du chargement des clients: ${e.toString()}')),);
    }
  }
    
  Future<void> _fetchProduits() async {
    try {
      final response = await ProduitService.fetchProduits();
      if(mounted){setState(() {_produits = response;});}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors du chargement des produits: ${e.toString()}')),);
    }
  }

  Future<void> _createClient() async {
    final result = await Navigator.push(context, MaterialPageRoute( builder: (context) => AddClientForm(createClientFunction: ClientService.createClient,),),);
    if (result == true) {
      if(mounted){setState(() {_fetchClients(); });}
    }
  }
  
  Future<void> _createProduit() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduitForm(createProduitFunction: ProduitService.createProduit,),));
    if (result == true) {
      if(mounted){setState(() {_fetchProduits();});}
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          createFactureWidget(
            context,
            _controllers,
            _selected,
            datePaiement,
            _createClient,
            _createProduit,
            _createFacture,
            _calculateSousTotal,
            (DateTime? newValue){setState(() {
              _controllers['datePaiement']!.text = DateFormat('dd-MM-yyyy').format(newValue!);
              datePaiement = newValue;
            });},
            _updateQuantity,
            (int? newValue) { setState(() { _selected['Client'] = newValue; });},
            (String? newValue) {setState(() {_controllers['selectedStatut']!.text = newValue!;});},
            (int? newValue) { setState(() {
                _selected['Produit'] = newValue;
                _controllers['prixUnitaire']!.text = _produits
                  .firstWhere((product) => product.produitId == newValue)
                  .prix
                  .toString();
                _calculateSousTotal();
            });},
            _clients,
            _produits,
            _selected['Client'] != null && _selected['Produit'] != null && _controllers['quantite'] != null,
          ),
        ]
      ),
    );
  }
}

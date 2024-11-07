import 'package:flutter/material.dart';
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
    required DateTime? dateFacture,
    required double? montantTotal,
    required String? statut,
    required DateTime? datePaiement,
  }) addFactureFunction;

  final Future<void> Function({
    required int ligneId,
    required int factureId,
    required int produitId,
    required int quantite,
    required double prixUnitaire,
  }) addLigneFactureFunction;

  const AddFactureForm({Key? key, required this.addFactureFunction, required this.addLigneFactureFunction}) : super(key: key);

  @override
  _AddFactureFormState createState() => _AddFactureFormState();
}

class _AddFactureFormState extends State<AddFactureForm> {
  final Map<String, TextEditingController> _controllers = {
    'datePaiement': TextEditingController(),
    'dateFacture': TextEditingController(),
  }; 
  //TextEditingController quantite = TextEditingController();
  //contenu dropdown
  List<Client> _clients = [];
  List<Produit> _produits = [];
  //selected dropdown
  int? _selectedClient;
  int? _selectedProduit;
  String? _selectedStatut;
  //informations additionnelles
  double? _prixUnitaire;
  double? _sousTotal;
  int? _quantity;
  double? calculateSousTotal(double prixUnitaire, String quantiteText) {
    if (quantiteText.isNotEmpty) {
      int quantite = int.parse(quantiteText);
      return (prixUnitaire * quantite);
    }
    return 0; 
  }

  @override
  void initState() {
    super.initState();
    fetchClients();
    fetchProduits();
  }

  void _updateQuantity(String value) { setState(() { _quantity = value.isNotEmpty ? int.tryParse(value) : null;  });}

  void _calculateSousTotal() {setState(() { _sousTotal = calculateSousTotal(_prixUnitaire!, _controllers['quantite']!.text); });}

  Future<void> addFacture() async {
    try {
      final lastFactureId = await FactureService.getLastFactureId() + 1;
      await widget.addFactureFunction(
        factureId: lastFactureId,
        clientId: _selectedClient!,
        dateFacture: DateTime.tryParse(_controllers['dateFacture']!.text),
        montantTotal: _sousTotal!,
        statut: _selectedStatut!,
        datePaiement: DateTime.tryParse(_controllers['datePaiement']!.text),
      );
      addLigneFacture(lastFactureId);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout de la facture: $e')),
      );
    }
  }

  Future<void> addLigneFacture(int factureId) async{
    try {
      final lastLigneId = await FactureService.getLastLigneId() +1;
      await widget.addLigneFactureFunction(
        ligneId: lastLigneId,
        factureId: factureId,
        produitId: _selectedProduit!,
        quantite: _quantity!,
        prixUnitaire: _prixUnitaire!,
      );
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout de la ligne de facture')),
      );
    }
  }

  Future<void> fetchClients() async {
    try{
      final response = await ClientService.fetchClients();
      setState(() {_clients = response;});
    } catch (e) {
      throw Exception('Erreur lors du chargement des clients, $e');
    }
  }
    
  Future<void> fetchProduits() async {
    try {
      final response = await ProduitService.fetchProduits();
      setState(() {_produits = response;});
    } catch (e) {
      throw Exception('Erreur lors du chargement des Produits, $e');
    }
  }

  Future<void> addClient() async {
    final result = await Navigator.push(context, MaterialPageRoute( builder: (context) => AddClientForm(addClientFunction: ClientService.addClient,),),);
    if (result == true) {
      setState(() {fetchClients(); });
    }
  }
  
  Future<void> addProduit() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduitForm(addProduitFunction: ProduitService.addProduit,),));
    if (result == true) {
      setState(() {fetchProduits();});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          addFactureWidget(
            context,
            _controllers,
            addClient,
            addProduit,
            addFacture,
            _calculateSousTotal,
            _updateQuantity,
            (int? newValue) { setState(() { _selectedClient = newValue; });},
            (String? newValue) {setState(() {_selectedStatut = newValue;});},
            (int? newValue) { setState(() {
                _selectedProduit = newValue;
                _prixUnitaire = _produits.firstWhere((product) => product.produitId == newValue).prix;
                _calculateSousTotal();
              });},
            _clients,
            _produits,
            _selectedClient,
            _selectedStatut,
            _selectedProduit,
            _prixUnitaire,
            _sousTotal,
            _quantity,
            _selectedClient != null && _selectedProduit != null && _quantity != null,
          ),
        ]
      ),
    );
  }
}

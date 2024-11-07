import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Forms/Add/ClientForm.dart';
import 'package:my_first_app/Forms/Add/ProduitForm.dart';
import 'package:my_first_app/Service/clientService.dart';
import 'package:my_first_app/Service/factureService.dart';
import 'package:my_first_app/Service/produitService.dart';
import 'package:my_first_app/Widget/Facture/editFactureWidget.dart';
import 'package:my_first_app/Widget/customWidget/showErrorWidget.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/factureModel.dart';
import 'package:my_first_app/models/ligneFactureModel.dart';
import 'package:my_first_app/models/produitModel.dart';

class EditFactureForm extends StatefulWidget {
  final Facture facture;
  final List<LigneFacture> lignesFacture;

  EditFactureForm({required this.facture, required this.lignesFacture});

  @override
  _EditFactureFormState createState() => _EditFactureFormState();
}

class _EditFactureFormState extends State<EditFactureForm> {
  
  
  final _formKey = GlobalKey<FormState>(); // Clé de formulaire
  Map<String, String> _formData = {};
  Map<String, TextEditingController> _controllers = {
    'datePaiement': TextEditingController(),
    'dateFacture': TextEditingController(),
    'search': TextEditingController(),
    'quantite': TextEditingController(),
  };
  int? _selectedProduit;
  final List<Client> _clients = [];
  List<Produit> _produits = [];
  double? _prixUnitaire;
  int? quantity;
  List<String> textDanger = ['Aucun client disponible. Veuillez ajouter un client.','Aucun produit disponible. Veuillez ajouter un produit.'];
  double? _montantTotal;
 
  List<Client> filteredClients = [];


 @override
  void initState() {
    super.initState();
    _formData = {
      'client_id': widget.facture.clientId.toString(),
      'montant_total': widget.facture.montantTotal?.toString() ?? '',
      'statut': widget.facture.statut ?? '',
      'date_facture': widget.facture.dateFacture != null 
          ? DateFormat('dd-MM-yyyy').format(widget.facture.dateFacture!) 
          : '',
      'date_paiement': widget.facture.datePaiement != null 
          ? DateFormat('dd-MM-yyyy').format(widget.facture.datePaiement!) 
          : '',
    };
  }

  Future<void> _updateFacture() async {
 
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedFacture = Facture(
        factureId: widget.facture.factureId,
        clientId: int.parse(_formData['client_id']!),
        montantTotal: double.parse(_formData['montant_total']!),
        statut: _formData['statut']!,
        dateFacture: DateFormat('dd-MM-yyyy').parse(_formData['date_facture']!),
        datePaiement: DateFormat('dd-MM-yyyy').parse(_formData['date_paiement']!),
      );
    
      try {
        await FactureService.updateFacture(updatedFacture);
        Navigator.pop(context, true); 
      } catch (error) {
        showError(context, 'Erreur lors de la mise à jour de la facture: $error');
      }
    }
  }

  Future<List<Client>> _fetchClients() async {
    try {
      return await ClientService.fetchClients();
    } catch (e) {
      showError(context, 'Erreur lors de la récupération des clients: $e');
      return [];
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

  Future<void> _addClient() async {
    final result = await Navigator.push(context, MaterialPageRoute( builder: (context) => AddClientForm(addClientFunction: ClientService.addClient,),),);
    if (result == true) {
      setState(() {_fetchClients(); });
    }
  }
  
  Future<void> _addProduit() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduitForm(addProduitFunction: ProduitService.addProduit,),));
    if (result == true) {
      setState(() {fetchProduits();});
    }
  }

  void _updateQuantity(String value) {
    setState(() {
      quantity = value.isNotEmpty ? int.tryParse(value) : null; 
    });
  }

  void _calculateSousTotal() {
    if (_prixUnitaire != null && _controllers['quantite']!.text.isNotEmpty) {
      int quantite = int.parse(_controllers['quantite']!.text);
          double montantTotal = _prixUnitaire! * quantite;
      setState(() {
        _formData['montant_total'] = montantTotal.toString();
      });
    }
  }

  

  void _updateSelectedProduit(int? newValue) {
    _selectedProduit = newValue;
    if (_produits.isNotEmpty) {
      _prixUnitaire = _produits.firstWhere((product) => product.produitId == newValue).prix;
    }
    _calculateSousTotal();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            editFactureWidget(
              context,
              _controllers,
              _formData,
              _clients,
              _produits,
              _selectedProduit,
              _prixUnitaire,
              _montantTotal,
              _formData['client_id'] != null && _selectedProduit != null && _controllers['quantite']!.text.isNotEmpty,
              (int? newValue) {setState(() {_formData['client_id'] = newValue.toString();});},
              (String? newValue) {setState(() {_formData['statut'] = newValue!;});},
              (int? newValue) {setState(() {_updateSelectedProduit(newValue);});},
              _addClient,
              _calculateSousTotal,
              _updateQuantity,
              _addProduit,
              _updateFacture,
            ),
          ],
        ),
      ),
    );
  }
}
   
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/Forms/AddFournisseurForm.dart';
import 'package:my_first_app/Service/fournisseur_service.dart';
import 'package:my_first_app/Service/produit_service.dart';
import 'package:my_first_app/models/fournisseurs.dart';
import 'package:my_first_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Widget/Rendered.dart';

class AddFactureFournisseurForm extends StatefulWidget {
  @override
  _AddFactureFournisseurFormState createState() => _AddFactureFournisseurFormState();
}

class _AddFactureFournisseurFormState extends State<AddFactureFournisseurForm> {
  final TextEditingController _datePaiementController = TextEditingController();
  final TextEditingController _dateFactureController = TextEditingController();
  int? _selectedFournisseur;
  //int? _selectedProduit;
  List<Fournisseur> _fournisseurs = [];
  //List<Produit> _produits = [];
  //double? _prixUnitaire;
  double? _sousTotal;
  late TextEditingController _sousTotalController;
  //int? _quantity;
  String? _selectedStatut;
  List<String> textDanger = ['Aucun fournisseur disponible. Veuillez ajouter un fournisseur.','Aucun produit disponible. Veuillez ajouter un produit.'];
  final ProduitService produitService = ProduitService();
  String formatDate(String date) {
    List<String> parts = date.split('-');
    if (parts.length == 3) {
      return "${parts[2]}-${parts[1]}-${parts[0]}";
    } else {
      throw FormatException('Date doit être au format DD-MM-YYYY');
    }
  }
  //var numberInputFormatters = [FilteringTextInputFormatter.allow(RegExp("[0-9]")),];


  @override
  void initState() {
    super.initState();
    _fetchFournisseurs();
    //_fetchProduits();
    _datePaiementController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _dateFactureController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _sousTotalController = TextEditingController(
      text: _sousTotal?.toStringAsFixed(2) ?? '', // initialise avec _sousTotal si non nul
    );
    // Écoute les changements de texte et met à jour _sousTotal
    _sousTotalController.addListener(() {
      setState(() {
        _sousTotal = double.tryParse(_sousTotalController.text);
      });
    });
  }

  Future<void> _fetchFournisseurs() async {
    try{
      final response = await FournisseurService.fetchFournisseurs();
       setState(() {_fournisseurs = response;});
    } catch (e) {
      throw Exception('Erreur lors du chargement des fournisseurs, $e');
    }
  }
    
  //Future<void> _fetchProduits() async {
    //try {
    //  final response = await produitService.fetchProduits();
    //  setState(() {_produits = response;});
    //} catch (e) {
    //  throw Exception('Erreur lors du chargement des Produits, $e');
    //}
  //}

  Future<void> _addFournisseurs() async {
    final result = await Navigator.push(context, MaterialPageRoute( builder: (context) => AddFournisseurForm(),),);
    if (result == true) {
      setState(() {_fetchFournisseurs(); });
    }
  }
  
  //Future<void> _addProduit() async {
  //  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduitForm(),));
  //  if (result == true) {
  //    setState(() {_fetchProduits();});
  //  }
  //}

  Future<void> _addFournisseurFacture() async {
    if (_selectedFournisseur == null || _selectedStatut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs requis.')),
      );
      return;
    }

    int lastFournisseurFactureId = await _getLastFournisseurFactureId()+1;
    
    try {
      await http.post(
        Uri.parse('$apiUrl/facturefournisseur'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'facture_id': lastFournisseurFactureId,
          'fournisseur_id': _selectedFournisseur,
          'montant_total': _sousTotal,
          'statut': _selectedStatut,
          'date_facture': _dateFactureController.text,
          'date_paiement': _datePaiementController.text,
          }));
        Navigator.pop(context, true);
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la facture: $e');
    }
  }

  Future<int> _getLastFournisseurFactureId() async {
  final response = await http.get(Uri.parse('$apiUrl/facturefournisseur/facture/lastId'));
print(response.body);
  if (response.statusCode == 200) {
    if (response.body == 'null') {
      // Si la réponse est "null", cela signifie qu'il n'y a pas encore de facture
      return 0;
    }

    try {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty && data[0]['facture_id'] != null) {
        return data[0]['facture_id'];
      } else {
        // Aucun `facture_id` trouvé, retournez une valeur par défaut
        return 0;
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse du dernier facture_id: $e');
    }
  } else {
    throw Exception('Erreur lors de la récupération du dernier facture_id: ${response.body}');
  }
}


  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("fr", "FR"),
      initialDate: DateTime.now(), // Date par défaut
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void dispose() {
    _sousTotalController.dispose();
    super.dispose();
  }

  //void _updateQuantity(String value) {
  //  setState(() {
  //    _quantity = value.isNotEmpty ? int.tryParse(value) : null; 
  //  });
  //}



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          datePickerFull(_dateFactureController, context, 'Date de Facture', _selectDate),
          FournisseurDropdown(_selectedFournisseur, 'Fournisseur', _fournisseurs, (int? newValue) { setState(() { _selectedFournisseur = newValue; });},),
          actionButton( 'Créer un Fournisseur', _addFournisseurs,),
          textButtonDangerFournisseur(_fournisseurs, textDanger[0]),
          datePickerFull(_datePaiementController, context, 'Date de paiement', _selectDate),
          statutDropdown(_selectedStatut, (String? newValue) {setState(() {_selectedStatut = newValue;});}),
          //produitDropdown(_selectedProduit,'Produit', _produits,(int? newValue) {
              //setState(() {
              //  _selectedProduit = newValue;
              //  _sousTotal = _produits.firstWhere((product) => product.produitId == newValue).prix;// logiquement définir le prix en fonction du produit sélectionné;
              //  _refreshSousTotal();  // Recalculer après la sélection du produit
              //});
            //},
          //),
          //textButtonDangerProduit(_produits, textDanger[1]),
          //actionButton('Créer un produit',_addProduit,),
          //textQuantity(_quantiteController, _calculateSousTotal, _updateQuantity),
          //Text('Prix Unitaire: ${_prixUnitaire?.toStringAsFixed(2) ?? '0.00'}'),
          
          TextField(
            controller: _sousTotalController,
            decoration: InputDecoration(labelText: 'Montant'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),

          //Text('Total: ${_sousTotal?.toStringAsFixed(2) ?? '0.00'}'),
          customElevatedButton( isEnabled: _selectedFournisseur != null && _sousTotal != null, onPressed: _addFournisseurFacture, buttonText: 'Ajouter Facture'),
        ],
      ),
    );
  }
}

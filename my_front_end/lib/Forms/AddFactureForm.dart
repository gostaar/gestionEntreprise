import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/Forms/AddClientForm.dart';
import 'package:my_first_app/Forms/AddProduitForm.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Service/produit_service.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/produit.dart';
import 'package:my_first_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Widget/Rendered.dart';

class AddFactureForm extends StatefulWidget {
  @override
  _AddFactureFormState createState() => _AddFactureFormState();
}

class _AddFactureFormState extends State<AddFactureForm> {
  final TextEditingController _datePaiementController = TextEditingController();
  final TextEditingController _dateFactureController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  int? _selectedClient;
  int? _selectedProduit;
  List<Client> _clients = [];
  List<Produit> _produits = [];
  double? _prixUnitaire;
  double? _sousTotal;
  int? _quantity;
  String? _selectedStatut;
  List<String> textDanger = ['Aucun client disponible. Veuillez ajouter un client.','Aucun produit disponible. Veuillez ajouter un produit.'];
  final ProduitService produitService = ProduitService();
  String formatDate(String date) {
    List<String> parts = date.split('-');
    if (parts.length == 3) {
      return "${parts[2]}-${parts[1]}-${parts[0]}";
    } else {
      throw FormatException('Date doit être au format DD-MM-YYYY');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchClients();
    _fetchProduits();
    _datePaiementController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _dateFactureController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  Future<void> _fetchClients() async {
    try{
      final response = await ClientService.fetchClients();
       setState(() {_clients = response;});
    } catch (e) {
      throw Exception('Erreur lors du chargement des clients, $e');
    }
  }
    
  Future<void> _fetchProduits() async {
    try {
      final response = await produitService.fetchProduits();
      setState(() {_produits = response;});
    } catch (e) {
      throw Exception('Erreur lors du chargement des Produits, $e');
    }
  }

  Future<void> _addClient() async {
    final result = await Navigator.push(context, MaterialPageRoute( builder: (context) => AddClientForm(),),);
    if (result == true) {
      setState(() {_fetchClients(); });
    }
  }
  
  Future<void> _addProduit() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduitForm(),));
    if (result == true) {
      setState(() {_fetchProduits();});
    }
  }

  Future<void> _addFacture() async {
    if (_selectedClient == null || _sousTotal == null || _selectedStatut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs requis.')),
      );
      return;
    }
    int lastFactureId = await _getLastFactureId()+1;
    
    try {
      await http.post(
        Uri.parse('$apiUrl/factures'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'facture_id': lastFactureId,
          'client_id': _selectedClient,
          'montant_total': _sousTotal,
          'statut': _selectedStatut,
          'date_facture': _dateFactureController.text,
          'date_paiement': _datePaiementController.text,
          'lignes': [
            {
              'ligne_id': lastFactureId, 
              'produit_id': _selectedProduit,
              'quantite': _quantity, 
              'prix_unitaire': _prixUnitaire,
            },
          ]}));
        Navigator.pop(context, true);
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la facture: $e');
    }
  }

  Future<int> _getLastFactureId() async {
    final response = await http.get(Uri.parse('$apiUrl/factures/lastId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return data[0]['facture_id']; // Accédez au premier élément du tableau
      } else {
        throw Exception('Aucune facture trouvée.');
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

  void _updateQuantity(String value) {
    setState(() {
      _quantity = value.isNotEmpty ? int.tryParse(value) : null; 
    });
  }

  void _calculateSousTotal() {
    if (_prixUnitaire != null && _quantiteController.text.isNotEmpty) {
      int quantite = int.parse(_quantiteController.text);
      setState(() {
        _sousTotal = _prixUnitaire! * quantite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          datePickerFull(_dateFactureController, context, 'Date de Facture', _selectDate),
          clientDropdown(_selectedClient, 'Client', _clients, (int? newValue) { setState(() { _selectedClient = newValue; });},),
          actionButton( 'Créer un client', _addClient,),
          textButtonDangerClient(_clients, textDanger[0]),
          datePickerFull(_datePaiementController, context, 'Date de paiement', _selectDate),
          statutDropdown(_selectedStatut, (String? newValue) {setState(() {_selectedStatut = newValue;});}),
          produitDropdown(_selectedProduit,'Produit', _produits,(int? newValue) {
              setState(() {
                _selectedProduit = newValue;
                _prixUnitaire = _produits.firstWhere((product) => product.produitId == newValue).prix;// logiquement définir le prix en fonction du produit sélectionné;
                _calculateSousTotal();  // Recalculer après la sélection du produit
              });
            },
          ),
          textButtonDangerProduit(_produits, textDanger[1]),
          actionButton('Créer un produit',_addProduit,),
          textQuantity(_quantiteController, _calculateSousTotal, _updateQuantity),
          Text('Prix Unitaire: ${_prixUnitaire?.toStringAsFixed(2) ?? '0.00'}'),
          Text('Sous Total: ${_sousTotal?.toStringAsFixed(2) ?? '0.00'}'),
          customElevatedButton( isEnabled: _selectedClient != null && _selectedProduit != null && _quantity != null, onPressed: _addFacture, buttonText: 'Ajouter Facture'),
        ],
      ),
    );
  }
}

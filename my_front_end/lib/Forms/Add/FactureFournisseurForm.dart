import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/Forms/Add/FournisseurForm.dart';
import 'package:my_first_app/Service/fournisseurService.dart';
import 'package:my_first_app/Service/produitService.dart';
import 'package:my_first_app/Widget/customWidgets.dart';
import 'package:my_first_app/Widget/fournisseursWidgets.dart';
import 'package:my_first_app/models/fournisseursModel.dart';
import 'package:my_first_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Widget/widgets.dart';

class AddFactureFournisseurForm extends StatefulWidget {
  @override
  _AddFactureFournisseurFormState createState() => _AddFactureFournisseurFormState();
}

class _AddFactureFournisseurFormState extends State<AddFactureFournisseurForm> {
  final TextEditingController _datePaiementController = TextEditingController();
  final TextEditingController _dateFactureController = TextEditingController();
  int? _selectedFournisseur;
  List<Fournisseur> _fournisseurs = [];
  double? _sousTotal;
  late TextEditingController _sousTotalController;
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

  @override
  void initState() {
    super.initState();
    _fetchFournisseurs();
    _datePaiementController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _dateFactureController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _sousTotalController = TextEditingController(
      text: _sousTotal?.toStringAsFixed(2) ?? '', // initialise avec _sousTotal si non nul
    );
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

  Future<void> _addFournisseurs() async {
    final result = await Navigator.push(context, MaterialPageRoute( builder: (context) => AddFournisseurForm(),),);
    if (result == true) {
      setState(() {_fetchFournisseurs(); });
    }
  }
  
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
      return 0;
    }

    try {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty && data[0]['facture_id'] != null) {
        return data[0]['facture_id'];
      } else {
        return 0;
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse du dernier facture_id: $e');
    }
  } else {
    throw Exception('Erreur lors de la récupération du dernier facture_id: ${response.body}');
  }
}


  Future<void> _selectDateAdd(BuildContext context, TextEditingController controller) async {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          datePickerFullAdd(_dateFactureController, context, 'Date de Facture', _selectDateAdd),
          FournisseurDropdown(_selectedFournisseur, 'Fournisseur', _fournisseurs, (int? newValue) { setState(() { _selectedFournisseur = newValue; });},),
          actionButton( 'Créer un Fournisseur', _addFournisseurs,),
          textButtonDangerFournisseur(_fournisseurs, textDanger[0]),
          datePickerFullAdd(_datePaiementController, context, 'Date de paiement', _selectDateAdd),
          statutDropdown(_selectedStatut, (String? newValue) {setState(() {_selectedStatut = newValue;});}),
          TextField(
            controller: _sousTotalController,
            decoration: InputDecoration(labelText: 'Montant'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
          customElevatedButton( isEnabled: _selectedFournisseur != null && _sousTotal != null, onPressed: _addFournisseurFacture, buttonText: 'Ajouter Facture'),
        ],
      ),
    );
  }
}

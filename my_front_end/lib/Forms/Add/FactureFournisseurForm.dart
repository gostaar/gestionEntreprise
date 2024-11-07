import 'package:flutter/material.dart';
import 'package:my_first_app/Forms/Add/FournisseurForm.dart';
import 'package:my_first_app/Service/factureFournisseurService.dart';
import 'package:my_first_app/Service/fournisseurService.dart';
import 'package:my_first_app/Widget/FactureFournisseur/addFacturefournisseurWidgets.dart';
import 'package:my_first_app/models/fournisseursModel.dart';

class AddFactureFournisseurForm extends StatefulWidget {
  final Future<void> Function({
    required int id,
    required int fournisseurId,
    required DateTime? dateFacture,
    required double? montantTotal,
    required String? statut,
    required DateTime? datePaiement,
  }) addFactureFournisseurFunction;

  const AddFactureFournisseurForm({Key? key, required this.addFactureFournisseurFunction}) : super(key: key);

  @override
  _AddFactureFournisseurFormState createState() => _AddFactureFournisseurFormState();
}

class _AddFactureFournisseurFormState extends State<AddFactureFournisseurForm> {
  final Map<String, TextEditingController> _controllers = {
    'datePaiement': TextEditingController(),
    'dateFacture': TextEditingController(),
  };

  //contenu dropdown
  List<Fournisseur> _fournisseurs = [];
  //selected dropdown
  int? _selectedFournisseur;
  String? _selectedStatut;
  //informations additionnelles
  double? _sousTotal;

  @override
  void initState() {
    super.initState();
    _fetchFournisseurs();
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
    final result = await Navigator.push(context, MaterialPageRoute( builder: (context) => AddFournisseurForm(addFournisseurFunction: FournisseurService.addFournisseur,),),);
    if (result == true) {
      setState(() {_fetchFournisseurs(); });
    }
  }
  
  Future<void> _addFournisseurFacture() async {
    try {
      int lastFournisseurFactureId = await FactureFournisseurService.getLastFactureFournisseurId()+1;
      await widget.addFactureFournisseurFunction(
        id: lastFournisseurFactureId,
        fournisseurId: _selectedFournisseur!,
        montantTotal: _sousTotal!,
        statut: _selectedStatut!,
        dateFacture: DateTime.tryParse(_controllers['dateFacture']!.text),
        datePaiement: DateTime.tryParse(_controllers['datePaiement']!.text),
      );
      Navigator.pop(context, true);
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la facture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          addFactureFournisseurWidget (
            context,
            _controllers,
            _selectedFournisseur,
            _selectedStatut,
            _fournisseurs,
            _sousTotal,
            _selectedFournisseur != null && _sousTotal != null,
            (int? newValue) { setState(() { _selectedFournisseur = newValue; });},
            (String? newValue) {setState(() {_selectedStatut = newValue;});},
            _addFournisseurs,
            _addFournisseurFacture,
          )
        ]
      ),
    );
  }
}

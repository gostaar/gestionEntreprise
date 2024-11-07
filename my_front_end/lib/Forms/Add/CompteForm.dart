import 'package:flutter/material.dart';
import 'package:my_first_app/Service/compteService.dart';
import 'package:my_first_app/Widget/Compte/addCompteWidget.dart';

class AddCompteForm extends StatefulWidget {
  final Future<void> Function({
    required int compteId,
    required String nomCompte,
    required String typeCompte,
    required double montantDebit,
    required double montantCredit,
    required double? solde,
    required String dateCreation,
  }) addCompteFunction;

  const AddCompteForm({Key? key, required this.addCompteFunction}) : super(key: key);

  @override
  _AddCompteFormState createState() => _AddCompteFormState();
}

class _AddCompteFormState extends State<AddCompteForm> {
  Map<String, TextEditingController> _controllers = {
    'nom': TextEditingController(),
    'solde': TextEditingController(),
  };
    final Map<String, double> _variables = {
    'debit': 0.0,
    'credit': 0.0,
  };
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _selectedTypeCompte;
  
void _updateSolde() {
    final soldeText = _controllers['solde']!.text;
    if (soldeText.isNotEmpty) {
      final solde = double.tryParse(soldeText);
      if (solde != null) {
        if (_selectedTypeCompte == 'Revenu') {
          _variables['debit'] = (_variables['debit'] ?? 0.0) + solde; // Ajouter à debit
        } else if (_selectedTypeCompte == 'Dépense') {
          _variables['credit'] = (_variables['credit'] ?? 0.0) + solde; // Ajouter à credit
        }
      }
    }
  }

  Future<void> _addCompte() async {
    _isLoading = true;
    try{
      final lastCompteId = await CompteService.getLastCompteId()+1;
      await widget.addCompteFunction(
        compteId: lastCompteId,
        nomCompte: _controllers['nom']!.text,
        typeCompte: _selectedTypeCompte!,
        montantDebit: _variables['débit']!,
        montantCredit: _variables['débit']!,
        solde: double.tryParse(_controllers['solde']!.text),
        dateCreation: DateTime.now().toIso8601String(),
      );
      Navigator.pop(context, true);
      _isLoading = false;
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout du compte: $e')),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          addCompteWidget(
            _controllers,
            _variables,
            _selectedTypeCompte,
            _isLoading,
            _updateSolde,
            _addCompte,
            (newValue) => setState(() => _selectedTypeCompte = newValue),
            (newValue) => setState(() => _controllers['solde']!.text = newValue),
          ),
        ]
      ),
    );
  }
}

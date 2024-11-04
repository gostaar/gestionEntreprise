import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Forms/Add/ClientForm.dart';
//import 'package:my_first_app/Forms/Add/ProduitForm.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/Widget/client.dart';
import 'package:my_first_app/Widget/form.dart';
//import 'package:my_first_app/Service/produit_service.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/ligne_facture.dart';
//import 'package:my_first_app/models/produit.dart';

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
  TextEditingController _dateFactureController = TextEditingController();
  TextEditingController _datePaiementController = TextEditingController();
  final _quantiteController = TextEditingController();
  //int? _selectedProduit;
  //List<Client> _clients = [];
  //List<Produit> _produits = [];
  double? _prixUnitaire;
  int? quantity;
  List<String> textDanger = ['Aucun client disponible. Veuillez ajouter un client.','Aucun produit disponible. Veuillez ajouter un produit.'];
  //final ProduitService produitService = ProduitService();
  String formatDate(String date) {
    List<String> parts = date.split('-');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }else {
      throw FormatException('Date doit être au format DD-MM-YYYY');
    }
  }
    late Future<List<Client>> _clientsFuture;
    List<Client> filteredClients = [];
  TextEditingController searchController = TextEditingController();


 @override
  void initState() {
    super.initState();
    _clientsFuture = _fetchClients(); // Remplacez par votre méthode de récupération des clients
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
    
    //_selectedProduit = widget.lignesFacture.isNotEmpty ? widget.lignesFacture.first.produitId : null;
    //if (_selectedProduit != null && _produits.isNotEmpty) {
    //  try {
    //    _prixUnitaire = _produits.firstWhere((product) => product.produitId == _selectedProduit).prix;
    //  } catch (e) {
    //    _prixUnitaire = null;
    //  }
    //}

    
  }

  Future<void> _updateFacture() async {
 
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedFacture = Facture(
        id: widget.facture.id,
        clientId: int.parse(_formData['client_id']!),
        montantTotal: double.parse(_formData['montant_total']!),
        statut: _formData['statut']!,
        dateFacture: DateFormat('dd-MM-yyyy').parse(_formData['date_facture']!),
        datePaiement: DateFormat('dd-MM-yyyy').parse(_formData['date_paiement']!),
      );
    
      try {
        await FactureService.updateFacture(updatedFacture);
        Navigator.pop(context, true); // Ferme le formulaire
      } catch (error) {
        _showError(context, 'Erreur lors de la mise à jour de la facture: $error');
      }
    }
  }

  Future<List<Client>> _fetchClients() async {
  try {
    return await ClientService.fetchClients();
  } catch (e) {
    _showError(context, 'Erreur lors de la récupération des clients: $e');
    return []; // Return an empty list on error
  }
}

  //Future<void> _fetchProduits() async {
  // try {
  //    final response = await produitService.fetchProduits();
  //    setState(() {_produits = response;});
  //  } catch (e) {
   //   throw Exception('Erreur lors du chargement des Produits, $e');
   // }
  //}

  Future<void> _addClient() async {
    final result = await Navigator.push(context, MaterialPageRoute( builder: (context) => AddClientForm(),),);
    if (result == true) {
      setState(() {_fetchClients(); });
    }
  }
  
  //Future<void> _addProduit() async {
  //  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduitForm(),));
  //  if (result == true) {
  //    setState(() {_fetchProduits();});
  //  }
  //}

   Future<void> _selectDate(BuildContext context, TextEditingController controller, String fieldName) async {
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
        _formData[fieldName] = controller.text;
      });
    }
  }

    void _updateQuantity(String value) {
    setState(() {
      quantity = value.isNotEmpty ? int.tryParse(value) : null; 
    });
  }

  void _calculateSousTotal() {
    if (_prixUnitaire != null && _quantiteController.text.isNotEmpty) {
      int quantite = int.parse(_quantiteController.text);
          double montantTotal = _prixUnitaire! * quantite;
      setState(() {
        _formData['montant_total'] = montantTotal.toString();
      });
    }
  }

  void _showError(BuildContext context, String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

  @override
  Widget build(BuildContext context) {
        return FutureBuilder<List<Client>>(
      future: _clientsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Indicateur de chargement
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun client disponible'));
        } else {
          List<Client> _clients = snapshot.data!;
          int? clientId = _formData['client_id'] != null ? int.tryParse(_formData['client_id']!) : null;
        
        // Vérifiez si le client_id est valide et existe dans la liste
        if (clientId != null && !_clients.any((client) => client.clientId == clientId)) {
          clientId = null; // Réinitialiser si le client n'existe plus
          //_formData['client_id'] = null; // Optionnel, pour garder les données à jour
        }
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  datePickerFull(_dateFactureController, context, 'Date de Facture','date_facture', _selectDate),
                  clientDropdown(int.parse(_formData['client_id']!), 'Client', _clients, (int? newValue) {
                    setState(() {
                      _formData['client_id'] = newValue.toString(); // Mettez à jour votre Map avec la nouvelle valeur
                    });
                  }),
                  actionButton('Créer un client', _addClient),
                  textButtonDangerClient(_clients, textDanger[0]),
                  datePickerFull(_datePaiementController, context, 'Date de paiement', 'date_paiement', _selectDate),
                  //statutDropdown(_formData['statut'], (String? newValue) {setState(() {_formData['statut'] = newValue!;});}),
                  //produitDropdown(_selectedProduit, 'Produit', _produits, (int? newValue) {
                  //  setState(() {
                  //    _selectedProduit = newValue;
                  //    if (_produits.isNotEmpty) {
                  //      _prixUnitaire = _produits.firstWhere((product) => product.produitId == newValue).prix;
                  //    }
                  //    _calculateSousTotal();
                  //  });
                  //}),
                  //textButtonDangerProduit(_produits, textDanger[1]),
                  //actionButton('Créer un produit', _addProduit),
                  //textQuantity(_quantiteController, _calculateSousTotal, _updateQuantity),
                  //Text('Prix Unitaire: ${_prixUnitaire?.toStringAsFixed(2) ?? 'indisponible'}'),
                  //Text('Sous Total: ${double.parse(_formData['montant_total']!).toStringAsFixed(2)}'),
                   customElevatedButton(
                    //isEnabled: _formData['client_id'] != null && _selectedProduit != null && _quantiteController.text.isNotEmpty,
                    isEnabled: _formData['client_id'] != null ,
                    onPressed: _updateFacture,
                    buttonText: 'Enregistrer'
                  ),
                ],
              ),
            ),
          );
        }
      }
    );
  }
}
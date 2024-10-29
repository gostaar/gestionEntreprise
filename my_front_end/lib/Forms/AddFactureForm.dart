import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/Forms/AddClientForm.dart';
import 'package:my_first_app/Forms/AddProduitForm.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/produit.dart';
import 'package:my_first_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Widget/AddFacture.dart';

class AddFactureForm extends StatefulWidget {
  @override
  _AddFactureFormState createState() => _AddFactureFormState();
}

class _AddFactureFormState extends State<AddFactureForm> {
  
  //variables
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

  @override
  void initState() {
    super.initState();
    _fetchClients();
    _fetchProduits();
    _datePaiementController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    _dateFactureController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  //fonctions
  Future<void> _fetchClients() async {
    final response = await http.get(Uri.parse('$apiUrl/clients'));

    if (response.statusCode == 200) {
      List<dynamic> clientsJson = json.decode(response.body);
      print('Clients fetched: $clientsJson'); // Ajout d'un log
      setState(() {
        _clients = (json.decode(response.body) as List)
            .map<Client>((json) => Client.fromJson(json))
            .toList();
      });
    } else {
      print(
          'Failed to load clients: ${response.statusCode} ${response.body}'); // Log d'erreur
      throw Exception('Erreur lors du chargement des clients');
    }
  }

  Future<void> _fetchProduits() async {
    final response = await http.get(Uri.parse('$apiUrl/produits'));

    if (response.statusCode == 200) {
      List<dynamic> produitsJson = json.decode(response.body);
      setState(() {
        _produits = (json.decode(response.body) as List)
            .map<Produit>((json) => Produit.fromJson(json))
            .toList();
      });


    } else {
      // En cas d'erreur, on lève une exception
      print('Failed to load produits: ${response.statusCode} ${response.body}');
      throw Exception('Erreur lors du chargement des Produits');
    }
  }

  Future<void> _AddClient() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddClientForm(),
      ),
    );

    if (result == true) {
      setState(() {
        _fetchClients(); // Appel de la fonction pour recharger les clients
      });
    }
  }
  
  Future<void> _AddProduit() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddProduitForm(),
        ));
    if (result == true) {
      setState(() {
        _fetchProduits();
      });
    }
  }

  Future<void> _addFacture() async {
    if (_selectedClient == null || _sousTotal == null || _selectedStatut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs requis.')),
      );
      return;
    }
    int lastFactureId = await _getLastFactureId() +1;
    double sousTotal = _prixUnitaire! * _quantity!;
    final dateFactureFormatted = formatDate(_dateFactureController.text);
    final datePaiementFormatted = formatDate(_datePaiementController.text);
      
    final response = await http.post(
      Uri.parse('$apiUrl/factures'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'facture_id': lastFactureId,
        'client_id': _selectedClient,
        'montant_total': _sousTotal,
        'statut': _selectedStatut,
        'date_facture': dateFactureFormatted,
        'date_paiement': datePaiementFormatted,
        'lignes': [
          {
            'ligne_id': lastFactureId, 
            'produit_id': _selectedProduit,
            'quantite': _quantity, 
            'prix_unitaire': _prixUnitaire,

          },
        ]}));

    if (response.statusCode == 201) {
    
      final Map<String, dynamic> facture = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Facture ajoutée avec succès!')),
      );
      Navigator.pop(context, true); 
    } else {
      throw Exception('Erreur lors de l\'ajout de la facture: ${response.body}');
    }
  }

  Future<void> _addLignesFacture(int factureId) async {
    try {
      final lastProduitId = await _getLastProduitId();
      final newProduitId = lastProduitId + 1;

      // Vérifiez que _selectedProduit et _prixUnitaire ne sont pas nulls
      if (_selectedProduit == null) {
        throw Exception('Le produit doit être sélectionné.');
      }

      if (_prixUnitaire == null) {
        throw Exception('Le prix unitaire doit être renseigné.');
      }

      // Vérifiez et parsez la quantité
      int quantity;
      try {
        quantity = int.parse(_quantiteController.text);
      } catch (e) {
        throw Exception('La quantité doit être un nombre valide.');
      }

      // Calcul du sous-total
      double sousTotal = _prixUnitaire! * quantity;

      // Effectuer la requête pour ajouter la ligne de facture
      final response = await http.post(
        Uri.parse('$apiUrl/lignesFactures'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ligne_id': newProduitId,
          'facture_id': factureId,
          'produit_id': _selectedProduit,
          'quantite': quantity,
          'prix_unitaire': _prixUnitaire,
          'sous_total': sousTotal,
        }),
      );

      // Vérifiez le code de statut de la réponse
      if (response.statusCode != 201) {
        throw Exception(
            'Erreur lors de l\'ajout des lignes de facture: ${response.body}');
      }
    } catch (e) {
      // Gérer les erreurs ici (affichage, logging, etc.)
      print('Erreur lors de l\'ajout de lignes de facture: $e');
      throw Exception('Erreur lors de l\'ajout de lignes de facture: $e');
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

  Future<int> _getLastProduitId() async {
    final response = await http.get(Uri.parse('$apiUrl/Produits'));

    if (response.statusCode == 200) {
      final List<dynamic> Produits = jsonDecode(response.body);

      // Étape 3 : Récupérer l'ID maximum
      if (Produits.isNotEmpty) {
        final maxId = Produits.map((Produit) => Produit['ProduitId'])
            .cast<int>()
            .reduce((a, b) => a > b ? a : b);
        return maxId;
      }
    }

    return 0; // Si aucun Produit n'existe, retournez 0
  }

  String formatDate(String date) {
    // Supposons que la date est entrée au format "DD-MM-YYYY"
    List<String> parts = date.split('-');
    if (parts.length == 3) {
      // Retourner au format "YYYY-MM-DD"
      return "${parts[2]}-${parts[1]}-${parts[0]}";
    } else {
      throw FormatException('Date doit être au format DD-MM-YYYY');
    }
  }

  void _updateQuantity(String value) {
    setState(() {
      // Essaye de convertir la valeur en entier
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
          actionButton( 'Créer un client', _AddClient,),
          textButtonDangerClient(_clients, textDanger[0]),
          datePickerFull(_datePaiementController, context, 'Date de paiement', _selectDate),
          statutDropdown(_selectedStatut, (String? newValue) {setState(() {_selectedStatut = newValue;});}),
          produitDropdown(_selectedProduit,'Produit', _produits,(int? newValue) {
              setState(() {
                _selectedProduit = newValue;
                _prixUnitaire = _produits.firstWhere((product) => product.produitId == newValue).prix;;// logiquement définir le prix en fonction du produit sélectionné;
                _calculateSousTotal();  // Recalculer après la sélection du produit
              });
            },
          ),
          textButtonDangerProduit(_produits, textDanger[1]),
          actionButton('Créer un produit',_AddProduit,),
          textQuantity(_quantiteController, _calculateSousTotal, _updateQuantity),
          Text('Prix Unitaire: ${_prixUnitaire?.toStringAsFixed(2) ?? '0.00'}'),
          Text('Sous Total: ${_sousTotal?.toStringAsFixed(2) ?? '0.00'}'),
          customElevatedButton( isEnabled: _selectedClient != null && _selectedProduit != null && _quantity != null, onPressed: _addFacture, buttonText: 'Ajouter Facture'),
        ],
      ),
    );
  }
}

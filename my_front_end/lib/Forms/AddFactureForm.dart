import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/Forms/AddClientForm.dart';
import 'package:my_first_app/Forms/AddProduitForm.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/produit.dart';
import 'package:my_first_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_first_app/_style.dart';

class AddFactureForm extends StatefulWidget {
  @override
  _AddFactureFormState createState() => _AddFactureFormState();
}

class _AddFactureFormState extends State<AddFactureForm> {
  //final TextEditingController _clientController = TextEditingController();
  final TextEditingController _datePaiementController = TextEditingController();
  final TextEditingController _dateFactureController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();

  int? _selectedClient;
  int? _selectedProduit;
  List<Client> _clients = [];
  List<Produit> _produits = [];
  double? _prixUnitaire;
  double? _sousTotal;
  final List<Map<String, dynamic>> _lignesFacture = [];

  List<String> _statuts = ['Non Payée', 'Payée', 'En Cours'];
  String? _selectedStatut;
  String dangerClient = 'Aucun client disponible. Veuillez ajouter un client.';
  String dangerProduit =
      'Aucun produit disponible. Veuillez ajouter un produit.';
  String clientButton = 'Créer un client';
  String produitButton = 'Créer un produit';

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

      print("Produits fetched: $produitsJson");
    } else {
      // En cas d'erreur, on lève une exception
      print('Failed to load produits: ${response.statusCode} ${response.body}');
      throw Exception('Erreur lors du chargement des Produits');
    }
  }

  void _calculateSousTotal() {
    if (_prixUnitaire != null && _quantiteController.text.isNotEmpty) {
      int quantite = int.parse(_quantiteController.text);
      setState(() {
        _sousTotal = _prixUnitaire! * quantite;
      });
    }
  }

  Future<void> _addFacture() async {
    // Étape 1 : Ajouter la facture
    final response = await http.post(
      Uri.parse('$apiUrl/factures'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'client_id': _selectedClient,
        'montant_total': _sousTotal,
        'statut': _selectedStatut,
        'date_facture': _dateFactureController.text,
        'date_paiement': _datePaiementController.text,
        // Notez que nous n'incluons pas 'lignes' ici
      }),
    );

    if (response.statusCode == 201) {
      // Vérifiez si la facture a été créée
      final Map<String, dynamic> facture = json.decode(response.body);
      int factureId = facture[
          'id']; // Assurez-vous que 'id' correspond à la clé de l'ID dans votre réponse

      // Étape 2 : Ajouter les lignes de facture
      await _addLignesFacture(factureId);
    } else {
      throw Exception(
          'Erreur lors de l\'ajout de la facture: ${response.body}');
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

  Future<void> _addLignesFacture(int factureId) async {
    final lastProduitId = await _getLastProduitId();
    final newProduitId = lastProduitId + 1;
    final response = await http.post(
      Uri.parse('$apiUrl/lignesFactures'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ligne_id': newProduitId,
        'facture_id': factureId,
        'produit_id': _selectedProduit,
        'quantite': int.parse(_quantiteController.text),
        'prix_unitaire': _prixUnitaire,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Erreur lors de l\'ajout des lignes de facture: ${response.body}');
    }
  }

  void _updatePrixUnitaire(String? produitId) {
    // Logique pour récupérer le prix unitaire du produit sélectionné
    // Vous devez adapter cette méthode en fonction de votre API
    if (produitId != null) {
      // Exemple fictif: utilisez une requête pour obtenir le prix
      // Remplacez ceci par la logique d'obtention du prix unitaire
      _prixUnitaire = 100.0; // Remplacer par la valeur réelle
      _calculateSousTotal(); // Mettre à jour le sous-total
    }
  }

  Future<void> _AddClient() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddClientForm(),
      ),
    );

    // Si le formulaire de client a renvoyé "true", on actualise la liste des clients
    if (result == true) {
      setState(() {
        // Recharge la liste des clients
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("fr", "FR"),
      initialDate: DateTime.now(), // Date par défaut
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Mettre à jour le TextField avec la date sélectionnée
      setState(() {
        _datePaiementController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            datePickerFull(_dateFactureController, context, _selectDate),
            clientDropdown(
              _selectedClient,
              'Client',
              _clients,
              (int? newValue) {
                setState(() {
                  _selectedClient = newValue;
                });
              },
            ),
            actionButton(
              clientButton,
              _AddClient,
            ),
            textButtonDangerClient(_clients, dangerClient),
            datePickerFull(_datePaiementController, context, _selectDate),
            DropdownButtonFormField<String>(
              value: _selectedStatut,
              decoration: InputDecoration(labelText: 'Statut'),
              items: _statuts.map((String statut) {
                return DropdownMenuItem<String>(
                  value: statut,
                  child: Text(statut),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatut = newValue;
                });
              },
            ),
            // Dropdown pour les Produits
            produitDropdown(
              _selectedProduit,
              'Produit',
              _produits,
              (int? newValue) {
                setState(() {
                  _selectedProduit = newValue;
                });
              },
            ),
            textButtonDangerProduit(_produits, dangerProduit),
            actionButton(
              produitButton,
              _AddProduit,
            ),
            // Champ de Quantité
            TextField(
              controller: _quantiteController,
              decoration: InputDecoration(labelText: 'Quantité'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _calculateSousTotal();
              },
            ),
            Text(
                'Prix Unitaire: ${_prixUnitaire?.toStringAsFixed(2) ?? '0.00'}'),
            Text('Sous Total: ${_sousTotal?.toStringAsFixed(2) ?? '0.00'}'),
            ElevatedButton(
              onPressed: (_selectedClient == null || _selectedProduit == null)
                  ? null // Désactiver le bouton si aucun client ou produit sélectionné
                  : _addFacture,
              child: Text('Ajouter Facture'),
            ),
          ],
        ),
      ),
    );
  }
}

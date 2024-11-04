import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/Forms/Add/FactureForm.dart';
import 'package:my_first_app/Pages/Details/detailsFacture.dart';
import 'package:my_first_app/Widget/dialogs.dart';

class FacturesPage extends StatefulWidget {
  @override
  _FacturesPageState createState() => _FacturesPageState();
}

class _FacturesPageState extends State<FacturesPage> {
  List<Facture> _factures = [];
   List<Facture> _filteredFactures = []; // Pour afficher les factures filtrées
  final TextEditingController _searchController = TextEditingController();
  Map<int, Client> clients = {};
  final factureService = FactureService();

  @override
  void initState() {
    super.initState();
    _refreshFactures();
        _searchController.addListener(_filterFactures);

  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  Future<void> _refreshFactures() async {
    try {      
      final factures = await factureService.fetchFactures();
      setState(() {
        _factures = factures;
        _filteredFactures = factures;

      });
    } catch (error) {
      _showError(context, 'Erreur lors de la récupération des factures: $error');
    }
  }

  void _filterFactures() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      final priceQuery = double.tryParse(query); // Essaie de convertir le texte en double
      setState(() {
        _filteredFactures = _factures.where((facture) {
        // Vérifie si le nom du produit contient la recherche ou si le prix contient la recherche
        return facture.id.toString().contains(query) || 
               (priceQuery != null && facture.montantTotal.toString().contains(query));
      }).toList();
      });
    } else {
      setState(() {
        _filteredFactures = _factures;
      });
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

  void _openAddFactureForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddFactureForm(),
      ),
    ).then((_) => _refreshFactures());
  }

  void _navigateToDetailPage(BuildContext context, Facture facture) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final lignesFactureData = await factureService.getLignesFacture(facture.id);
      final client = await ClientService.getClientById(facture.clientId);

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FactureDetailPage(
            facture: facture,
            client: client,
            lignesFacture: lignesFactureData,
          ),
        ),
      );
    } catch (error) {
      Navigator.pop(context);
      _showError(context, 'Erreur lors de la récupération des données: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Factures'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Numéro / Prix',
                hintStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      ),
      body: _filteredFactures.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredFactures.length,
              itemBuilder: (context, index) {
                final facture = _filteredFactures[index];
                String formattedPrice = facture.montantTotal != null 
                  ? NumberFormat.simpleCurrency(locale: 'fr_FR').format(facture.montantTotal)
                  : 'Indisponible';
                return ListTile(
                  title: Text('Numéro de Facture: ${facture.id}'),
                  subtitle: Text('Statut: ${facture.statut ?? 'Non renseigné'}\nMontant: $formattedPrice'),
                  onTap: () => _navigateToDetailPage(context, facture),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddFactureForm(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

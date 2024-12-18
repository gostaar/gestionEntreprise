import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Forms/Add/FactureFournisseurForm.dart';
import 'package:my_first_app/Pages/Details/factureFournisseurPageDetails.dart';
import 'package:my_first_app/Service/factureFournisseurService.dart';
import 'package:my_first_app/Service/fournisseurService.dart';
import 'package:my_first_app/models/fournisseursModel.dart';
import 'package:my_first_app/models/factureFournisseurModel.dart';

class FactureFournisseurPage extends StatefulWidget {
  @override
  _FactureFournisseurPageState createState() => _FactureFournisseurPageState();
}

class _FactureFournisseurPageState extends State<FactureFournisseurPage> {
  List<FactureFournisseur> _factures = [];
  List<FactureFournisseur> _filteredFactures = [];
  final TextEditingController _searchController = TextEditingController();
  //bool _isLoading = true;  // Indicateur de chargement

  final factureFournisseurService = FactureFournisseurService();

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
    //setState(() {
    //  _isLoading = true; // Début du chargement
    //});
    try {
      final factures = await FactureFournisseurService.fetchFactureFournisseur();
      if(mounted){setState(() {
        _factures = factures;
        _filteredFactures = factures;
        //_isLoading = false; // Fin du chargement
      });}
    } catch (e) {
      //setState(() {
      //  _isLoading = false; // Fin du chargement en cas d’erreur
      //});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la récupération des factures: $e')),);
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

  void _openAddFactureFournisseurForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddFactureFournisseurForm(createFactureFournisseurFunction: FactureFournisseurService.createFactureFournisseur,),
      ),
    ).then((_) => _refreshFactures());
  }

  void _navigateToDetailPage(BuildContext context, FactureFournisseur facture) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      Fournisseur fournisseur = await FournisseurService.getFournisseursById(facture.fournisseurId);

      Navigator.of(context).pop(); // Close the loading dialog

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FactureFournisseurDetailPage(
            factures: [facture],
            fournisseur: fournisseur,
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la récupération des données: $e')),);
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
              ? Center(child:Text('Aucune facture \nfournisseur disponible',))
              : ListView.builder(
                  itemCount: _factures.length,
                  itemBuilder: (context, index) {
                    final facture = _factures[index];
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
        onPressed: () => _openAddFactureFournisseurForm(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

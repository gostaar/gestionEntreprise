import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/Details/detailsFournisseurs.dart';
import 'package:my_first_app/Service/facture_fournisseur_service.dart';
import 'package:my_first_app/Service/fournisseur_service.dart';
import 'package:my_first_app/Widget/dialogs.dart';
import 'package:my_first_app/Widget/modales.dart';
import 'package:my_first_app/models/fournisseurs.dart';
import 'package:my_first_app/models/factureFournisseur.dart';

class FournisseurPage extends StatefulWidget {
  @override
  _FournisseurPageState createState() => _FournisseurPageState();
}

class _FournisseurPageState extends State<FournisseurPage> {
  List<Fournisseur> _fournisseur = [];
  List<Fournisseur> _filteredFournisseurs = [];
  final factureFournisseurService = FactureFournisseurService();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true; // Indicateur pour le chargement

  @override
  void initState() {
    super.initState();
    _loadFournisseurs();
        _searchController.addListener(_filterFournisseurs); // Ajout de l'écouteur pour le champ de recherche

  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadFournisseurs() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fournisseursList = await FournisseurService.fetchFournisseurs();
      setState(() {
        _fournisseur = fournisseursList;
                _filteredFournisseurs = fournisseursList; // Initialisation de la liste filtrée

      });
    } catch (error) {
      _showError(context, 'Erreur lors du chargement des fournisseurs: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

   void _filterFournisseurs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFournisseurs = _fournisseur.where((fournisseur) {
        final fullName = '${fournisseur.nom} ${fournisseur.prenom}'.toLowerCase();
        return fullName.contains(query);
      }).toList();
    });
  }

  void _openDetailsFournisseur(BuildContext context, Fournisseur fournisseur) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      print(fournisseur.fournisseurId);

      final List<FactureFournisseur> facturesFournisseur = 
          await FactureFournisseurService.getFactureFournisseurByFournisseurId(fournisseur.fournisseurId);
      
      Navigator.pop(context);

      
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FournisseurDetailPage(
              factures: facturesFournisseur,
              fournisseur: fournisseur,
            ),
          ),
        );
      
    } catch (error) {
      Navigator.pop(context);
      _showError(context, 'Erreur lors de la récupération des factures: $error');
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

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fournisseurs'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nom / Prénom',
                hintStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredFournisseurs.isEmpty
              ? Center(child: Text('Aucun fournisseur trouvé.'))
              : ListView.builder(
                  itemCount: _filteredFournisseurs.length,
                  itemBuilder: (context, index) {
                    final fournisseur = _filteredFournisseurs[index];
                    return ListTile(
                      title: Text('${fournisseur.nom} ${fournisseur.prenom}'),
                      subtitle: Text(fournisseur.email ?? ""),
                      onTap: () => _openDetailsFournisseur(context, fournisseur),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return const AddFournisseurModal();
            },
          );
          if (result == true) {
            _loadFournisseurs();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

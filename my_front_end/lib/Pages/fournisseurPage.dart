import 'package:flutter/material.dart';
import 'package:my_first_app/Forms/Add/FournisseurForm.dart';
import 'package:my_first_app/Pages/Details/fournisseursPageDetails.dart';
import 'package:my_first_app/Service/factureFournisseurService.dart';
import 'package:my_first_app/Service/fournisseurService.dart';
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/fournisseursModel.dart';
import 'package:my_first_app/models/factureFournisseurModel.dart';

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
    if(mounted){setState(() {_isLoading = true;});}
    try {
      final fournisseursList = await FournisseurService.fetchFournisseurs();
      if(mounted){setState(() {
        _fournisseur = fournisseursList;
        _filteredFournisseurs = fournisseursList;
      });}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors du chargement des fournisseurs: $e')),);
    } finally {
      if(mounted){setState(() {_isLoading = false;});}
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
      final List<FactureFournisseur> facturesFournisseur = await FactureFournisseurService.getFactureFournisseurByFournisseurId(fournisseur.fournisseurId);
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
      
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la récupération des factures: $e')),);
    }
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
          try {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
              return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AddFournisseurForm(createFournisseurFunction: FournisseurService.createFournisseur,),
                );
              },
            );
            _loadFournisseurs();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout du fournisseur: $e')),);
          };
        },
        child: Icon(Icons.add),
        backgroundColor: customColors['blue'],
      ),
    );
  }
}

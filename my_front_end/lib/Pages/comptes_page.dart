import 'package:flutter/material.dart';
import 'package:my_first_app/Forms/AddCompteForm.dart';
import 'package:my_first_app/Service/compte_service.dart';
import 'package:my_first_app/models/compte.dart'; 

class ComptesPage extends StatefulWidget {
  @override
  _ComptesPageState createState() => _ComptesPageState();
}

class _ComptesPageState extends State<ComptesPage> {
  List<Compte> comptes = []; 
  final CompteService compteService = CompteService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComptes();
  }

  Future<void> fetchComptes() async {
    try {
      final fetchedComptes = await compteService.fetchComptes();
      setState(() {
        comptes = fetchedComptes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur lors du chargement des comptes : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comptes'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) 
          : comptes.isEmpty
              ? Center(child: Text('Aucun compte disponible'))
              : ListView.builder(
                  itemCount: comptes.length,
                  itemBuilder: (context, index) {
                    final compte = comptes[index];
                    return ListTile(
                      title: Text('${compte.nomCompte} ${compte.typeCompte}'), 
                      subtitle: Text('${compte.solde} €'), 
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: AddCompteForm(), 
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

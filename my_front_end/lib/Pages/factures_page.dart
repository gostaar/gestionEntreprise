import 'package:flutter/material.dart';
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/Service/client_service.dart';
import 'package:my_first_app/Service/facture_service.dart';
import 'package:my_first_app/Forms/AddFactureForm.dart';
import 'package:my_first_app/Pages/detailsFacture.dart';
import 'package:my_first_app/Widget/Functions.dart';

class FacturesPage extends StatefulWidget {
  @override
  _FacturesPageState createState() => _FacturesPageState();
}

class _FacturesPageState extends State<FacturesPage> {
  List<Facture> _factures = [];
  Map<int, Client> clients = {};
  final factureService = FactureService();

  @override
  void initState() {
    super.initState();
    _refreshFactures();
  }

  Future<void> _refreshFactures() async {
    try {
      final factureService = FactureService();
      final factures = await factureService.fetchFactures();
      setState(() {
        _factures = factures;
      });
    } catch (error) {
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
      appBar: AppBar(title: Text('Factures')),
      body: _factures.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _factures.length,
              itemBuilder: (context, index) {
                final facture = _factures[index];
                return ListTile(
                  title: Text('Numéro de Facture: ${facture.id}'),
                  subtitle: Text('Statut: ${facture.statut}'),
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

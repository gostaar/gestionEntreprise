import 'package:flutter/material.dart';
import 'package:my_first_app/Pages/Details/factureDetails.dart';
import 'package:my_first_app/Service/clientService.dart';
import 'package:my_first_app/Service/factureService.dart';
import 'package:my_first_app/Widget/Client/BuildFactureTabWidget.dart';
import 'package:my_first_app/Widget/Client/updateClientWidget.dart';
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/models/factureModel.dart';
import 'package:my_first_app/models/ligneFactureModel.dart';

class ClientDetailPage extends StatefulWidget {
  final Client client; 
  final List<Facture> factures;

  const ClientDetailPage({
    required this.client,
    required this.factures,
  });

  @override
  _ClientDetailPageState createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> with SingleTickerProviderStateMixin {
  Map<String, dynamic> _formData = {};
  final Map<String, TextEditingController> controllers = {};
  
  String _getFieldValue(String field) { return _formData[clientFormData].toJson()[field] ?? '';}
  
  bool isEditing = false;
  late TabController _tabController;
  int _previousTabIndex = -1;
  bool isClientLoaded = false;  

  @override
  void initState() {
    super.initState();
    _formData = {
      clientFormData: widget.client,
      factureFormData: widget.factures,
    };

    // Initialiser les contrôleurs de texte
    for (var field in clientFields) {
      controllers[field] = TextEditingController(text: _getFieldValue(field));
    }

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _previousTabIndex) {
        setState(() {
          _previousTabIndex = _tabController.index;
        });
      }
    });

    if (widget.client != null) {
      setState(() {
        isClientLoaded = true;
      });
    } else {
      _loadClientData();
    }
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose()); 
    _tabController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      if (isEditing) _updateClient();
      isEditing = !isEditing;
    });
  }
  
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }

  Future<List<LigneFacture>> _fetchLignesFacture(int factureId) async {
    return await FactureService().getLignesFacture(factureId);
  }

  Future<void> _loadClientData() async {
    try {
      final client = await ClientService.getClientById(widget.client.clientId);
      setState(() {
        _formData[clientFormData] = client;
        isClientLoaded = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors du chargement des données client: $e')));
    }
  }

  void _updateClient() async {
    final updatedClientData = controllers.map((key, controller) {return  MapEntry(key, controller.text);});
   
    final updatedClient = _formData[clientFormData].copyWith(
      nom: updatedClientData[nomField] ?? _formData[clientFormData].nom,
      prenom: updatedClientData[prenomField] ?? _formData[clientFormData].prenom,
      email: updatedClientData[emailField] ?? _formData[clientFormData].email,
      telephone: updatedClientData[telephoneField] ?? _formData[clientFormData].telephone,
      adresse: updatedClientData[adresseField] ?? _formData[clientFormData].adresse,
      ville: updatedClientData[villeField] ?? _formData[clientFormData].ville,
      codePostal: updatedClientData[codePostalField] ?? _formData[clientFormData].codePostal,
      pays: updatedClientData[paysField] ?? _formData[clientFormData].pays,
      numeroTva: updatedClientData[tvaField] ?? _formData[clientFormData].numeroTva,
    ); 
    try {
      await ClientService.updateClient(updatedClient);
      final reloadedClient = await ClientService.getClientById(updatedClient.clientId);
      if(mounted){setState(() {_formData[clientFormData] = reloadedClient;});}
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Client mis à jour avec succès')),);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la mise à jour du client: $e')),);
    }
  }

  void _navigateToFacturesPage(BuildContext context, Facture f) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final lignesFacture = await _fetchLignesFacture(f.factureId);
      final clientDetails = await ClientService.getClientById(f.clientId);
      Navigator.pop(context);
      _navigateTo(
        context,
        FactureDetailPage(
          facture: f,
          lignesFacture: lignesFacture,
          client: clientDetails,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la récupération des factures: $e')),);
    }
  }

  @override
  Widget build(BuildContext context) {
     if (!isClientLoaded) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Fiche de ${_formData[clientFormData].nom}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: tabDetails),
            Tab(text: tabFacture),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                updateDetailWidget(
                  controllers,
                  isEditing,
                ),
                buildFacturesTab(
                  context,
                  _formData[factureFormData],
                  _navigateToFacturesPage,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
        ? FloatingActionButton(
            onPressed: _toggleEditMode,
            child: Icon(isEditing ? Icons.save : Icons.edit),
            backgroundColor: Colors.blue,
          )
        : null,
    );
  }
}



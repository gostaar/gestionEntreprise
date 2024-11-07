import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/factureModel.dart';
import 'package:my_first_app/models/ligneFactureModel.dart';

class FactureService {

  Future<List<Facture>> fetchFactures() async {
    final response = await http.get(Uri.parse('$apiUrl/factures'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((facture) => Facture.fromJson(facture)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des factures');
    }
  }

   static Future<int> getLastFactureId() async {
    final response = await http.get(Uri.parse('$apiUrl/factures/lastId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return data[0]['facture_id'];
      } else {
        throw Exception('Aucune facture trouvée.');
      }
    } else {
      throw Exception('Erreur lors de la récupération du dernier facture_id: ${response.body}');
    }
  }

  Future<List<LigneFacture>> getLignesFacture(int factureId) async {
  try {
    final response = await _getData('$apiUrl/lignesfactures/$factureId');
    if (response != null && response is List) {
      final lignes = response
          .map((ligne) => LigneFacture.fromJson(ligne as Map<String, dynamic>))
          .toList();
      return lignes;
    } else {
      return [];
    }
  } catch (e) {
    throw Exception('Erreur lors de la récupération des lignes de facture: $e');
  }
}


  Future<dynamic> _getData(String url) async {
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des données: ${response.statusCode}');
    }
  }

  static Future<List<Facture>> getFacturesByClientId(int clientId) async {
    final response = await http.get(Uri.parse('$apiUrl/factures/client/$clientId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((facture) => Facture.fromJson(facture)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des factures');
    }
  }

  static Future<Facture> getFactureById(int factureId) async {
    final response = await http.get(Uri.parse('$apiUrl/factures/$factureId'));

    if(response.statusCode == 200) {
      final data = json.decode(response.body);
      return Facture.fromJson(data);
    } else {
      throw Exception('Erreur lors de la récupération de la facture: ${response.statusCode}');
    }
  }

   static Future<void> updateFacture(Facture facture) async {
    final response = await http.patch(
      Uri.parse('$apiUrl/factures/${facture.factureId}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'client_id': facture.clientId,
        'date_facture': facture.dateFacture,
        'montant_total': facture.montantTotal,
        'statut': facture.statut,
        'date_paiement': facture.datePaiement,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour de la facture');
    }
  }

  static Future<int> getLastLigneId() async {
    final response = await http.get(Uri.parse('$apiUrl/lignesfactures/lastId'));
    
    if(response.statusCode == 200){
      List<dynamic> data = json.decode(response.body);
      if(data.isNotEmpty){
        return data[0]['ligne_id'];
      } else {
        throw Exception('Aucune ligne de facture trouvée');
      }
    } else {
      throw Exception('Erreur lors de la récupération des lignes factures');
    }
  }

  static Future<void> addFacture({
    required int factureId,
    required int clientId,
    required double? montantTotal,
    required String? statut,
    required DateTime? dateFacture,
    required DateTime? datePaiement,
  }) async {
    try {
      await http.post(
        Uri.parse('$apiUrl/factures'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'facture_id': factureId,
          'client_id': clientId,
          'date_facture': dateFacture,
          'montant_total': montantTotal,
          'statut': statut,
          'date_paiement': datePaiement,
        }),
      );
     
      
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la facture: $e');
    }
  } 
  
  static Future<void> addLigneFacture({
    required int ligneId,
    required int factureId,
    required int produitId,
    required int quantite,
    required double prixUnitaire,
  }) async {
    try{
      await http.post(
      Uri.parse('$apiUrl/lignesfactures'),
      headers:{'Content-Type': 'application/json'},
      body: jsonEncode({
        'ligne_id': ligneId,
        'facture_id': factureId,
        'produit_id': produitId,
        'quantite': quantite,
        'prix_unitaire': prixUnitaire,
        'sous_Total': quantite*prixUnitaire,
      }));
    } catch (e){
      throw Exception('Erreur lors de l\'ajout de la ligne de facture: $e');
    }
  }
}
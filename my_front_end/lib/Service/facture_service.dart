import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/ligne_facture.dart';

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

  Future<List<LigneFacture>> getLignesFacture(int factureId) async {
    try {
      final response = await _getData('$apiUrl/lignesfactures/$factureId');
      
      if (response != null) {
        final lignes = (response as List)
            .map((ligne) => LigneFacture.fromJson(ligne as Map<String, dynamic>))
            .toList();
        return lignes;
      } else {
        return [];
      }
    } catch (e) {
      print('Erreur lors de la récupération des lignes de facture: $e');
      return [];
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
}

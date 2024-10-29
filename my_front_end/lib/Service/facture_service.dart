import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/facture.dart';
import 'package:my_first_app/models/ligne_facture.dart';

class FactureService {

  Future<List<Facture>> fetchFactures() async {
    final response = await http.get(Uri.parse('$apiUrl/factures'));

    if (response.statusCode == 200) {
      // Traitez la réponse JSON ici pour convertir en liste de Facture
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
      // Gérer les erreurs ici (par exemple, journaliser l'erreur ou lancer une exception)
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
}

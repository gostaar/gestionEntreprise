import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/factureFournisseur.dart';

class FactureFournisseurService {
  static Future<List<FactureFournisseur>> fetchFactureFournisseur() async {
    final response = await http.get(Uri.parse('$apiUrl/facturefournisseur'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => FactureFournisseur.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des comptes');
    }
  }

  static Future<List<FactureFournisseur>> getFactureFournisseurByFournisseurId(int fournisseurId) async {
    final response = await http.get(Uri.parse('$apiUrl/facturefournisseur/fournisseur/$fournisseurId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((facturefournisseur) => FactureFournisseur.fromJson(facturefournisseur)).toList();
    } else {
      throw Exception('Erreur lors du chargement des comptes');
    }
  }
}
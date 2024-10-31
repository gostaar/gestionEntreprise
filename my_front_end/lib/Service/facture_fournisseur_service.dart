import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/factureFournisseur.dart';

class FactureFournisseurService {
  Future<List<FactureFournisseur>> fetchFactureFournisseur() async {
    final response = await http.get(Uri.parse('$apiUrl/facturefournisseur'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => FactureFournisseur.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des comptes');
    }
  }
}
import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/fournisseursModel.dart';

class FournisseurService {
  static Future<Fournisseur> getFournisseursById(int fournisseurId) async {
    final response = await http.get(Uri.parse('$apiUrl/fournisseurs/$fournisseurId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Fournisseur.fromJson(data);
    } else {
      throw Exception('Erreur lors de la récupération du fournisseur : ${response.statusCode}');
    }
  }

   static Future<List<Fournisseur>> fetchFournisseurs() async {
    final response = await http.get(Uri.parse('$apiUrl/fournisseurs'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((json) => Fournisseur.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des fournisseurs');
    }
  }
}

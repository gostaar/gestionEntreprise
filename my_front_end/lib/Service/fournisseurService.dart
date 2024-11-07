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

  static Future <int> getLastFournisseurId() async{
    final response = await http.get(Uri.parse('$apiUrl/fournisseurs/lastId'));

    if(response == 200){
      final List<dynamic> data = json.decode(response.body);
      if(data.isNotEmpty){
        return data[0]['fournisseurId'];
      }else{
        throw Exception ('Aucun fournisseur trouvé');
      }
    } else {
      throw Exception('Erreur lors de la récupération du dernier fournisseur Id');
    }
  }

  static Future<void> addFournisseur({
    required int fournisseurId,
    required String? nom,
    required String? prenom,
    required String? email,
    required String? telephone,
    required String? adresse,
    required String? ville,
    required String? codePostal,
    required String? pays,
    required String? numeroTva,
  }) async {
    try {
      await http.post(
        Uri.parse('$apiUrl/clients'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fournisseurId': fournisseurId,
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'telephone': telephone,
          'adresse': adresse,
          'ville': ville,
          'codePstal': codePostal,
          'pays': pays,
          'numeroTva': numeroTva,
        }),
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du client: $e');
    }
  }
}

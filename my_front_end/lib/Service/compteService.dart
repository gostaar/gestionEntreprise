import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/compteModel.dart'; 

class CompteService {
  Future<List<Compte>> fetchComptes() async {
    final response = await http.get(Uri.parse('$apiUrl/comptes'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Compte.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des comptes');
    }
  }

  static Future<int> getLastCompteId() async {
    final response = await http.get(Uri.parse('$apiUrl/comptes/lastId'));
    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body);
      if(data.isNotEmpty) {
        return data[0]['compte_id'];
      } else {
        throw Exception('Aucun compte trouvé');
      }
    } else {
      throw Exception('Erreur lors de la récupération du dernier compte Id: ${response.body}');
    }
  }

  static Future<void> addCompte({
    required int compteId,
    required String nomCompte,
    required String typeCompte,
    required double montantDebit,
    required double montantCredit,
    required double? solde,
    required String dateCreation,
  }) async {
    try {
      await http.post(
        Uri.parse('$apiUrl/comptes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'compte_id': compteId,
          'nom_compte': nomCompte,
          'type_compte': typeCompte,
          'debit': montantDebit,
          'credit': montantCredit,
          'solde': solde,
          'date_creation': dateCreation,
        }),
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du compte: $e');
    }
  }
}
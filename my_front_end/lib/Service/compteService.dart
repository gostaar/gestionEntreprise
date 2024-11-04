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

  
}
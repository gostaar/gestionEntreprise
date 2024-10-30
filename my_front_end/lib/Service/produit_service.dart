import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:my_first_app/models/produit.dart';
import 'package:my_first_app/constants.dart';

class ProduitService {

  static Future<List<Produit>?> getProduitsById(int produitId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/produits/$produitId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<Produit>((json) => Produit.fromJson(json)).toList(); 
      } else {
        print('Erreur lors de la récupération des produits : ${response.statusCode}');
        return null; 
      }
    } catch (e) {
      print('Exception lors de la récupération des produits : $e');
      return null; 
    }
  } 

   Future<List<Produit>> fetchProduits() async {
    final response = await http.get(Uri.parse('$apiUrl/produits'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((produit) => Produit.fromJson(produit)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des produits');
    }
  }

  Future<int> getLastProduitId() async {
    final response = await http.get(Uri.parse('$apiUrl/produits/l/lastId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return data[0]['produit_id']; 
      } else {
        throw Exception('Aucun produit trouvé.');
      }
    } else {
      throw Exception('Erreur lors de la récupération du dernier produit_id: ${response.body}');
    }
  
  }
}

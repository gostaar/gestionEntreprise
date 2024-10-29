import 'dart:convert'; // Pour jsonEncode et jsonDecode
import 'package:http/http.dart' as http; // Assurez-vous d'avoir la dépendance http dans votre pubspec.yaml
import 'package:my_first_app/models/produit.dart';
import 'package:my_first_app/constants.dart';

class ProduitService {

  static Future<List<Produit>?> getProduitsById(int produitId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/produits/$produitId'));

      if (response.statusCode == 200) {
        // Si la requête réussit, on décode le JSON
        final List<dynamic> data = json.decode(response.body); // Attendre une liste
        return data.map<Produit>((json) => Produit.fromJson(json)).toList(); // Mapper tous les produits
      } else {
        print('Erreur lors de la récupération des produits : ${response.statusCode}');
        return null; // Gestion des erreurs
      }
    } catch (e) {
      print('Exception lors de la récupération des produits : $e');
      return null; // Gestion des exceptions
    }
  } 

   Future<List<Produit>> fetchProduits() async {
    final response = await http.get(Uri.parse('$apiUrl/produits'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((produit) => Produit.fromJson(produit)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des factures');
    }
  }
}

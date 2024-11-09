import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:my_first_app/models/produitModel.dart';
import 'package:my_first_app/constants.dart';

class ProduitService {

  static Future<List<Produit>?> getProduitsById(int produitId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/produits/$produitId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<Produit>((json) => Produit.fromJson(json)).toList(); 
      } else {
        throw Exception('Erreur lors de la récupération des produits : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception lors de la récupération des produits : $e');
    }
  } 

   static Future<List<Produit>> fetchProduits() async {
    final response = await http.get(Uri.parse('$apiUrl/produits'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((produit) => Produit.fromJson(produit)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des produits');
    }
  }

  static Future<int> getLastProduitId() async {
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

  static Future<void> createProduit({
    required int produitId,
    required String nomProduit,
    required String description,
    required double prix,
    required int quantiteEnStock,
    required String categorie,

  }) async {
    try {
      await http.post(
        Uri.parse('$apiUrl/produits'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'produit_id': produitId,
          'nom_produit': nomProduit,
          'description': description,
          'prix': prix,
          'quantite_en_stock': quantiteEnStock,
          'categorie': categorie,
        }),
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la facture: $e');
    }
  }
}

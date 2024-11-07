import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/constants.dart';
import 'package:my_first_app/models/factureFournisseurModel.dart';

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

  static Future<void> addFactureFournisseur({
    required int id,
    required int fournisseurId,
    required DateTime? dateFacture,
    required double? montantTotal,
    required String? statut,
    required DateTime? datePaiement,

  }) async {
    try {
      await http.post(
        Uri.parse('$apiUrl/facturesfournisseur'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'facture_id': id,
          'fournisseur_id': fournisseurId,
          'montant_total': montantTotal,
          'statut': statut,
          'date_facture': dateFacture,
          'date_paiement': datePaiement,
        }),
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la facture: $e');
    }
  }

  static Future<int> getLastFactureFournisseurId() async {
    final response = await http.get(Uri.parse('$apiUrl/facturefournisseur/facture/lastId'));
    if (response.statusCode == 200) {
     final List<dynamic> data = jsonDecode(response.body);
     if(data.isNotEmpty) {
      return data[0]['facture_id'];
     } else {
      throw Exception("Aucune facture trouvée.");
     }
    } else {
      throw Exception('Erreur lors de la récupération du dernier facture_id: ${response.body}');
    }
  }
}
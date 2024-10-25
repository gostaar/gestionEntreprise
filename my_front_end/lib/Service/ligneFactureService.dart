import 'dart:convert'; // Pour jsonEncode et jsonDecode
import 'package:http/http.dart'
    as http; // Assurez-vous d'avoir la dépendance http dans votre pubspec.yaml
import 'package:my_first_app/models/ligne_facture.dart';
import 'package:my_first_app/constants.dart';

class LigneFactureService {
  static Future<List<LigneFacture>?> getLignesFactureByFactureId(
      int factureId) async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl/lignesFactures/$factureId'));

      if (response.statusCode == 200) {
        // Si la requête réussit, on décode le JSON
        final List<dynamic> data = json.decode(response.body);

        // Convertir la liste de Map en une liste de LigneFacture
        List<LigneFacture> lignesFacture = data.map((ligne) {
          return LigneFacture.fromJson(ligne as Map<String, dynamic>);
        }).toList();

        return lignesFacture; // Retourner la liste des lignes de facture
      } else {
        print(
            'Erreur lors de la récupération des lignes de facture depuis ligneFactureService: ${response.statusCode}');
        return null; // Gestion des erreurs
      }
    } catch (e) {
      print('Exception lors de la récupération des lignes de facture : $e');
      return null; // Gestion des exceptions
    }
  }
}

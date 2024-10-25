import 'dart:convert'; // Pour jsonEncode et jsonDecode
import 'package:http/http.dart'
    as http; // Assurez-vous d'avoir la dépendance http dans votre pubspec.yaml
import 'package:my_first_app/models/client.dart';
import 'package:my_first_app/constants.dart';

class ClientService {
  // Méthode pour récupérer un client par ID
  static Future<Client?> getClientById(int clientId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/clients/$clientId'));

      if (response.statusCode == 200) {
        // Si la requête réussit, on décode le JSON
        final data = json.decode(response.body);
        return Client.fromJson(
            data); // Assurez-vous que votre classe Client a une méthode fromJson
      } else {
        print(
            'Erreur lors de la récupération du client : ${response.statusCode}');
        return null; // Gestion des erreurs
      }
    } catch (e) {
      print('Exception lors de la récupération du client : $e');
      return null; // Gestion des exceptions
    }
  }
}

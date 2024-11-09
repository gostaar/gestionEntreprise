import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:my_first_app/models/clientModel.dart';
import 'package:my_first_app/constants.dart';

class ClientService {
  static Future<Client> getClientById(int clientId) async {
    final response = await http.get(Uri.parse('$apiUrl/clients/$clientId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Client.fromJson(data);
    } else {
      throw Exception('Erreur lors de la récupération du client : ${response.statusCode}');
    }
  }

   static Future<List<Client>> fetchClients() async {
    final response = await http.get(Uri.parse('$apiUrl/clients'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Client.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des clients');
    }
  }

  static Future<void> updateClient(Client client) async {
    final response = await http.patch(
      Uri.parse('$apiUrl/clients/${client.clientId}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nom': client.nom,
        'prenom': client.prenom,
        'email': client.email,
        'telephone': client.telephone,
        'adresse': client.adresse,
        'ville': client.ville,
        'code_postal': client.codePostal,
        'pays': client.pays,
        'numero_tva': client.numeroTva,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour du client');
    }
  }

  static Future<int> getLastClientId() async {
  final response = await http.get(Uri.parse('$apiUrl/clients/lastId'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
   
    // Vérifier si 'clientId' existe et est un entier
    if (data.isNotEmpty && data[0]['client_id'] != null) {
      return data[0]['client_id'];
    } else {
      throw Exception('Aucun client trouvé ou client_id est manquant');
    }
  } else {
    throw Exception('Erreur lors de la récupération du dernier client id: ${response.body}');
  }
}

  static Future<void> createClient({
    required int clientId,
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
          'client_Id': clientId,
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'telephone': telephone,
          'adresse': adresse,
          'ville': ville,
          'code_postal': codePostal,
          'pays': pays,
          'numero_tva': numeroTva,
        }),
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du client: $e');
    }
  }
}


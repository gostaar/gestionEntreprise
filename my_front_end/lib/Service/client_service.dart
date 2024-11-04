import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:my_first_app/models/client.dart';
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
        'codePostal': client.codePostal,
        'pays': client.pays,
        'numeroTva': client.numeroTva,
      }),
    );
    //print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour du client');
    }
  }
}


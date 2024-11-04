class Client {
  final int clientId;
  final String nom;
  final String? prenom;
  final String? email;
  final String? telephone;
  final String? adresse;
  final String? ville;
  final String? codePostal;
  final String? pays;
  final String? numeroTva;

  Client({
    required this.clientId,
    required this.nom,
    this.prenom,
    this.email,
    this.telephone,
    this.adresse,
    this.ville,
    this.codePostal,
    this.pays,
    this.numeroTva,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        clientId: json['client_id'],
        nom: json['nom'],
        prenom: json['prenom'] as String?,
        email: json['email'] as String?,
        telephone: json['telephone'] as String?,
        adresse: json['adresse'] as String?,
        ville: json['ville'] as String?,
        codePostal: json['codePostal'] as String?,
        pays: json['pays'] as String?,
        numeroTva: json['numeroTva'] as String?);
  }

  // Méthode toJson pour convertir l'objet Client en Map
  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'adresse': adresse,
      'ville': ville,
      'codePostal': codePostal,
      'pays': pays,
      'numeroTva': numeroTva,
    };
  }

   Client copyWith({
    int? clientId,
    String? nom,
    String? prenom,
    String? email,
    String? adresse,
    String? ville,
    String? codePostal,
    String? pays,
    String? numeroTva,
    String? telephone,
  }) {
    return Client(
      clientId: clientId ?? this.clientId,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      adresse: adresse ?? this.adresse,
      ville: ville ?? this.ville,
      codePostal: codePostal ?? this.codePostal,
      pays: pays ?? this.pays,
      numeroTva: numeroTva ?? this.numeroTva,
      telephone: telephone ?? this.telephone,
    );
  }
}

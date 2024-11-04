class Fournisseur {
  final int fournisseurId;
  final String nom;
  final String? prenom;
  final String? email;
  final String? telephone;
  final String? adresse;
  final String? ville;
  final String? codePostal;
  final String? pays;
  final String? numeroTva;

  Fournisseur({
    required this.fournisseurId,
    required this.nom,
    required this.prenom,
    required this.email,
    this.telephone,
    this.adresse,
    this.ville,
    this.codePostal,
    this.pays,
    this.numeroTva,
  });

  factory Fournisseur.fromJson(Map<String, dynamic> json) {
    return Fournisseur(
        fournisseurId: json['fournisseur_id'],
        nom: json['nom'],
        prenom: json['prenom'] as String?,
        email: json['email'] as String?,
        telephone: json['telephone'] as String?,
        adresse: json['adresse'] as String?,
        ville: json['ville'] as String?,
        codePostal: json['code_postal'] as String?,
        pays: json['pays'] as String?,
        numeroTva: json['numero_tva'] as String?);
  }

  // Méthode toJson pour convertir l'objet Client en Map
  Map<String, dynamic> toJson() {
    return {
      'fournisseur_id': fournisseurId,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'adresse': adresse,
      'ville': ville,
      'code_postal': codePostal,
      'pays': pays,
      'numero_tva': numeroTva,
    };
  }
}

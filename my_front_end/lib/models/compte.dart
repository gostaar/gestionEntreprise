class Compte {
  final int compteId;
  final String nomCompte;
  final String typeCompte;
  final String solde;
  final String dateCreation;

  Compte({
    required this.compteId,
    required this.nomCompte,
    required this.typeCompte,
    required this.solde,
    required this.dateCreation,
  });

  factory Compte.fromJson(Map<String, dynamic> json) {
    return Compte(
        compteId: json['compte_id'],
        nomCompte: json['nom_compte'],
        typeCompte: json['type_compte'],
        solde: json['solde'],
        dateCreation: json['date_creation']);
  }
}

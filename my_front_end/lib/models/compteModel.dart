class Compte {
  final int compteId;
  final String nomCompte;
  final String typeCompte;
  final double montantDebit; // Nouveau champ pour le débit
  final double montantCredit; // Nouveau champ pour le crédit
  final double? solde;
  final String dateCreation;

  Compte({
    required this.compteId,
    required this.nomCompte,
    required this.typeCompte,
    required this.montantDebit,
    required this.montantCredit,
    this.solde,
    required this.dateCreation,
  });

  factory Compte.fromJson(Map<String, dynamic> json) {
    return Compte(
        compteId: json['compte_id'],
        nomCompte: json['nom_compte'],
        typeCompte: json['type_compte'],
        montantDebit: json['debit'],
        montantCredit: json['credit'],
        solde: json['solde'],
        dateCreation: json['date_creation']);
  }
}

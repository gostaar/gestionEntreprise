class Facture {
  final int id;
  final int clientId;
  final DateTime? dateFacture;
  final double? montantTotal;
  final String? statut;
  final DateTime? datePaiement;

  Facture({
    required this.id,
    required this.clientId,
    this.dateFacture,
    this.montantTotal,
    this.statut,
    this.datePaiement,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      id: json['facture_id'],
      clientId: json['client_id'],
      dateFacture: json['date_facture'] != null
        ? DateTime.parse(json['date_facture'])
        : null,
      montantTotal: json['montant_total'] is String
        ? double.tryParse(json['montant_total']) // Convertir si c'est une chaîne
        : (json['montant_total'] as num?)?.toDouble(), // Convertir au format double
      statut: json['statut'],
      datePaiement: json['date_paiement'] != null
          ? DateTime.parse(json['date_paiement'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facture_id': id,
      'client_id': clientId,
      'date_facture': dateFacture,
      'montant_total': montantTotal,
      'statut': statut,
      'date_paiement': datePaiement
    };
  }
}

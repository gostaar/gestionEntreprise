class FactureFournisseur {
  final int id;
  final int fournisseurId;
  final DateTime? dateFacture;
  final double? montantTotal;
  final String? statut;
  final DateTime? datePaiement;

  FactureFournisseur({
    required this.id,
    required this.fournisseurId,
    this.dateFacture,
    this.montantTotal,
    this.statut,
    this.datePaiement,
  });

  factory FactureFournisseur.fromJson(Map<String, dynamic> json) {
    return FactureFournisseur(
      id: json['facture_id'],
      fournisseurId: json['fournisseur_id'],
      dateFacture: json['date_facture'] != null
        ? DateTime.parse(json['date_facture'])
        : null,
      montantTotal: json['montanttotal'] is String
        ? double.tryParse(json['montanttotal']) 
        : (json['montanttotal'] as num?)?.toDouble(), 
      statut: json['statut'],
      datePaiement: json['date_paiement'] != null
          ? DateTime.parse(json['date_paiement'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facture_id': id,
      'fournisseur_id': fournisseurId,
      'date_facture': dateFacture,
      'montanttotal': montantTotal,
      'statut': statut,
      'date_paiement': datePaiement
    };
  }
}

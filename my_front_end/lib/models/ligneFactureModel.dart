class LigneFacture {
  final int ligneId;
  final int factureId;
  final int produitId;
  final int quantite;
  final double prixUnitaire;
  final double sousTotal;

  LigneFacture({
    required this.ligneId,
    required this.factureId,
    required this.produitId,
    required this.quantite,
    required this.prixUnitaire,
    required this.sousTotal,
  });

  factory LigneFacture.fromJson(Map<String, dynamic> json) {
    return LigneFacture(
      ligneId: json['ligne_id'],
      factureId: json['facture_id'],
      produitId: json['produit_id'],
      quantite: json['quantite'],
      prixUnitaire: double.tryParse(json['prix_unitaire'].toString()) ?? 0.0,
      sousTotal: double.tryParse(json['sous_total'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ligne_id': ligneId,
      'facture_id': factureId,
      'produit_id': produitId,
      'quantite': quantite,
      'prix_unitaire': prixUnitaire,
      'sous_total': sousTotal,
    };
  }
}

import 'produit.dart';

class LigneFacture {
  final int ligneId;
  final int factureId;
  final int produitId;
  final int quantite;
  final String prixUnitaire;
  final String sousTotal;

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
        prixUnitaire: json['prix_unitaire'],
        sousTotal: json['sous_total']);
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

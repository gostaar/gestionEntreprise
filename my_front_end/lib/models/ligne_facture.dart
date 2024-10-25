import 'produit.dart';

class LigneFacture {
  final int ligneId;
  final Produit produitId;
  final int quantite;
  final String prixUnitaire;
  final String sousTotal;

  LigneFacture({
    required this.ligneId,
    required this.produitId,
    required this.quantite,
    required this.prixUnitaire,
    required this.sousTotal,
  });

  factory LigneFacture.fromJson(Map<String, dynamic> json) {
    return LigneFacture(
        ligneId: json['ligneId'],
        produitId: json['produitId'],
        quantite: json['quantite'],
        prixUnitaire: json['prixUnitaire'],
        sousTotal: json['sousTotal']);
  }

  Map<String, dynamic> toJson() {
    return {
      'ligneId': ligneId,
      'produitId': produitId,
      'quantite': quantite,
      'prixUnitaire': prixUnitaire,
      'sousTotal': sousTotal,
    };
  }
}

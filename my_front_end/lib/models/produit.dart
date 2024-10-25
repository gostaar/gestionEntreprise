class Produit {
  final int produitId;
  final String nomProduit;
  final String description;
  final double prix;
  final int quantiteEnStock;
  final String categorie;
  final DateTime dateAjout;

  Produit({
    required this.produitId,
    required this.nomProduit,
    required this.description,
    required this.prix,
    required this.quantiteEnStock,
    required this.categorie,
    required this.dateAjout,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    // Afficher le type et la valeur avant conversion
    print(
        'Prix avant conversion: ${json['prix']} (${json['prix'].runtimeType})');

    // Conversion avec gestion des erreurs
    double prixValue;
    try {
      prixValue = double.parse(json['prix'].toString());
    } catch (e) {
      print('Erreur lors de la conversion du prix: $e');
      prixValue = 0.0; // Valeur par défaut en cas d'erreur
    }

    return Produit(
      produitId: json['produit_id'],
      nomProduit: json['nom_produit'],
      description: json['description'],
      prix: prixValue, // Utilisez la valeur convertie
      quantiteEnStock: json['quantite_en_stock'],
      categorie: json['categorie'],
      dateAjout: DateTime.parse(json['date_ajout']),
    );
  }
}

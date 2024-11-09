class Produit {
  final int produitId;
  final String nomProduit;
  final String description;
  final double prix;
  final int quantiteEnStock;
  final String categorie;

  Produit({
    required this.produitId,
    required this.nomProduit,
    required this.description,
    required this.prix,
    required this.quantiteEnStock,
    required this.categorie,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    double prixValue;
    try {
      prixValue = double.parse(json['prix'].toString());
    } catch (e) {
      prixValue = 0.0;
      throw Exception('Erreur lors de la conversion du prix: $e');
    }

    return Produit(
      produitId: json['produit_id'],
      nomProduit: json['nom_produit'],
      description: json['description'],
      prix: prixValue, // Utilisez la valeur convertie
      quantiteEnStock: json['quantite_en_stock'],
      categorie: json['categorie'],
    );
  }

  factory Produit.defaut() => Produit(
    produitId: -1, 
    nomProduit: 'défault', 
    description:'défault', 
    prix: 0.0, 
    quantiteEnStock: 0, 
    categorie: 'service'
  );

  Map<String, dynamic> toJson() {
    return{
      //'produit_id': produitId,
      'nom_produit': nomProduit,
      'description': description,
      'prix': prix,
      'quantite_en_stock': quantiteEnStock,
      'categorie': categorie,
    };
  }
}

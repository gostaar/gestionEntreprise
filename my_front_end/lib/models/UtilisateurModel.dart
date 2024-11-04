class Utilisateur {
  final int utilisateurId;
  final String nom;
  final String email;
  final String motDePasse;
  final String role;
  final String dateCreation;

  Utilisateur({
    required this.utilisateurId,
    required this.nom,
    required this.email,
    required this.motDePasse,
    required this.role,
    required this.dateCreation,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
        utilisateurId: json['utilisateur_id'],
        nom: json['nom'],
        email: json['email'],
        motDePasse: json['mot_de_passe'],
        role: json['role'],
        dateCreation: json['date_creation']);
  }
}

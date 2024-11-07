import 'package:my_first_app/Service/fournisseurService.dart';
import 'package:my_first_app/models/compteModel.dart';
import 'package:my_first_app/models/factureFournisseurModel.dart';
import 'package:my_first_app/models/fournisseursModel.dart';

Future<List<Compte>> createAccountsFromFournisseurInvoices(List<FactureFournisseur> fetchedFacturesFournisseurs) async {
  Map<String, Map<String, double>> compteMap = {}; // Map pour agréger les montants
  Map<String, int> fournisseurIds = {};

  for (var factureFournisseur in fetchedFacturesFournisseurs) {
    // Récupérer le fournisseur à partir de son ID
    Fournisseur fournisseur = await FournisseurService.getFournisseursById(factureFournisseur.fournisseurId);

    // Initialiser l’entrée dans la Map si elle n'existe pas encore
    if (!compteMap.containsKey(fournisseur.nom)) {
      compteMap[fournisseur.nom] = {'Débit': 0.0, 'Crédit': 0.0, };
      fournisseurIds[fournisseur.nom] = fournisseur.fournisseurId;
    }

    // Calculer le montant à ajouter
    double montant = factureFournisseur.montantTotal ?? 0.0;

    // Ajouter le montant au crédit ou au débit selon la logique métier
    if (factureFournisseur.statut == 'Payée') {
      compteMap[fournisseur.nom]!['Débit'] = (compteMap[fournisseur.nom]!['Débit'] ?? 0.0) + montant;
    } else {
      compteMap[fournisseur.nom]!['Crédit'] = (compteMap[fournisseur.nom]!['Crédit'] ?? 0.0) + montant;
    }
  }
  // Convertir le Map en liste de comptes
  List<Compte> comptes = [];
  compteMap.forEach((nomFournisseur, montants) {
    comptes.add(Compte(
      compteId: fournisseurIds[nomFournisseur]!,
      nomCompte: nomFournisseur,
      typeCompte: 'Fournisseur',
      montantDebit: montants['Débit']!,
      montantCredit: montants['Crédit']!,
      dateCreation: DateTime.now().toIso8601String(),
    ));
  });

  return comptes;
}
import 'dart:ffi';

import 'client.dart';
import 'ligne_facture.dart';

// Modèle pour la Facture
class Facture {
  final int id;
  final int clientId;
  final DateTime? dateFacture;
  final Double montantTotal;
  final String statut;
  final DateTime? datePaiement;
  // Client? client;
  // final List<LigneFacture> lignesFacture;

  Facture({
    required this.id,
    required this.clientId,
    this.dateFacture,
    required this.montantTotal,
    required this.statut,
    this.datePaiement,
    // this.client,
    // required this.lignesFacture,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      id: json['facture_id'],
      clientId: json['client_id'],
      dateFacture: json['date_facture'] != null
          ? DateTime.parse(json['date_facture'])
          : null,
      montantTotal: json['montant_total'],
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

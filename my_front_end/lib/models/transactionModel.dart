import 'compteModel.dart';
import 'factureModel.dart';

class Transaction {
  final int transactionId;
  final Compte compteId;
  final Facture factureId;
  final String montant;
  final String typeTransaction;
  final String dateTransaction;

  Transaction({
    required this.transactionId,
    required this.compteId,
    required this.factureId,
    required this.montant,
    required this.typeTransaction,
    required this.dateTransaction,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'],
      compteId: json['compte_id'],
      factureId: json['facture_id'],
      montant: json['montant'],
      typeTransaction: json['type_transaction'],
      dateTransaction: json['date_transaction'],
    );
  }
}

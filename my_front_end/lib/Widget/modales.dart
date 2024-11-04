import 'package:flutter/material.dart';
import 'package:my_first_app/Forms/Add/ClientForm.dart';
import 'package:my_first_app/Forms/Add/FournisseurForm.dart';

class AddClientModal extends StatelessWidget {
  const AddClientModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AddClientForm(),
    );
  }
}
class AddFournisseurModal extends StatelessWidget {
  const AddFournisseurModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AddFournisseurForm(),
    );
  }
}
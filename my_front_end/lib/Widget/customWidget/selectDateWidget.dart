import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> selectDate(
  BuildContext context, 
  TextEditingController controller, 
  Function(DateTime?)? data 
) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    locale: const Locale("fr", "FR"),
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (picked != null) {
    Future.delayed(Duration.zero, () {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
      data?.call(picked);
    });
  }
}
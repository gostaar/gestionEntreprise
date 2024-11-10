import 'package:flutter/material.dart';

const String apiUrl =
    'https://c5e7-2a01-cb1c-d1f-ea00-11e9-5ee5-d4b7-8c6f.ngrok-free.app';

const Map<String, Color> customColors = {
  'red': Colors.red,
  'grey': Colors.grey,
  'blue': Colors.blue,
  'borderGrey': Color(0xFFE0E0E0),
  'lineGrey': Color(0xFFBDBDBD),
  'white': Colors.white,
  'black' : Colors.black,
};

const String nomLabel = 'Nom';
const String prenomLabel = 'Prénom';
const String emailLabel = 'Email';
const String telephoneLabel = 'Téléphone';
const String adresseLabel = 'Adresse';
const String villeLabel = 'ville';
const String codePostalLabel = 'Code postal';
const String paysLabel = 'Pays';
const String tvaLabel = 'Numéro de Tva';

const String clientLabel = 'Client';
const String factureLabel = 'Facture';

const String nomField = 'nom';
const String prenomField = 'prenom';
const String emailField = 'email';
const String telephoneField = 'telephone';
const String adresseField = 'adresse';
const String villeField = 'ville';
const String codePostalField = 'code_postal';
const String paysField = 'pays';
const String tvaField = 'numero_tva';

const String clientFormData = 'client';
const String factureFormData = 'facture';
const String ligneFactureFormData = 'lignefacture';

const String tabDetails = 'Détails';
const String tabFacture = 'Facture';

List<String> clientFields = [nomField, prenomField, emailField, telephoneField, adresseField, villeField, codePostalField, paysField, tvaField];
List<String> clientLabels = [nomLabel, prenomLabel, emailLabel, telephoneLabel, adresseLabel, villeLabel, codePostalLabel, paysLabel, tvaLabel];
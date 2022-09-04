

import 'dart:io';

import 'package:bordero/model/utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../model/document.dart';

class AppPsyUtils {

  static bool isNumeric(String s) {
    if (s == null || s.isEmpty) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static double tryParseDouble(String s) {
    return double.tryParse(s) ?? 00.toDouble();
  }

  static String toDateString(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static String getTypePayements(Utilisateur user) {
    String res = "";
    if (user.payementCheque == 1) res += "Chèque, ";
    if (user.payementCarteBleu == 1) res += "Carte bleu, ";
    if (user.payementLiquide == 1) res += "Liquide, ";
    if (user.payementVirementBancaire == 1) res += "Virement bancaire,";
    return res;
  }

  static String getName(Document facture) {
    return basename(facture.nom);
  }

  static String getNameOfFile(File file) {
    return basename(file.path);
  }

  static afficherDialog(
      {required BuildContext context, required String titre,
        required String corps,
        required String buttonCancelTexte,
        required String buttonValiderTexte,
        Function()? buttonCancelCallback,
        Function()? buttonValiderCallback,
        Widget? elementAtEnd}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titre,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                )),
            content: elementAtEnd ?? Text(corps),
            actions: [
              TextButton(
                onPressed: buttonCancelCallback,
                child: Text(buttonCancelTexte),
              ),
              TextButton(
                onPressed: buttonValiderCallback,
                child: Text(buttonValiderTexte),
              ),
            ],
            elevation: 24.0,
          );
        });
  }

}
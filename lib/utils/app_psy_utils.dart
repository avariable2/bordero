
import 'package:app_psy/model/utilisateur.dart';
import 'package:path/path.dart';

import '../model/facture.dart';

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

  static String getName(Facture facture) {
    return basename(facture.nom);
  }

}

class AppPsyUtils {

  static String CACHE_SAUVEGARDER_NUMERO_FACTURE = "cache_sauvegarder_numero_facture";

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
}

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
}
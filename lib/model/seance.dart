
class Seance {
  final String nom;
  final DateTime date;
  final double prix;
  final String? uniteTemps;
  final int quantite;

  const Seance({
    required this.nom,
    required this.date,
    required this.prix,
    required this.uniteTemps,
    required this.quantite,
  });
}
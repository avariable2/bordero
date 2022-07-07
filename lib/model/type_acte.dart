import 'package:app_psy/app_psy_utils.dart';

const String tableTypeActe = 'type_acte';

class TypeActeChamps {
  static final List<String> values = [
    // Ajouter tous les champs
    id, nom, prix,
  ];

  static const String id = '_id';
  static const String nom = 'nom';
  static const String prix = 'prix';
}

class TypeActe {
  final int? id;
  final String nom;
  final double prix;

  const TypeActe({
    this.id,
    required this.nom,
    required this.prix,
  });

  TypeActe copy({
    int? id,
    String? nom,
    double? prix,
  }) =>
      TypeActe(
        id: id ?? this.id,
        nom: nom ?? this.nom,
        prix: prix ?? this.prix,
      );

  static TypeActe fromJson(Map<String, Object?> json) =>
      TypeActe(
        id: json[TypeActeChamps.id] as int?,
        nom: json[TypeActeChamps.nom] as String,
        prix: json[TypeActeChamps.prix] as double,
      );

  Map<String, Object?> toJson() =>
      {
        TypeActeChamps.id: id,
        TypeActeChamps.nom: nom,
        TypeActeChamps.prix: prix,
      };

}
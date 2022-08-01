import 'dart:typed_data';
import 'package:app_psy/model/seance.dart';
import 'client.dart';

const String tableFacture = 'facture';

class FactureChamps {
  static final List<String> values = [
    // Ajouter tous les champs
    id, nom, fichier, estFacture
  ];

  static const String id = '_id';
  static const String nom = 'nom';
  static const String fichier = 'fichier';
  static const String estFacture = 'estFacture';
}

class Facture {
  final int? id;
  final String nom;
  final Uint8List fichier;
  final int estFacture;

  const Facture(
      {this.id,
      required this.nom,
      required this.fichier,
      required this.estFacture});

  Facture copy({int? id, String? nom, Uint8List? fichier, int? estFacture}) =>
      Facture(
        id: id ?? this.id,
        nom: nom ?? this.nom,
        fichier: fichier ?? this.fichier,
        estFacture: estFacture ?? this.estFacture,
      );

  static Facture fromJson(Map<String, Object?> json) => Facture(
        id: json[FactureChamps.id] as int?,
        nom: json[FactureChamps.nom] as String,
        fichier: json[FactureChamps.fichier] as Uint8List,
        estFacture: json[FactureChamps.estFacture] as int,
      );

  Map<String, Object?> toJson() => {
        FactureChamps.id: id,
        FactureChamps.nom: nom,
        FactureChamps.fichier: fichier,
        FactureChamps.estFacture: estFacture
      };
}

class CreationFacture {
  final String id;
  final DateTime dateCreationFacture;
  final List<Client> listClients;
  final List<Seance> listSeances;
  final DateTime? dateLimitePayement;
  final Uint8List? signaturePNG;

  const CreationFacture({
    required this.id,
    required this.dateCreationFacture,
    required this.listClients,
    required this.listSeances,
    required this.dateLimitePayement,
    required this.signaturePNG,
  });
}

class InfoPageFacture {
  static const String champId = '_id';
  static const String champNom = 'nom';

  final int id;
  final String nom;

  InfoPageFacture({ required this.id, required this.nom});

  static InfoPageFacture fromJson(Map<String, Object?> json) => InfoPageFacture(
    id: json[champId] as int,
    nom: json[champNom] as String,
  );
}
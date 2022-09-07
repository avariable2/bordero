import 'dart:typed_data';
import 'package:bordero/model/seance.dart';
import 'client.dart';

const String tableDocument = 'document';

class DocumentChamps {
  static final List<String> values = [
    // Ajouter tous les champs
    id, nom, fichier, estFacture,
  ];

  static const String id = '_id';
  static const String nom = 'nom';
  static const String fichier = 'fichier';
  static const String estFacture = 'estFacture';
}

class Document {
  final int? id;
  final String nom;
  final Uint8List fichier;
  final bool estFacture;

  const Document(
      {this.id,
      required this.nom,
      required this.fichier,
      required this.estFacture});

  Document copy({int? id, String? nom, Uint8List? fichier, bool? estFacture}) =>
      Document(
        id: id ?? this.id,
        nom: nom ?? this.nom,
        fichier: fichier ?? this.fichier,
        estFacture: estFacture ?? this.estFacture,
      );

  static Document fromJson(Map<String, Object?> json) => Document(
        id: json[DocumentChamps.id] as int?,
        nom: json[DocumentChamps.nom] as String,
        fichier: json[DocumentChamps.fichier] as Uint8List,
        estFacture: json[DocumentChamps.estFacture] == 1 ? true : false,
      );

  Map<String, Object?> toJson() => {
        DocumentChamps.id: id,
        DocumentChamps.nom: nom,
        DocumentChamps.fichier: fichier,
        DocumentChamps.estFacture: estFacture,
      };
}

class CreationDocument {
  final String id;
  final DateTime dateCreationFacture;
  final List<Client> listClients;
  final List<Seance> listSeances;
  final DateTime? dateLimitePayement;
  final Uint8List? signaturePNG;
  final bool estFacture;

  const CreationDocument({
    required this.id,
    required this.dateCreationFacture,
    required this.listClients,
    required this.listSeances,
    required this.dateLimitePayement,
    required this.signaturePNG,
    required this.estFacture,
  });
}

class InfoPageFacture {
  static const String champId = '_id';
  static const String champNom = 'nom';

  final int id;
  final String nom;

  InfoPageFacture({required this.id, required this.nom});

  static InfoPageFacture fromJson(Map<String, Object?> json) => InfoPageFacture(
        id: json[champId] as int,
        nom: json[champNom] as String,
      );
}

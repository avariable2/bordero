import 'dart:html';

const String tableClient = 'client';

class ClientChamps {
  static final List<String> values = [
    // Ajouter tous les champs
    id, nom, prenom, adresse, codePostal, ville, numeroTelephone, email
  ];

  static const String id = '_id';
  static const String nom = 'nom';
  static const String prenom = 'prenom';
  static const String adresse = 'adresse';
  static const String codePostal = 'code_postal';
  static const String ville = 'ville';
  static const String numeroTelephone = 'numero_telephone';
  static const String email = 'email';
}

class Client {
  final int? id;
  final String nom;
  final String prenom;
  final String adresse;
  final String codePostal;
  final String ville;
  final String numeroTelephone;
  final String email;

  const Client({
    this.id,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.codePostal,
    required this.ville,
    required this.numeroTelephone,
    required this.email,
  });

  Client copy({
    int? id,
    String? nom,
    String? prenom,
    String? adresse,
    String? codePostal,
    String? ville,
    String? numeroTelephone,
    String? email,
  }) =>
      Client(
        id: id ?? this.id,
        nom: nom ?? this.nom,
        prenom: prenom ?? this.prenom,
        adresse: adresse ?? this.adresse,
        codePostal: codePostal ?? this.codePostal,
        ville: ville ?? this.ville,
        numeroTelephone: numeroTelephone ?? this.numeroTelephone,
        email: email ?? this.email,
  );

  static Client fromJson(Map<String, Object?> json) => Client(
    id: json[ClientChamps.id] as int?,
    nom: json[ClientChamps.nom] as String,
    prenom: json[ClientChamps.prenom] as String,
    adresse: json[ClientChamps.adresse] as String,
    codePostal: json[ClientChamps.codePostal] as String,
    ville: json[ClientChamps.ville] as String,
    numeroTelephone: json[ClientChamps.numeroTelephone] as String,
    email: json[ClientChamps.email] as String,
  );

  Map<String, Object?> toJson() => {
    ClientChamps.id: id,
    ClientChamps.nom: nom,
    ClientChamps.prenom: prenom,
    ClientChamps.adresse: adresse,
    ClientChamps.codePostal: codePostal,
    ClientChamps.ville: ville,
    ClientChamps.numeroTelephone: numeroTelephone,
    ClientChamps.email: email,
  };

}
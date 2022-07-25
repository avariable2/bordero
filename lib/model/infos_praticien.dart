class InfosPraticienChamps {
  static final List<String> values = [
    // Ajouter tous les champs
    nom,
    prenom,
    adresse,
    codePostal,
    ville,
    numeroTelephone,
    email,
    numeroSIRET,
    numeroADELI,
    payements,
    exonererTVA,
  ];

  static const String nom = 'nom';
  static const String prenom = 'prenom';
  static const String adresse = 'adresse';
  static const String codePostal = 'code_postal';
  static const String ville = 'ville';
  static const String numeroTelephone = 'numero_telephone';
  static const String email = 'email';
  static const String numeroSIRET = 'numeroSIRET';
  static const String numeroADELI = 'numeroADELI';
  static const String payements = 'payements';
  static const String exonererTVA = 'exonererTVA';
}

class InfosPraticien {
  static String keyObjInfosPraticien = "keyObjInfosPraticien";

  final String nom;
  final String prenom;
  final String adresse;
  final String codePostal;
  final String ville;
  final String numeroTelephone;
  final String email;
  final int numeroSIRET;
  final int numeroADELI;
  final List<dynamic> payements;
  final bool exonererTVA;

  const InfosPraticien(
      {required this.nom,
      required this.prenom,
      required this.adresse,
      required this.codePostal,
      required this.ville,
      required this.numeroTelephone,
      required this.email,
      required this.numeroADELI,
      required this.numeroSIRET,
      required this.payements,
      required this.exonererTVA});

  InfosPraticien copy(
          {int? id,
          String? nom,
          String? prenom,
          String? adresse,
          String? codePostal,
          String? ville,
          String? numeroTelephone,
          String? email,
          int? numeroADELI,
          int? numeroSIRET,
          List<dynamic>? payements,
          bool? exonererTVA}) =>
      InfosPraticien(
        nom: nom ?? this.nom,
        prenom: prenom ?? this.prenom,
        adresse: adresse ?? this.adresse,
        codePostal: codePostal ?? this.codePostal,
        ville: ville ?? this.ville,
        numeroTelephone: numeroTelephone ?? this.numeroTelephone,
        email: email ?? this.email,
        numeroADELI: numeroADELI ?? this.numeroADELI,
        numeroSIRET: numeroSIRET ?? this.numeroSIRET,
        payements: payements ?? this.payements,
        exonererTVA: exonererTVA ?? this.exonererTVA,
      );

  static InfosPraticien fromJson(Map<dynamic, dynamic> json) => InfosPraticien(
      nom: json[InfosPraticienChamps.nom] as String,
      prenom: json[InfosPraticienChamps.prenom] as String,
      adresse: json[InfosPraticienChamps.adresse] as String,
      codePostal: json[InfosPraticienChamps.codePostal] as String,
      ville: json[InfosPraticienChamps.ville] as String,
      numeroTelephone: json[InfosPraticienChamps.numeroTelephone] as String,
      email: json[InfosPraticienChamps.email] as String,
      numeroADELI: json[InfosPraticienChamps.numeroADELI] as int,
      numeroSIRET: json[InfosPraticienChamps.numeroSIRET] as int,
      payements: json[InfosPraticienChamps.payements] as List<dynamic>,
      exonererTVA: json[InfosPraticienChamps.exonererTVA] as bool);

  Map<String, Object?> toJson() => {
        InfosPraticienChamps.nom: nom,
        InfosPraticienChamps.prenom: prenom,
        InfosPraticienChamps.adresse: adresse,
        InfosPraticienChamps.codePostal: codePostal,
        InfosPraticienChamps.ville: ville,
        InfosPraticienChamps.numeroTelephone: numeroTelephone,
        InfosPraticienChamps.email: email,
        InfosPraticienChamps.numeroADELI: numeroADELI,
        InfosPraticienChamps.numeroSIRET: numeroSIRET,
        InfosPraticienChamps.payements: payements,
        InfosPraticienChamps.exonererTVA: exonererTVA,
      };
}

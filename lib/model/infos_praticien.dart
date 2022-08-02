const String tableInfosPraticien = 'infosPraticien';

class InfosPraticienChamps {
  static final List<String> values = [
    id,
    nom,
    prenom,
    adresse,
    codePostal,
    ville,
    numeroTelephone,
    email,
    numeroSIRET,
    numeroADELI,
    payementVirementBancaire,
    payementLiquide,
    payementCarteBleu,
    payementCheque,
    exonererTVA,
  ];

  static const String id = '_id';
  static const String nom = 'nom';
  static const String prenom = 'prenom';
  static const String adresse = 'adresse';
  static const String codePostal = 'code_postal';
  static const String ville = 'ville';
  static const String numeroTelephone = 'numero_telephone';
  static const String email = 'email';
  static const String numeroSIRET = 'numeroSIRET';
  static const String numeroADELI = 'numeroADELI';
  static const String payementVirementBancaire = 'payementVirementBancaire';
  static const String payementLiquide = 'payementLiquide';
  static const String payementCarteBleu = 'payementCarteBleu';
  static const String payementCheque = 'payementCheque';
  static const String exonererTVA = 'exonererTVA';
}

class InfosPraticien {
  final int? id;
  final String nom;
  final String prenom;
  final String adresse;
  final String codePostal;
  final String ville;
  final String numeroTelephone;
  final String email;
  final int numeroSIRET;
  final int numeroADELI;
  final bool payementVirementBancaire;
  final bool payementCheque;
  final bool payementCarteBleu;
  final bool payementLiquide;
  final bool exonererTVA;

  const InfosPraticien(
      {this.id,
      required this.nom,
      required this.prenom,
      required this.adresse,
      required this.codePostal,
      required this.ville,
      required this.numeroTelephone,
      required this.email,
      required this.numeroADELI,
      required this.numeroSIRET,
      required this.payementVirementBancaire,
      required this.payementCheque,
      required this.payementCarteBleu,
      required this.payementLiquide,
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
          bool? payementVirementBancaire,
          bool? payementCheque,
          bool? payementCarteBleu,
          bool? payementLiquide,
          bool? exonererTVA}) =>
      InfosPraticien(
        id: id ?? this.id,
        nom: nom ?? this.nom,
        prenom: prenom ?? this.prenom,
        adresse: adresse ?? this.adresse,
        codePostal: codePostal ?? this.codePostal,
        ville: ville ?? this.ville,
        numeroTelephone: numeroTelephone ?? this.numeroTelephone,
        email: email ?? this.email,
        numeroADELI: numeroADELI ?? this.numeroADELI,
        numeroSIRET: numeroSIRET ?? this.numeroSIRET,
        payementVirementBancaire:
            payementVirementBancaire ?? this.payementVirementBancaire,
        payementCheque: payementCheque ?? this.payementCheque,
        payementCarteBleu: payementCarteBleu ?? this.payementCarteBleu,
        payementLiquide: payementLiquide ?? this.payementLiquide,
        exonererTVA: exonererTVA ?? this.exonererTVA,
      );

  static InfosPraticien fromJson(Map<dynamic, dynamic> json) => InfosPraticien(
      id: json[InfosPraticienChamps.id] as int?,
      nom: json[InfosPraticienChamps.nom] as String,
      prenom: json[InfosPraticienChamps.prenom] as String,
      adresse: json[InfosPraticienChamps.adresse] as String,
      codePostal: json[InfosPraticienChamps.codePostal] as String,
      ville: json[InfosPraticienChamps.ville] as String,
      numeroTelephone: json[InfosPraticienChamps.numeroTelephone] as String,
      email: json[InfosPraticienChamps.email] as String,
      numeroADELI: json[InfosPraticienChamps.numeroADELI] as int,
      numeroSIRET: json[InfosPraticienChamps.numeroSIRET] as int,
      payementVirementBancaire:
          json[InfosPraticienChamps.payementVirementBancaire] == 0 ? false : true,
      payementCheque: json[InfosPraticienChamps.payementCheque]  == 0 ? false : true,
      payementCarteBleu: json[InfosPraticienChamps.payementCarteBleu]  == 0 ? false : true,
      payementLiquide: json[InfosPraticienChamps.payementLiquide]  == 0 ? false : true,
      exonererTVA: json[InfosPraticienChamps.exonererTVA] == 0 ? false : true);

  Map<String, Object?> toJson() => {
        InfosPraticienChamps.id: id,
        InfosPraticienChamps.nom: nom,
        InfosPraticienChamps.prenom: prenom,
        InfosPraticienChamps.adresse: adresse,
        InfosPraticienChamps.codePostal: codePostal,
        InfosPraticienChamps.ville: ville,
        InfosPraticienChamps.numeroTelephone: numeroTelephone,
        InfosPraticienChamps.email: email,
        InfosPraticienChamps.numeroADELI: numeroADELI,
        InfosPraticienChamps.numeroSIRET: numeroSIRET,
        InfosPraticienChamps.payementVirementBancaire: payementVirementBancaire,
        InfosPraticienChamps.payementCheque: payementCheque,
        InfosPraticienChamps.payementCarteBleu: payementCarteBleu,
        InfosPraticienChamps.payementLiquide: payementLiquide,
        InfosPraticienChamps.exonererTVA: exonererTVA,
      };
}

class TypePayementChamps {
  static final List<String> values = [
    // Ajouter tous les champs
    key,
    selectionner,
  ];

  static const String key = 'key';
  static const String selectionner = 'selectionner';
}

class TypePayement {
  String key;
  bool selectionner;

  TypePayement({required this.key, required this.selectionner});

  static TypePayement fromJson(Map<String, dynamic> json) => TypePayement(
        key: json[TypePayementChamps.key] as String,
        selectionner: json[TypePayementChamps.selectionner] as bool,
      );

  static List<TypePayement> getListTypePaymentFromDynamic(List<dynamic> l) {
    List<TypePayement> listReturn = [];
    for (dynamic element in l) {
      listReturn.add(TypePayement(
          key: element["key"], selectionner: element["selectionner"]));
    }
    return listReturn;
  }

  Map<String, Object?> toJson() => {
        TypePayementChamps.key: key,
        TypePayementChamps.selectionner: selectionner,
      };
}

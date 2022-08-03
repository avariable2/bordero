const String tableUtilisateur = 'utilisateur';
const String aSetCesInfos = "aSetCesInfos";

class UtilisateurChamps {
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

class Utilisateur {
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
  final int payementVirementBancaire;
  final int payementCheque;
  final int payementCarteBleu;
  final int payementLiquide;
  final int exonererTVA;

  const Utilisateur(
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

  Utilisateur copy(
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
            int? payementVirementBancaire,
            int? payementCheque,
            int? payementCarteBleu,
            int? payementLiquide,
            int? exonererTVA}) =>
      Utilisateur(
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

  Utilisateur.fromJson(Map<String, dynamic> json)
      : id = json[UtilisateurChamps.id] as int?,
        nom = json[UtilisateurChamps.nom] as String,
        prenom = json[UtilisateurChamps.prenom] as String,
        adresse = json[UtilisateurChamps.adresse] as String,
        codePostal = json[UtilisateurChamps.codePostal] as String,
        ville = json[UtilisateurChamps.ville] as String,
        numeroTelephone = json[UtilisateurChamps.numeroTelephone] as String,
        email = json[UtilisateurChamps.email] as String,
        numeroADELI = json[UtilisateurChamps.numeroADELI] as int,
        numeroSIRET = json[UtilisateurChamps.numeroSIRET] as int,
        payementVirementBancaire =
            json[UtilisateurChamps.payementVirementBancaire] as int,
        payementCheque =
            json[UtilisateurChamps.payementCheque]as int,
        payementCarteBleu =
            json[UtilisateurChamps.payementCarteBleu]as int,
        payementLiquide =
            json[UtilisateurChamps.payementLiquide]as int,
        exonererTVA = json[UtilisateurChamps.exonererTVA] as int;

  Map<String, dynamic> toJson() => {
        UtilisateurChamps.id: id,
        UtilisateurChamps.nom: nom,
        UtilisateurChamps.prenom: prenom,
        UtilisateurChamps.adresse: adresse,
        UtilisateurChamps.codePostal: codePostal,
        UtilisateurChamps.ville: ville,
        UtilisateurChamps.numeroTelephone: numeroTelephone,
        UtilisateurChamps.email: email,
        UtilisateurChamps.numeroADELI: numeroADELI,
        UtilisateurChamps.numeroSIRET: numeroSIRET,
        UtilisateurChamps.payementVirementBancaire: payementVirementBancaire,
        UtilisateurChamps.payementCheque: payementCheque,
        UtilisateurChamps.payementCarteBleu: payementCarteBleu,
        UtilisateurChamps.payementLiquide: payementLiquide,
        UtilisateurChamps.exonererTVA: exonererTVA,
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

import 'package:app_psy/model/client.dart';
import 'package:app_psy/model/facture.dart';
import 'package:app_psy/model/utilisateur.dart';
import 'package:app_psy/model/type_acte.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AppPsyDatabase {
  final int VERSION_DBB = 14;

  static final AppPsyDatabase instance = AppPsyDatabase._init();

  static Database? _database;

  AppPsyDatabase._init();

  Future<Database> get database async {
    if (_database != null ) return _database!;

    _database = await _initDB('app_psy.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(path, version: VERSION_DBB, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL';
    const stringType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const integerType = 'NUMBER NOT NULL';
    const booleanType = 'BIT(1) NOT NULL';
    const blobType = 'BLOB NOT NULL';

    await db.execute(''' 
    CREATE TABLE $tableClient(
    ${ClientChamps.id} $idType,
    ${ClientChamps.nom} $stringType,
    ${ClientChamps.prenom} $stringType,
    ${ClientChamps.adresse} $stringType,
    ${ClientChamps.codePostal} $stringType,
    ${ClientChamps.ville} $stringType,
    ${ClientChamps.numeroTelephone} $stringType,
    ${ClientChamps.email} $stringType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableTypeActe(
    ${TypeActeChamps.id} $idType,
    ${TypeActeChamps.nom} $stringType,
    ${TypeActeChamps.prix} $doubleType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableFacture(
    ${FactureChamps.id} $idType,
    ${FactureChamps.nom} $stringType,
    ${FactureChamps.fichier} $blobType
    )
    ''');
  }

  /// CLIENTS ///
  
  Future<int> nbClients() async{
    final db = await instance.database;
    int result = 0;
    try {
      result = db.rawQuery('SELECT COUNT(*) FROM $tableClient') as int;
    } catch(exception, stackTrace ) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      print("ERROR requete : $exception");
    }
    return result;
  }

  Future<bool> createClient(Client client) async {
    final db = await instance.database;

    // -- POSSIBLE de le faire a la main soit même --
    // final json = client.toJson();
    // final columns = '${ClientChamps.id}, ${ClientChamps.nom}, ${ClientChamps.prenom}, ... ';
    // final values = '${json[ClientChamps.id]}, ${json[ClientChamps.nom]}, ${json[ClientChamps.prenom]}, ...';
    // final id = await db.rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');
    int result = 0;
    try {
      result = await db.insert(tableClient, client.toJson());
    } catch(exception, stackTrace ) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      print("0 success for create client");
    }

    return result > 0 ? true : false;
  }

  Future<Client?> readClient(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableClient,
      columns: ClientChamps.values,
      where: '${ClientChamps.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Client.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<bool> readIfClientIsAlreadySet(String nom, String prenom) async {
    final db = await instance.database;

    final maps = await db.query(
      tableClient,
      columns: ClientChamps.values,
      where: '${ClientChamps.nom} = ? AND ${ClientChamps.prenom} = ?',
      whereArgs: [nom, prenom],
    );

    return maps.isEmpty ? false : true; // Si c'est vide pas de user
  }

  Future<List<Client>> readAllClient() async {
    final db = await instance.database;

    //const orderBy = '${ClientChamps.nom} ASC';
    //final result = await db.query(tableClient, orderBy: orderBy);
    final result = await db.query(tableClient);

    return result.map((json) => Client.fromJson(json)).toList();
  }

  Future<int> updateClient(Client client) async {
    final db = await instance.database;

    return db.update(
      tableClient,
      client.toJson(),
      where: '${ClientChamps.id} = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> deleteClient(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableClient,
      where: '${ClientChamps.id} = ?',
      whereArgs: [id],
    );
  }

  /// TYPE D'ACTE ///

  Future<int> nbTypeActe() async{
    final db = await instance.database;
    int result = 0;
    try {
      result = db.rawQuery('SELECT COUNT(*) FROM $tableTypeActe') as int;
    } catch(exception, stackTrace ) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      print("ERROR requete : $exception");
    }
    return result;
  }

  Future<bool> createTypeActe(TypeActe typeActe) async {
    final db = await instance.database;
    int result = 0;

    try {
      result = await db.insert(tableTypeActe, typeActe.toJson());
    } catch(exception, stackTrace ) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      print("0 success for create TypeActe");
    }

    return result > 0 ? true : false;
  }

  Future<TypeActe?> readTypeActe(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTypeActe,
      columns: TypeActeChamps.values,
      where: '${TypeActeChamps.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TypeActe.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<bool> readIfTypeActeIsAlreadySet(String nom) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTypeActe,
      columns: TypeActeChamps.values,
      where: '${TypeActeChamps.nom} = ?',
      whereArgs: [nom],
    );

    return maps.isEmpty ? false : true; // Si c'est vide pas de user
  }

  Future<List<TypeActe>> readAllTypeActe() async {
    final db = await instance.database;

    //const orderBy = '${ClientChamps.nom} ASC';
    //final result = await db.query(tableClient, orderBy: orderBy);
    final result = await db.query(tableTypeActe);

    return result.map((json) => TypeActe.fromJson(json)).toList();
  }

  Future<int> updateTypeActe(TypeActe typeActe) async {
    final db = await instance.database;

    return db.update(
      tableTypeActe,
      typeActe.toJson(),
      where: '${TypeActeChamps.id} = ?',
      whereArgs: [typeActe.id],
    );
  }

  Future<int> deleteTypeActe(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTypeActe,
      where: '${TypeActeChamps.id} = ?',
      whereArgs: [id],
    );
  }

  /// FACTURE

  Future<bool> createFactureInDB(Facture facture) async {
    final db = await instance.database;
    int result = 0;

    try {
      result = await db.insert(tableFacture, facture.toJson());
    } catch(exception, stackTrace ) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      print("0 success for create TypeActe");
    }

    return result > 0 ? true : false;
  }

  Future<List<InfoPageFacture>> getAllFileName() async {
    final db = await instance.database;

    final result = await db.query(
      tableFacture,
      columns: [FactureChamps.values[0], FactureChamps.values[1]],
    );

    return result.map((json) => InfoPageFacture.fromJson(json)).toList();
  }

  Future<Facture?> readFacture(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableFacture,
      columns: FactureChamps.values,
      where: '${FactureChamps.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Facture.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<bool> readIfFactureIsAlreadySet(String nom) async {
    final db = await instance.database;

    final maps = await db.query(
      tableFacture,
      columns: FactureChamps.values,
      where: '${FactureChamps.nom} = ?',
      whereArgs: [nom],
    );

    return maps.isEmpty ? false : true; // Si c'est vide pas de user
  }

  Future<List<Facture>> readAllFacture() async {
    final db = await instance.database;

    final result = await db.query(tableFacture);

    return result.map((json) => Facture.fromJson(json)).toList();
  }

  Future<int> updateFacture(Facture facture) async {
    final db = await instance.database;

    return db.update(
      tableFacture,
      facture.toJson(),
      where: '${FactureChamps.id} = ?',
      whereArgs: [facture.id],
    );
  }

  Future<int> deleteFacture(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableFacture,
      where: '${FactureChamps.id} = ?',
      whereArgs: [id],
    );
  }

  /// BDDD

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
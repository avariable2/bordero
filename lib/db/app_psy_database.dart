import 'package:app_psy/model/client.dart';
import 'package:app_psy/model/type_acte.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AppPsyDatabase {
  final int VERSION_DBB = 6;

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
    const intType = 'INTEGER';

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
    ${TypeActeChamps.prix} $intType
    )
    ''');
  }

  /// CLIENTS ///

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
    } catch(e) {
      // ignore_for_file: avoid_print
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

  Future<bool> createTypeActe(TypeActe typeActe) async {
    final db = await instance.database;
    int result = 0;

    try {
      result = await db.insert(tableTypeActe, typeActe.toJson());
    } catch(e) {
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

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
import 'package:app_psy/model/client.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class ClientDatabase {
  static final ClientDatabase instance = ClientDatabase._init();

  static Database? _database;

  ClientDatabase._init();

  Future<Database> get database async {
    if (_database != null ) return _database!;

    _database = await _initDB('client.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const stringType = 'TEXT NOT NULL';

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
  }

  Future<bool> create(Client client) async {
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

  Future<int> update(Client client) async {
    final db = await instance.database;

    return db.update(
      tableClient,
      client.toJson(),
      where: '${ClientChamps.id} = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableClient,
      where: '${ClientChamps.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
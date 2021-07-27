import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:monopoly_debt_tracker/models/users.dart';
import 'package:monopoly_debt_tracker/models/debts.dart';

class MonopolyDatabase
{
  static final MonopolyDatabase instance = MonopolyDatabase._init();

  static Database? _database;

  MonopolyDatabase._init();

  Future<Database> get database async
  {
    if (_database != null)  return _database!;

    _database = await _initDB('monpoly.db');
    return _database!;
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> _initDB(String filePath) async
  {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB, onConfigure: _onConfigure);
  }



  Future _createDB(Database db, int version) async
  {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
   // final floatType = 'DOUBLE NOT NULL';
    final numberType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableUsers(
      ${UserFields.uid} $idType,
      ${UserFields.fName} $textType,
      ${UserFields.lName} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableDebts(
      ${DebtsFields.debtId} $idType,
      ${DebtsFields.uid} $numberType,
      ${DebtsFields.dtID} $numberType,
      ${DebtsFields.amount} $numberType,
      "FOREIGN KEY (${DebtsFields.uid}) REFERENCES $tableUsers (${UserFields.uid}) ON DELETE NO ACTION ON UPDATE NO ACTION" 
    )
    ''');
  }

  /**
   * TODO USERS CRUD FUNCTIONS (TODO USED AS A HIGHLIGHT)
   */
  Future<Users> createUser(Users users) async
  {
      final db = await instance.database;
      
      final id = await db.insert(tableUsers, users.toJson());

      return users.copy(uid: id);
  }

  Future<Users> readUser(int id) async{
    final db = await instance.database;

    final maps = await db.query(
        tableUsers,
        columns: UserFields.values,
        where: '${UserFields.uid} = ?',
        whereArgs: [id]
    );

    if(maps.isNotEmpty)
    {
      return Users.fromJson(maps.first);
    }
    else{
      throw Exception('ID $id not found');
    }
  }

  Future<Users> readUserID(String fName) async{
    final db = await instance.database;

    final maps = await db.query(
        tableUsers,
        columns: UserFields.values,
        where: '${UserFields.fName} = ?',
        whereArgs: [fName]
    );

    if(maps.isNotEmpty)
    {
      return Users.fromJson(maps.first);
    }
    else{
      throw Exception('ID $fName not found');
    }
  }

  Future<List<Users>> readAllUsers() async
  {
    final db = await instance.database;

    final result = await db.query(tableUsers);

    return result.map((json) => Users.fromJson(json)).toList();
  }

  Future<int> updateUser (Users users) async
  {
    final db = await instance.database;
    
    return db.update(
        tableUsers,
        users.toJson(),
       where: '${UserFields.uid} = ?',
      whereArgs: [users.uid]
    );
  }

  Future<int> deleteUser (int id) async
  {
    final db = await instance.database;

    return await db.delete(
        tableUsers,
        where: '${UserFields.uid} = ?',
        whereArgs: [id]
    );
  }

  /**
   * TODO DEBTS CRUD FUNCTIONS (TODO USED AS A HIGHLIGHT)
   */

  Future<Debts> createDebt(Debts debts) async
  {
    final db = await instance.database;

    final id = await db.insert(tableDebts, debts.toJson());

    return debts.copy(debtId: id);
  }



  Future<Debts> readDebt(int id) async{
    final db = await instance.database;

    final maps = await db.query(
        tableDebts,
        columns: DebtsFields.values,
        where: '${DebtsFields.debtId} = ?',
        whereArgs: [id]
    );

    if(maps.isNotEmpty)
    {
      return Debts.fromJson(maps.first);
    }
    else{
      throw Exception('ID $id not found');
    }
  }

  Future<List<Debts>> getAllUserDebts (int id) async{
    final db = await instance.database;

    final maps = await db.rawQuery("SELECT * FROM $tableDebts WHERE ${DebtsFields.uid} = $id");


    return maps.map((json) => Debts.fromJson(json)).toList();


  }

  Future<List<Debts>> readAllDebts() async
  {
    final db = await instance.database;

    final result = await db.query(tableUsers);

    return result.map((json) => Debts.fromJson(json)).toList();
  }


  Future<int> updateDebt (Debts debts) async
  {
    final db = await instance.database;

    return db.update(
        tableDebts,
        debts.toJson(),
        where: '${DebtsFields.debtId} = ?',
        whereArgs: [debts.debtId]
    );
  }

  Future<int> deleteDebt (int id) async
  {
    final db = await instance.database;

    return await db.delete(
        tableDebts,
        where: '${DebtsFields.debtId} = ?',
        whereArgs: [id]
    );
  }


  Future close() async{
    final db = await instance.database;
    db.close();
  }
}
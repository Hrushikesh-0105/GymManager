import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _dbName = "myDatabase.db";
  static const _dbVersion = 1;
  static const _tableName = "myTable";
  static const columnId = "id";
  static const columnFullName = "fullName";
  static const columnPhoneNumber = "phoneNumber";
  static const columnEmailId = "emailId";
  static const columnMembership = "membership";
  static const columnPaidAmount = "paidAmount";
  static const columnDueAmount = "dueAmount";
  static const columnPaymentDate = "paymentDate";
  static const columnDueDate = "dueDate";
  static const columnPaymentMode = "paymentMode";
  static const columnStatus = "status";

// making it singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    //some code to create database in _database variable and return it
    _database = await _initiateDatabase();
    return _database!;
  }

  Future<Database> _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,
        _dbName); // joins directory path and db path and stores it in string
    return await openDatabase(path,
        version: _dbVersion,
        onCreate: _onCreate); // initializes the database and opens it
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tableName (
      $columnId INTEGER PRIMARY KEY,
      $columnFullName TEXT NOT NULL,
      $columnPhoneNumber TEXT NOT NULL,
      $columnEmailId TEXT NOT NULL,
      $columnMembership INTEGER NOT NULL,
      $columnPaidAmount TEXT NOT NULL,
      $columnDueAmount TEXT NOT NULL,
      $columnPaymentDate TEXT NOT NULL,
      $columnDueDate TEXT NOT NULL,
      $columnPaymentMode TEXT NOT NULL,
      $columnStatus TEXT NOT NULL
    )
  ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance
        .database; // db is a local variable to funtion, _instance.database calls the database funtion created earlier and returns the _database variable to db
    return await db.insert(_tableName,
        row); // it will return the primary key or unique id automatically generated
  }

  Future<List<Map<String, dynamic>>> quearyAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId]; //_cloumnId="id"
    return await db
        .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>> getCustomerById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results =
        await db.query(_tableName, where: '$columnId=?', whereArgs: [id]);
    return results.first;
  }
}

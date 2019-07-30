// reference: https://pusher.com/tutorials/local-data-flutter

import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableRecords = 'records';
final String columnId = '_id';
final String columnResult = 'result';
final String columnSwitched = 'switched';

// data model class
class Record {

  int id;
  String result;
  String switched;

  Record();

  // convenience constructor to create a Word object
  Record.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    result = map[columnResult];
    switched = map[columnSwitched];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnResult: result,
      columnSwitched: switched
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "GameResults.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableRecords (
                $columnId INTEGER PRIMARY KEY,
                $columnResult TEXT NOT NULL,
                $columnSwitched TEXT NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Record record) async {
    Database db = await database;
    int id = await db.insert(tableRecords, record.toMap());
    return id;
  }

  Future<List<Record>> getRecords() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM records");
    List<Record> list =
    res.isNotEmpty ? res.map((c) => Record.fromMap(c)).toList() : [];
    return list;
  }
}
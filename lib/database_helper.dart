import 'dart:core';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'diary_entry.dart';
import 'dart:async';


class DatabaseHelper {
  static const _databaseName =  "myDiaryDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'diary_entries';
  final _controller = StreamController<void>.broadcast();
  Stream<void> get diaryEntriesUpdateStream => _controller.stream;

  void _notifyListeners() {
    _controller.sink.add(null);
  }

  Future<void> dispose() async{
    await _controller.close();
  }

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  
  Future <Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate
    );
  }

  

  Future<void> deleteDiaryEntry(int id) async {
    final db = await instance.database;
    await db?.delete(
      'diary_entries', // テーブル名
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  delete(String table, {String? where, List<Object?>? whereArgs}) async {
    final db = await instance.database;
    return await db?.delete(table, where: where, whereArgs: whereArgs);
  }  

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (    
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        date TEXT NOT NULL,
        place TEXT,
        imagePath TEXT
        )''');
  }


  Future<int> insertDiaryEntry(DiaryEntry diaryEntry) async {
        final db = await database;
        /*
        await db!.insert(
            table,
            diaryEntry.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
        */
        final id =  await db!.insert(
            table,
            diaryEntry.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return id;
  }
    
    

  Future<List<DiaryEntry>> queryAllDiaryEntries() async {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db!.query(table);

        return List.generate(maps.length, (i) {
            return DiaryEntry.fromMap(maps[i]);
        });
  }

  Future<void> insertDiary(DiaryEntry diaryEntry) async {
        final db = await database;
        await db!.insert(
            table,
            diaryEntry.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
        _notifyListeners();
    
  }

  Future<int> updateDiaryEntry(DiaryEntry diaryEntry) async {
    final db = await database;
    int result = await db!.update(
      table, 
      diaryEntry.toMap(),
      where: 'id = ?',
      whereArgs: [diaryEntry.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _notifyListeners(); 
    return result;
  }


}  




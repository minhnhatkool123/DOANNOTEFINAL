import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:doannote/entities/note.dart';

class Databaseapp {
  static Databaseapp _databaseapp;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPathimage = 'pathimage';
  String colDate = 'date';
  String colColor = 'color';

  String colngay = 'ngay';
  String colthang = 'thang';
  String colnam = 'nam';
  String colgio = 'gio';
  String colphut = 'phut';
  String colthongbao = 'thongbao';

  Databaseapp._createInstance();
  factory Databaseapp() {
    if (_databaseapp == null) {
      _databaseapp = Databaseapp._createInstance();
    }
    return _databaseapp;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  initializeDatabase() async {
    var noteDatabase = await openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      version: 1,
      onCreate: _createDb,
    );
    print('DB IS  ' + await getDatabasesPath());
    return noteDatabase;
  }

  void _createDb(Database db, int newversion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colPathimage TEXT, $colColor INTEGER,$colDate TEXT,$colngay INTEGER,$colthang INTEGER,$colnam INTEGER,$colgio INTEGER,$colphut INTEGER,$colthongbao INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable);
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<void> updateNote(Note note) async {
    Database db = await this.database;
    await db.update(noteTable, note.toMap(),
        where: "$colId=?", whereArgs: [note.id]);
  }

  Future<void> deleteNote(int id) async {
    Database db = await this.database;
    await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    List<Note> listNote = List<Note>();
    noteMapList.forEach((element) {
      listNote.add(Note.fromMapObject(element));
    });
    //print(listNote[0].title);
    return listNote;
  }
}

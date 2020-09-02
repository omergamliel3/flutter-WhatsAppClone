import 'dart:io';

import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:sqflite/sqflite.dart';

import 'package:WhatsAppClone/core/models/chat.dart';

abstract class DBservice {
  // constants
  static const _kDbFileName = 'sqflite_ex.db';
  static const _kDbTableName = 'chats_table';
  // class attributes
  static Database _db;
  static final AsyncMemoizer _memoizer = AsyncMemoizer();

  /// Init DB, run only once
  static Future<bool> asyncInitDB() async {
    // Avoid this function to be called multiple times
    return await _memoizer.runOnce(() async {
      return await initDb();
    });
  }

  // Opens a db local file. Creates the db table if it's not yet created.
  static Future<bool> initDb() async {
    try {
      // get database path directory
      final dbFolder = await getDatabasesPath();
      if (!await Directory(dbFolder).exists()) {
        await Directory(dbFolder).create(recursive: true);
      }
      final dbPath = join(dbFolder, _kDbFileName);
      // open db
      _db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (Database db, int version) async {
          await _createChatsTable(db);
        },
      );
      // success init db
      return true;
    } catch (e) {
      // failed to init db
      print(e);
      return false;
    }
  }

  /// Delete the database
  static Future<void> deleteDB() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, _kDbFileName);
    await deleteDatabase(dbPath);
    _db = null;
  }

  // execute chats table
  static Future<void> _createChatsTable(Database db) async {
    await db.execute('''
        CREATE TABLE $_kDbTableName(
          id INTEGER PRIMARY KEY, 
          name TEXT,
          lastMessage TEXT,
          messages TEXT
          )
        ''');
  }

  /// clear chat table
  static Future<void> clearTable(String tableName) async {
    await _db.rawDelete('''DELETE FROM $tableName''');
  }

  /// drop chat table from db
  static Future<void> dropTable(String tableName) async {
    await _db.execute("DROP TABLE IF EXISTS $tableName");
  }

  /// Reertieves chats from db chats table
  static Future<List<Chat>> getChats() async {
    List<Map> jsons = await _db.rawQuery('SELECT * FROM $_kDbTableName');
    return jsons.map((e) => Chat.fromJsonMap(e));
  }

  /// insert new chat to chats db table
  static Future<bool> createChat(Chat chat) async {
    try {
      // insert new element to the table
      await _db.transaction(
        (Transaction txn) async {
          await txn.rawInsert('''
          INSERT INTO $_kDbTableName
            (
          name TEXT,
          lastMessage TEXT,
          messages TEXT)
          VALUES
            (
              "${chat.name}",
              "${chat.lastMessage}", 
              "${chat.messages}"   
            )''');
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

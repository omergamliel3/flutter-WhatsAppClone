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
  static Database _db; // db instace
  static final AsyncMemoizer _memoizer = AsyncMemoizer(); // async memoizer
  static List<Chat> _activePrivateChats; // holds active private chats data

  /// active private chats getter
  static List<Chat> get activePrivateChats => List.from(_activePrivateChats);

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
      _activePrivateChats = await getChats();
      // success init db
      return true;
    } catch (e) {
      // failed to init db
      print(e);
      return false;
    }
  }

  // execute chats table
  static Future<void> _createChatsTable(Database db) async {
    await db.execute('''
        CREATE TABLE $_kDbTableName(
          id INTEGER PRIMARY KEY, 
          name TEXT,
          timestamp TEXT,
          messages TEXT
          )
        ''');
  }

  /// clear chat table
  static Future<void> clearTable() async {
    await _db.rawDelete('''DELETE FROM $_kDbTableName''');
  }

  /// Reertieves chats from db chats table
  static Future<List<Chat>> getChats() async {
    List<Map> jsons = await _db.rawQuery('SELECT * FROM $_kDbTableName');
    return jsons.map((e) => Chat.fromJsonMap(e)).toList();
  }

  /// insert new chat to chats db table
  static Future<bool> createChat(Chat chat) async {
    try {
      // insert new element to the table
      await _db.transaction(
        (Transaction txn) async {
          int id = await txn.rawInsert('''
          INSERT INTO $_kDbTableName 
          (
          name,
          timestamp,
          messages)
          VALUES
            (
              "${chat.name}",
              "${chat.timestamp}", 
              "${chat.messages}"   
            )''');
          print('create new record with id: $id');
        },
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> createChatsData() async {
    //await clearTable();
    // await createChat(Chat(
    //     name: 'Tal Dahan',
    //     timestamp: DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
    //     messages: 'Good night'));
    // await createChat(Chat(
    //     name: 'Ohad Shabat',
    //     timestamp:
    //         DateTime.now().subtract(Duration(hours: 3)).toIso8601String(),
    //     messages: 'Hey'));
    // await createChat(Chat(
    //     name: 'Amit Bar',
    //     timestamp: DateTime.now().toIso8601String(),
    //     messages: 'LOL'));
    // await createChat(Chat(
    //     name: 'Yarden Reich',
    //     timestamp: DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
    //     messages: 'LMAO ROFL'));

    //_activePrivateChats = await getChats();
  }
}

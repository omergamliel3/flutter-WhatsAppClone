import 'dart:io';

import 'package:WhatsAppClone/core/models/message.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:sqflite/sqflite.dart';

import 'package:WhatsAppClone/core/models/contact_entity.dart';

class DBservice {
  DBservice._();
  // constants
  static const _kDbFileName = 'sqflite_ex.db';
  static const _kDBTableContacts = 'contacts_table';
  static const _kDBTableMsgs = 'messages_table';
  // class attributes
  static Database _db; // db instace
  static final AsyncMemoizer _memoizer = AsyncMemoizer(); // async memoizer

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
          await db.execute('''
          CREATE TABLE $_kDBTableContacts(
          id INTEGER PRIMARY KEY, 
          displayName TEXT,
          phoneNumber TEXT,
          lastMsg TEXT,
          lastMsgTime INTEGER
          )
        ''');
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

  /// delete contact entity from db contacts_table
  static Future<void> deleteContactEntity(ContactEntity contactEntity) async {
    await _db.rawDelete('''
    DELETE FROM $_kDBTableContacts
    WHERE id = "${contactEntity.id}"
    ''');
  }

  /// Reertieves contact entities from db contacts_table
  static Future<List<ContactEntity>> getContactEntites() async {
    List<Map> jsons = await _db.rawQuery('SELECT * FROM $_kDBTableContacts');
    return jsons.map((e) => ContactEntity.fromJsonMap(e)).toList();
  }

  /// insert new contact entity
  static Future<bool> insertContactEntity(ContactEntity contactEntity) async {
    try {
      await _db.transaction(
        (Transaction txn) async {
          int id = await txn.rawInsert('''
          INSERT INTO $_kDBTableContacts 
          (
          displayName,
          phoneNumber,
          lastMsg,
          lastMsgTime)
          VALUES
            (
              "${contactEntity.displayName}",
              "${contactEntity.phoneNumber}",
              "${contactEntity.lastMsg}",
              "${contactEntity.lastMsgTime.millisecondsSinceEpoch}"
            )''');
          print('create new record with id: $id');
        },
      );

      // success created new chat in db chats table
      return true;
    } catch (e) {
      print(e);
      // failed to create new chat in db chats table
      return false;
    }
  }

  /// get messsages, related to the ContactEntity
  static Future<List<Message>> getMessages(ContactEntity contactEntity) async {
    List<Map> jsons = await _db.rawQuery(
        'SELECT * FROM $_kDBTableMsgs WHERE foreignID = ?', [contactEntity.id]);
    return jsons.map((e) => Message.fromJsonMap(e)).toList();
  }

  /// insert new message
  static Future<bool> insertMessage(Message message) async {
    try {
      await _db.transaction((Transaction txn) async {
        int id = await txn.rawInsert('''INSERT INTO $_kDBTableMsgs
        ( 
          foreignID,
          text,
          timestamp
        ) 
        VALUES
        (
          "${message.foreignID}",
          "${message.text}",
          "${message.timestamp}"
        )
        ''');
        print('create new record with id: $id');
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

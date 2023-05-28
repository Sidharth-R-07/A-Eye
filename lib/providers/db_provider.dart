import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:open_ai/models/message_model.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider with ChangeNotifier {
  late Database database;

  List<MessageModel> historyList = [];
  Future<void> openDb() async {
    // open the database
    database = await openDatabase("Aeye.db", version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Aeye (id INTEGER PRIMARY KEY, msg TEXT, chatIndex INTEGER,createAt TEXT)');
    });
  }

  Future<void> getAllHistory() async {
    final fetchedData = await database.rawQuery('SELECT * FROM Aeye');

    final tempList =
        fetchedData.map<MessageModel>((e) => MessageModel.fromJson(e)).toList();
    final reversedList = tempList.reversed;

    historyList = reversedList.toList();

    notifyListeners();
  }

  Future<void> addToHistory(MessageModel message) async {
    final getId = await database.rawInsert(
        'INSERT INTO Aeye(msg, chatIndex, createAt) VALUES(?, ?, ?)',
        [message.message, 0, message.createAt]);
    log('HISTORY MSG ADDED :$getId');
    getAllHistory();
  }

  Future<void> clearAllHistory() async {
    await database.delete('Aeye');
    getAllHistory();
    notifyListeners();
    log('History cleared');
  }
}

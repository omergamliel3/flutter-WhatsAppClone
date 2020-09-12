import 'package:flutter/foundation.dart';

class Message {
  final int id;
  final int foreignID;
  final String text;
  final DateTime timestamp;

  Message(
      {this.id,
      @required this.foreignID,
      @required this.text,
      @required this.timestamp});

  Message.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'],
        foreignID = map['foreignID'],
        text = map['text'] ?? '?',
        timestamp = DateTime.fromMillisecondsSinceEpoch(map['timestamp']);

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'foreignID': foreignID,
        'text': text,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };
}

import 'package:flutter/foundation.dart';

class Message {
  final int id;
  final String text;
  final DateTime timestamp;

  Message({this.id, @required this.text, @required this.timestamp});

  Message.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'],
        text = map['text'] ?? '?',
        timestamp = DateTime.fromMillisecondsSinceEpoch(map['timestamp']);

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'text': text,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };
}

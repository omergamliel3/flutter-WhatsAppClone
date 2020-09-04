import 'package:flutter/foundation.dart';

class Chat {
  final int id;
  final String name;
  final String timestamp;
  final String messages;

  Chat(
      {this.id,
      @required this.name,
      @required this.timestamp,
      @required this.messages});

  Chat.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'] ?? '?',
        timestamp = map['timestamp'],
        messages = map['messages'];

  Map<String, dynamic> toJsonMap() =>
      {'id': id, 'name': name, 'timestamp': timestamp, 'messages': messages};
}

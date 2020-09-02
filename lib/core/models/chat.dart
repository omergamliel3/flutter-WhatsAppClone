import 'package:flutter/foundation.dart';

class Chat {
  final String name;
  final String timestamp;
  final String messages;

  Chat(
      {@required this.name, @required this.timestamp, @required this.messages});

  Chat.fromJsonMap(Map<String, dynamic> map)
      : name = map['name'] ?? '?',
        timestamp = map['timestamp'],
        messages = map['messages'];

  Map<String, dynamic> toJsonMap() =>
      {'name': name, 'timestamp': timestamp, 'messages': messages};
}

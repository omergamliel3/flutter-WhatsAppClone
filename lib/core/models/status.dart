import 'package:flutter/foundation.dart';

class Status {
  final String id;
  final String userName;
  final String content;
  final DateTime timestamp;

  Status(
      {this.id,
      @required this.userName,
      @required this.content,
      @required this.timestamp});

  Status.fromJsonMap(Map<String, dynamic> map, String id)
      : id = id,
        userName = map['username'],
        content = map['status'],
        timestamp = DateTime.parse(map['timestamp']);

  Map<String, dynamic> toJsonMap() => {
        'username': userName,
        'status': content,
        'timestamp': timestamp.toIso8601String()
      };
}

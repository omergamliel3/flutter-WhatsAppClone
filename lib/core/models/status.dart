import 'package:flutter/foundation.dart';

class Status {
  final String id;
  final String userName;
  final String profileUrl;
  final String content;
  final DateTime timestamp;

  Status(
      {this.id,
      @required this.userName,
      @required this.profileUrl,
      @required this.content,
      @required this.timestamp});

  Status.fromJsonMap(Map<String, dynamic> map, this.id)
      : userName = map['username'] as String,
        profileUrl = map['profileUrl'] as String,
        content = map['status'] as String,
        timestamp =
            DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int);

  Map<String, dynamic> toJsonMap() => {
        'username': userName,
        'profileUrl': profileUrl,
        'status': content,
        'timestamp': timestamp.millisecondsSinceEpoch
      };
}

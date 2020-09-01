import 'package:flutter/foundation.dart';

class Status {
  final String name;
  final String content;
  final DateTime dateTime;

  Status(
      {@required this.name, @required this.content, @required this.dateTime});

  Status.fromJsonMap(Map<String, dynamic> map)
      : name = map['name'],
        content = map['status'],
        dateTime = DateTime.parse(map['datetime']);

  Map<String, dynamic> toJsonMap() =>
      {'name': name, 'status': content, 'datetime': dateTime.toIso8601String()};
}

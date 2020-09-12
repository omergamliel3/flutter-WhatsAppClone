import 'package:flutter/foundation.dart';

class ContactEntity {
  final int id;
  final String displayName;
  final String phoneNumber;
  final String lastMsg;
  final DateTime lastMsgTime;

  ContactEntity(
      {this.id,
      @required this.displayName,
      @required this.phoneNumber,
      this.lastMsg,
      this.lastMsgTime});

  ContactEntity.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'],
        displayName = map['name'] ?? 'unKnown',
        phoneNumber = map['phoneNumber'] ?? 'unKnown',
        lastMsg = map['lastMsg'],
        lastMsgTime = DateTime.fromMillisecondsSinceEpoch(map['lastMsgTime']);

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'lastMsg': lastMsg,
        'lastMsgTime': lastMsgTime.millisecondsSinceEpoch,
      };
}

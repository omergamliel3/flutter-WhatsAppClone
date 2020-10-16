import 'package:flutter/foundation.dart';

enum MessageType { text, image }

class Message {
  final int id;
  final int foreignID;
  final String text;
  final bool fromUser;
  final DateTime timestamp;
  final MessageType messageType;

  Message(
      {this.id,
      @required this.foreignID,
      @required this.text,
      @required this.fromUser,
      @required this.timestamp,
      @required this.messageType});

  Message.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        foreignID = map['foreignID'] as int,
        text = map['text'] as String ?? '?',
        fromUser = map['fromUser'] == 0,
        timestamp =
            DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
        messageType =
            map['messageType'] == 'text' ? MessageType.text : MessageType.image;

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'foreignID': foreignID,
        'text': text,
        'fromUser': fromUser ? 0 : 1,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'messageType': messageType.toString().split('.')[1]
      };
}

import 'package:flutter/foundation.dart';

class Chat {
  final String name;
  final String lastMessage;
  final String messages;

  Chat(
      {@required this.name,
      @required this.lastMessage,
      @required this.messages});

  Chat.fromJsonMap(Map<String, dynamic> map)
      : name = map['name'],
        lastMessage = map['lastMessage'],
        messages = map['messages'];

  Map<String, dynamic> toJsonMap() =>
      {'name': name, 'lastMessage': lastMessage, 'messages': messages};
}

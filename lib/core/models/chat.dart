class Chat {
  final String name;
  final String lastMessage;
  final String messages;

  Chat({this.name, this.lastMessage, this.messages});

  Chat.fromJsonMap(Map<String, dynamic> map)
      : name = map['name'],
        lastMessage = map['lastMessage'],
        messages = map['messages'];

  Map<String, dynamic> toJsonMap() =>
      {'name': name, 'lastMessage': lastMessage, 'messages': messages};
}

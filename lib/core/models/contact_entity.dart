import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ContactEntity extends Equatable {
  final int id;
  final String displayName;
  final String phoneNumber;
  final String lastMsg;
  final DateTime lastMsgTime;

  const ContactEntity(
      {this.id,
      @required this.displayName,
      @required this.phoneNumber,
      this.lastMsg,
      this.lastMsgTime});

  ContactEntity.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        displayName = map['displayName'] as String ?? 'unKnown',
        phoneNumber = map['phoneNumber'] as String ?? 'unKnown',
        lastMsg = map['lastMsg'] as String,
        lastMsgTime =
            DateTime.fromMillisecondsSinceEpoch(map['lastMsgTime'] as int);

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'lastMsg': lastMsg,
        'lastMsgTime': lastMsgTime?.millisecondsSinceEpoch,
      };

  @override
  List<Object> get props => [displayName, phoneNumber, lastMsg, lastMsgTime];
}

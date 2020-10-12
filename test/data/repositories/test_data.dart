import 'package:WhatsAppClone/core/models/contact_entity.dart';
import 'package:WhatsAppClone/core/models/message.dart';

// active contacts data
var localDatabaseContactsEntites = <ContactEntity>[
  ContactEntity(
      displayName: 'omer',
      phoneNumber: '050',
      lastMsg: 'hi',
      lastMsgTime: DateTime.now()),
  ContactEntity(
      displayName: 'tal',
      phoneNumber: '058',
      lastMsg: 'hello',
      lastMsgTime: DateTime.now()),
  ContactEntity(
      displayName: 'ohad',
      phoneNumber: '052',
      lastMsg: 'bye',
      lastMsgTime: DateTime.now())
];
// un active contacts data
var contactsHandlerEntites = <ContactEntity>[
  ContactEntity(
      displayName: 'asaf',
      phoneNumber: '052',
      lastMsg: 'lol',
      lastMsgTime: DateTime.now()),
  ContactEntity(
      displayName: 'yarden',
      phoneNumber: '052',
      lastMsg: 'kkk',
      lastMsgTime: DateTime.now()),
  ContactEntity(
      displayName: 'ofek',
      phoneNumber: '052',
      lastMsg: 'lmao',
      lastMsgTime: DateTime.now()),
];

var message = Message(
    foreignID: 0,
    fromUser: true,
    text: 'hello',
    timestamp: DateTime.now(),
    id: 0);

var contactEntity = ContactEntity(
    displayName: 'omer braude',
    phoneNumber: '052',
    lastMsg: 'asdasdasd',
    lastMsgTime: DateTime.now());

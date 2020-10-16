import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'chats_viewmodel.dart';

import '../../core/models/contact_entity.dart';

import '../../utils/datetime.dart';

class ChatsPage extends StatelessWidget {
  Widget _buildEmptyContact(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        alignment: Alignment.topCenter,
        child: Text(
          '',
          style: Theme.of(context).textTheme.headline5,
        ));
  }

  // build contact list tile widget
  Widget _buildContactListTile(
      ContactEntity contactEntity, int index, ChatsViewModel model) {
    final name = contactEntity.displayName ?? 'unKnown';
    final lastMessage =
        contactEntity.lastMsg == 'null' ? '' : contactEntity.lastMsg;
    final timeAgo = contactEntity.lastMsgTime == null
        ? ''
        : formatDateTime(contactEntity.lastMsgTime);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          name[0],
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(name),
      subtitle: Text(lastMessage),
      trailing: Text(timeAgo),
      onTap: () {
        model.navigatePrivateChatView(contactEntity);
      },
    );
  }

  // build contact chats listview
  Widget _buildContactChats(BuildContext context, ChatsViewModel model) {
    // order contacts data by date time decending
    var contacts = model.activeContacts;
    if (contacts.isEmpty) {
      return _buildEmptyContact(context);
    }
    contacts.sort((a, b) => a.lastMsgTime.compareTo(b.lastMsgTime));
    contacts = contacts.reversed.toList();

    return ListView.separated(
        separatorBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(left: 70.0, right: 10),
            child: Divider(thickness: 2.0),
          );
        },
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Container(
              key: ValueKey('chat$index'),
              child: _buildContactListTile(contacts[index], index, model));
        });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatsViewModel>.reactive(
        builder: (context, model, child) {
          return Scaffold(
            body: _buildContactChats(context, model),
          );
        },
        viewModelBuilder: () => ChatsViewModel());
  }
}

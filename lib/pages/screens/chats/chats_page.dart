import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:WhatsAppClone/core/models/chat.dart';

import 'package:WhatsAppClone/core/provider/main.dart';

import 'package:WhatsAppClone/helpers/navigator_helper.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with AutomaticKeepAliveClientMixin {
  // build global chat listile
  Widget _buildGlobalChat() {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('GL', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 4.0),
          Icon(Icons.language)
        ],
      ),
      title: Text('Chat room'),
      subtitle: Text('last message'),
      trailing: Text('timeago'),
      onTap: () {
        // navigate global chat room
        print('navigate global chat room');
      },
    );
  }

  // build contact list tile widget
  Widget _buildContactListTile(Chat chat, int index) {
    String name = chat.name;
    String lastMessage =
        chat.messages.isEmpty ? 'No messages' : chat.messages.split('1+_+1')[0];
    String timeAgo = chat.timestamp.toString().split(' ')[1].substring(0, 5);

    return ListTile(
      leading: CircleAvatar(
        child: Text(
          name[0],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey,
      ),
      title: Text(name),
      subtitle: Text(lastMessage),
      trailing: Text(timeAgo),
      onTap: () {
        NavigatorHelper.navigatePrivateChatSceen(context, chat);
      },
    );
  }

  // build contact chats listview
  Widget _buildContactChats() {
    return Selector<MainModel, List<Chat>>(
      selector: (context, model) => model.activeChats,
      builder: (context, data, child) {
        return Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 70.0, right: 10),
                    child: Divider(thickness: 2.0),
                  );
                },
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return _buildContactListTile(data[index], index);
                }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          _buildGlobalChat(),
          Divider(thickness: 1.5),
          _buildContactChats()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

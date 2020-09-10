import 'package:WhatsAppClone/services/local_storage/db_service.dart';
import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/models/chat.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class PrivateChatPage extends StatefulWidget {
  @override
  _PrivateChatPageState createState() => _PrivateChatPageState();

  final Chat chat;
  PrivateChatPage(this.chat);
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  TextEditingController _textEditingController;
  List<String> msgs = [];

  @override
  initState() {
    _textEditingController = TextEditingController();
    _getMessages();
    super.initState();
  }

  // build appbar popup menu button
  Widget _buildPopUpMenuButton() {
    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('View contact'),
          )),
          PopupMenuItem(
              child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('Search'),
          )),
          PopupMenuItem(
              child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('Mute notifications'),
          )),
          PopupMenuItem(
              child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('Wallpaper'),
          )),
          PopupMenuItem(
              child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('Clear chat'),
          )),
          PopupMenuItem(
              child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('Delete chat'),
          )),
        ];
      },
    );
  }

  // build messages list
  Widget _buildMsgList() {
    return Flexible(
        child: Scrollbar(
            child: ListView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: msgs.length,
      itemBuilder: (context, index) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: ListTile(
            title: Text(msgs[index]),
            trailing: Text(index.toString()),
          ),
        );
      },
    )));
  }

  // build compose message
  Widget _buildComposeMsg() {
    return Container(
      padding: EdgeInsets.only(left: 5.0, bottom: 4.0, right: 4.0),
      decoration: BoxDecoration(color: Theme.of(context).canvasColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              child: TextField(
            controller: _textEditingController,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration.collapsed(hintText: 'Send a message'),
            onSubmitted: _onTextMsgSubmitted,
          )),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _onTextMsgSubmitted(_textEditingController.text))
        ],
      ),
    );
  }

  // submitted text message
  void _onTextMsgSubmitted(String msg) async {
    if (msg == null || msg.isEmpty) return;
    await DBservice.insertMessage(widget.chat, msg);
    setState(() {
      msgs.add(msg);
    });
    _textEditingController.clear();
  }

  void _getMessages() async {
    msgs = await DBservice.getMessages(widget.chat);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.name),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () => UrlLauncher.launch('tel:'),
          ),
          _buildPopUpMenuButton()
        ],
      ),
      body: Column(
        children: [
          _buildMsgList(),
          Divider(
            height: 2.0,
            thickness: 1.0,
          ),
          _buildComposeMsg()
        ],
      ),
    );
  }
}

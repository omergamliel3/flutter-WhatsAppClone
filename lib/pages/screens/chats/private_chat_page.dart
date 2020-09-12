import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'package:WhatsAppClone/core/models/contact_entity.dart';
import 'package:WhatsAppClone/core/models/message.dart';

import 'package:WhatsAppClone/services/local_storage/db_service.dart';

import 'package:WhatsAppClone/core/widgets/ui_elements/spinkit_loading_indicator.dart';

class PrivateChatPage extends StatefulWidget {
  @override
  _PrivateChatPageState createState() => _PrivateChatPageState();

  final ContactEntity contactEntity;
  PrivateChatPage(this.contactEntity);
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  TextEditingController _textEditingController; // text controller
  Future<List<Message>> _msgs; // msgs data

  @override
  initState() {
    _textEditingController = TextEditingController();
    _msgs = DBservice.getMessages(widget.contactEntity);
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
    return FutureBuilder<List<Message>>(
      future: _msgs,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          return Flexible(
              child: Scrollbar(
                  child: ListView.builder(
            padding: const EdgeInsets.all(4.0),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: ListTile(
                  title: Text(snapshot.data[index].text),
                  trailing: Text(snapshot.data[index].timestamp.toString()),
                ),
              );
            },
          )));
        }
        return Center(child: SpinkitLoadingIndicator());
      },
    );
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
    Message message = Message(
        foreignID: widget.contactEntity.id,
        text: msg.trim(),
        timestamp: DateTime.now());
    // insert message to local db
    await DBservice.insertMessage(message);
    _textEditingController.clear();
    // get messages from local db and rebuild msgs list
    setState(() {
      _msgs = DBservice.getMessages(widget.contactEntity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactEntity.displayName),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () =>
                UrlLauncher.launch('tel:${widget.contactEntity.phoneNumber}'),
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

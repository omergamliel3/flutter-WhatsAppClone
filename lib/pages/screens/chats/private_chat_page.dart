import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../../../core/provider/main.dart';

import '../../../core/models/contact_entity.dart';
import '../../../core/models/message.dart';

import '../../../services/locator.dart';
import '../../../services/local_storage/db_service.dart';
import '../../../services/api/dialogflow.dart';

import '../../../core/shared/constants.dart';

import '../../../helpers/datetime.dart';

import '../../../core/widgets/ui_elements/spinkit_loading_indicator.dart';

class PrivateChatPage extends StatefulWidget {
  @override
  _PrivateChatPageState createState() => _PrivateChatPageState();

  final ContactEntity contactEntity;
  PrivateChatPage(this.contactEntity);
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  // get services
  final dbService = locator<DBservice>();
  final dialogflowAPI = locator<DialogFlowAPI>();
  TextEditingController _textEditingController; // text controller
  ScrollController _scrollController;
  Future<List<Message>> _msgs; // msgs data

  @override
  initState() {
    // init controllers
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    // init chat messages
    _msgs = dbService.getMessages(widget.contactEntity);
    // scroll messsages to the bottom of the listview
    _scrollToBottom(500);
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
            controller: _scrollController,
            padding: const EdgeInsets.all(4.0),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return _buildMessage(snapshot.data[index]);
            },
          )));
        }
        return Center(child: SpinkitLoadingIndicator());
      },
    );
  }

  // build message listile widget
  Widget _buildMessage(Message message) {
    var timestamp = formatDateTime(message.timestamp);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            message.fromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(text: message.text),
                  TextSpan(text: '  '),
                  TextSpan(
                      text: timestamp,
                      style: TextStyle(
                          color: Colors.grey[300],
                          fontStyle: FontStyle.italic,
                          fontSize: 12.0))
                ]),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              decoration: BoxDecoration(
                  color: message.fromUser ? kPrimaryColor : Colors.grey[800],
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
        ],
      ),
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
  void _onTextMsgSubmitted(String msg, {bool fromUser = true}) async {
    // non null of empty validation
    if (msg == null || msg.isEmpty) return;
    // clear text field
    if (fromUser) {
      _textEditingController.clear();
    }
    // create new Message instacne
    var message = Message(
        foreignID: widget.contactEntity.id,
        text: msg.trim(),
        fromUser: fromUser,
        timestamp: DateTime.now());
    // insert message to local db
    await dbService.insertMessage(message);
    // update active contacts
    Provider.of<MainModel>(context, listen: false).getActiveContacts();

    setState(() {
      // get messages from local db and rebuild msgs list
      _msgs = dbService.getMessages(widget.contactEntity);
      // scroll to bottom listview
      _scrollToBottom(0);
      // reponse from bot if message from user
      if (fromUser) {
        evokeMsgResponse(msg);
      }
    });
  }

  // submit message response from DialogFlow API
  void evokeMsgResponse(String query) async {
    var msgResponse = await dialogflowAPI.response(query);
    _onTextMsgSubmitted(msgResponse, fromUser: false);
  }

  // animate to bottom of messages listview
  void _scrollToBottom(int milliseconds) {
    Timer(
        Duration(milliseconds: 500),
        () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            ));
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
                url_launcher.launch('tel:${widget.contactEntity.phoneNumber}'),
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

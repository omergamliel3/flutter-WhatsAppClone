import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final int contatsLength = 15;

  Widget _buildContactListTile() {
    return ListTile(
      leading: CircleAvatar(),
      title: Text('Contact name'),
      subtitle: Text('Message'),
      trailing: Text('Time Ago'),
      dense: true,
      onTap: () {
        print('nativage call private chat');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
            physics: ScrollPhysics(),
            itemCount: contatsLength,
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: Divider(
                  thickness: 1.5,
                ),
              );
            },
            itemBuilder: (context, index) {
              return _buildContactListTile();
            }));
  }
}

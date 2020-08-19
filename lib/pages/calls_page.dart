import 'package:flutter/material.dart';

class CallsPage extends StatelessWidget {
  final int callsLength = 6;

  Widget _buildCallsListTile() {
    return ListTile(
      leading: CircleAvatar(),
      title: Text('Omer Braude'),
      subtitle: Text('Yesterday, 20:07'),
      trailing: Icon(Icons.call),
      dense: true,
      onTap: () {
        print('nativage call info');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            physics: ScrollPhysics(),
            itemCount: callsLength,
            itemBuilder: (context, index) {
              return _buildCallsListTile();
            }));
  }
}

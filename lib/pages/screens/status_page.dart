import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  final int statusLength = 1;

  Widget _buildStatusListTile() {
    return ListTile(
      leading: CircleAvatar(),
      title: Text('My status'),
      subtitle: Text('Tap to add status update'),
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
            itemCount: statusLength,
            itemBuilder: (context, index) {
              return _buildStatusListTile();
            }));
  }
}

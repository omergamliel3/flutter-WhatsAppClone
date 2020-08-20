import 'package:flutter/material.dart';

import 'package:call_log/call_log.dart';

class CallsPage extends StatefulWidget {
  @override
  _CallsPageState createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage>
    with AutomaticKeepAliveClientMixin {
  final int callsLength = 6;

  Widget _buildCallsListTile(CallLogEntry callLogEntry) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(callLogEntry.name),
      subtitle: Text(callLogEntry.timestamp.toString()),
      trailing: Icon(Icons.call),
      dense: true,
      onTap: () {
        print('nativage call info');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: FutureBuilder<Iterable<CallLogEntry>>(
      future: CallLog.get(),
      builder: (BuildContext context,
          AsyncSnapshot<Iterable<CallLogEntry>> snapshot) {
        if (snapshot.hasData) {
          List<CallLogEntry> callLogsData = snapshot.data.toList();
          if (callLogsData.length == 0) {
            return Container(
                padding: EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                child: Text(
                  'THERE ARE NO CALL LOGS',
                  style: Theme.of(context).textTheme.headline6,
                ));
          }
          return ListView.builder(
              physics: ScrollPhysics(),
              itemCount: callsLength,
              itemBuilder: (context, index) {
                return _buildCallsListTile(callLogsData[index]);
              });
        }
        return Center(child: CircularProgressIndicator());
      },
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

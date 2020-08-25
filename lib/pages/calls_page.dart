import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:call_log/call_log.dart';

class CallsPage extends StatefulWidget {
  @override
  _CallsPageState createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage>
    with AutomaticKeepAliveClientMixin {
  // call logs future
  Future<Iterable<CallLogEntry>> _callLogFuture;
  @override
  initState() {
    // init future
    _callLogFuture = CallLog.get();
    super.initState();
  }

  // call log list tile widget
  Widget _buildCallsListTile(CallLogEntry callLogEntry) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          callLogEntry.name[0].toUpperCase() ?? '?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(callLogEntry.name),
      subtitle: Text(callLogEntry.formattedNumber),
      trailing: Icon(Icons.call),
      dense: true,
      onTap: () {
        // launch device phone call
        UrlLauncher.launch('tel:+${callLogEntry.number}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: FutureBuilder<Iterable<CallLogEntry>>(
      future: _callLogFuture,
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
              itemCount: callLogsData.length,
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

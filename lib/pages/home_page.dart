import 'package:flutter/material.dart';

import 'package:WhatAppClone/pages/calls_page.dart';
import 'package:WhatAppClone/pages/chats_page.dart';
import 'package:WhatAppClone/pages/status_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Class Attributes
  TabController _tabController;
  int _pageIndex;
  IconData _fabIconData;
  bool _fabVisible;

  // init state method comment !!!
  @override
  void initState() {
    _pageIndex = 1;
    _tabController = TabController(length: 4, initialIndex: 1, vsync: this);
    _fabIconData = Icons.message;
    _fabVisible = true;
    _tabController.addListener(() {
      _pageIndex = _tabController.index;
      _updateFAB();
    });
    super.initState();
  }

  // controll FAB icon and visivility
  void _updateFAB() {
    switch (_pageIndex) {
      case 0:
        _fabVisible = false;
        _fabIconData = Icons.camera_alt;
        break;
      case 1:
        _fabVisible = true;
        _fabIconData = Icons.message;
        break;
      case 2:
        _fabVisible = true;
        _fabIconData = Icons.camera_alt;
        break;
      case 3:
        _fabVisible = true;
        _fabIconData = Icons.call;
        break;
    }
    // notify ui change
    setState(() {});
  }

  // handle FAB onPressed method, based on [_pageIndex]
  void _onPressedFAB() {
    print('onPressed FAB');
    if (_pageIndex == 1) {
      print('select contact message action');
    } else if (_pageIndex == 2) {
      print('camera action');
    } else {
      print('select contact call action');
    }
  }

  // returns AppBar action widget
  List<Widget> _buildAppBarAction() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () => print('search button pressed'),
        tooltip: 'Search',
      ),
      PopupMenuButton(
        tooltip: 'More',
        icon: Icon(Icons.more_vert),
        padding: EdgeInsets.zero,
        itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
                value: 0,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'New group',
                      style: Theme.of(context).textTheme.bodyText1,
                    ))),
            PopupMenuItem<int>(
                value: 1,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'New broadcast',
                      style: Theme.of(context).textTheme.bodyText1,
                    ))),
            PopupMenuItem<int>(
                value: 2,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'WhatsApp Web',
                      style: Theme.of(context).textTheme.bodyText1,
                    ))),
            PopupMenuItem<int>(
                value: 3,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Starred messages',
                      style: Theme.of(context).textTheme.bodyText1,
                    ))),
            PopupMenuItem<int>(
                value: 4,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.bodyText1,
                    ))),
          ];
        },
      )
    ];
  }

  // returns AppBar bottom widget
  TabBar _buildAppBarBottom() {
    return TabBar(controller: _tabController, tabs: [
      Tab(
        child: FittedBox(fit: BoxFit.fitWidth, child: Icon(Icons.camera_alt)),
      ),
      Tab(
        child: FittedBox(fit: BoxFit.fitWidth, child: Text('CHATS')),
      ),
      Tab(
        child: FittedBox(fit: BoxFit.fitWidth, child: Text('STATUS')),
      ),
      Tab(
        child: FittedBox(fit: BoxFit.fitWidth, child: Text('CALLS')),
      ),
    ]);
  }

  // returns AppBar FAB widget
  Widget _buildAppBarFAB() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: _fabVisible ? 1.0 : 0.0,
      child: FloatingActionButton(
          child: Icon(
            _fabIconData,
            color: Colors.white,
          ),
          onPressed: _onPressedFAB),
    );
  }

  // returns AppBar body widget
  Widget _buildAppBarBody() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TabBarView(
          controller: _tabController,
          physics: ScrollPhysics(),
          children: [
            Center(
              child: Text('CAMERA PAGE'),
            ),
            ChatsPage(),
            StatusPage(),
            CallsPage()
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(fit: BoxFit.fitWidth, child: Text('WhatsApp')),
        actions: _buildAppBarAction(),
        bottom: _buildAppBarBottom(),
      ),
      body: _buildAppBarBody(),
      floatingActionButton: _buildAppBarFAB(),
    );
  }
}

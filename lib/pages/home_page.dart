import 'package:WhatAppClone/pages/calls_page.dart';
import 'package:WhatAppClone/pages/chats_page.dart';
import 'package:WhatAppClone/pages/status_page.dart';
import 'package:flutter/material.dart';

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

  void _updateFAB() {
    if (_pageIndex == 0) {
      _fabVisible = false;
      _fabIconData = Icons.camera_alt;
    } else if (_pageIndex == 1) {
      _fabVisible = true;
      _fabIconData = Icons.message;
    } else if (_pageIndex == 2) {
      _fabVisible = true;
      _fabIconData = Icons.camera_alt;
    } else {
      _fabVisible = true;
      _fabIconData = Icons.call;
    }
    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(fit: BoxFit.fitWidth, child: Text('WhatsApp')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => print('search button pressed'),
            tooltip: 'Search',
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => print('more button pressed'),
            tooltip: 'More options',
          ),
        ],
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(
            child:
                FittedBox(fit: BoxFit.fitWidth, child: Icon(Icons.camera_alt)),
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
        ]),
      ),
      body: Container(
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
      ),
      floatingActionButton: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: _fabVisible ? 1.0 : 0.0,
        child: FloatingActionButton(
            child: Icon(
              _fabIconData,
              color: Colors.white,
            ),
            onPressed: _onPressedFAB),
      ),
    );
  }
}

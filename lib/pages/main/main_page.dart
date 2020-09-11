import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/shared/constants.dart';

import 'package:WhatsAppClone/helpers/navigator_helper.dart';

import 'package:WhatsAppClone/pages/screens/calls/calls_page.dart';
import 'package:WhatsAppClone/pages/screens/chats/chats_page.dart';
import 'package:WhatsAppClone/pages/screens/status/status_page.dart';
import 'package:WhatsAppClone/pages/screens/camera/camera_page.dart';

import 'package:WhatsAppClone/core/widgets/ui_elements/status_modal_bottom_sheet.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  // Class Attributes
  GlobalKey<ScaffoldState> _scaffoldKey;
  // tab controller
  TabController _tabController;
  // tabs page index
  int _pageIndex;
  // holds FAB IconData
  IconData _fabIconData;
  // FAB visibiliy flag
  bool _fabVisible;

  // Called when this object is inserted into the tree.
  @override
  void initState() {
    _pageIndex = 1;
    _scaffoldKey = GlobalKey<ScaffoldState>();
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
        _fabIconData = Icons.edit;
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
    if (_pageIndex == 1) {
      // navigate contact screen on CHAT MODE
      Routes.navigateContactScreen(context, ContactMode.Chat);
    } else if (_pageIndex == 2) {
      // show status modal bottom sheet
      showStatusModalBottomSheet(context);
    } else {
      // navigate contact screen on CALLS MODE
      Routes.navigateContactScreen(context, ContactMode.Calls);
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

  // returns AppBar body widget
  Widget _buildAppBarBody() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TabBarView(
          controller: _tabController,
          physics: ScrollPhysics(),
          children: [CameraPage(), ChatsPage(), StatusPage(), CallsPage()]),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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

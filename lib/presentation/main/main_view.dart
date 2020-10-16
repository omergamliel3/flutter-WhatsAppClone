import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'main_viewmodel.dart';

import '../index.dart';

import '../../core/widgets/ui_elements/status_modal_bottom_sheet.dart';
import '../../core/widgets/keep_alive_wrapper.dart';

import 'widgets/popupmenubutton.dart';

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

  // returns AppBar action widget
  List<Widget> _buildAppBarAction() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => print('search button pressed'),
        tooltip: 'Search',
      ),
      PopUpMenuButton()
    ];
  }

  // returns AppBar bottom widget
  TabBar _buildAppBarBottom() {
    return TabBar(controller: _tabController, tabs: const [
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
      padding: const EdgeInsets.all(8.0),
      child: TabBarView(
          controller: _tabController,
          physics: const ScrollPhysics(),
          children: [
            KeepAliveWrapper(child: CameraPage()),
            KeepAliveWrapper(child: ChatsPage()),
            KeepAliveWrapper(child: StatusPage()),
            KeepAliveWrapper(child: CallsPage())
          ]),
    );
  }

  // returns AppBar FAB widget
  Widget _buildAppBarFAB(MainViewModel model) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _fabVisible ? 1.0 : 0.0,
      child: FloatingActionButton(
        key: const ValueKey('FAB'),
        onPressed: () => model.handlePressedFAB(_pageIndex, showStatusModal),
        child: Icon(
          _fabIconData,
          color: Colors.white,
        ),
      ),
    );
  }

  // launch status model bottom sheet widget
  void showStatusModal() {
    // show status modal bottom sheet
    showStatusModalBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.nonReactive(
      viewModelBuilder: () => MainViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title:
                const FittedBox(fit: BoxFit.fitWidth, child: Text('WhatsApp')),
            actions: _buildAppBarAction(),
            bottom: _buildAppBarBottom(),
          ),
          body: _buildAppBarBody(),
          floatingActionButton: _buildAppBarFAB(model),
        );
      },
    );
  }
}

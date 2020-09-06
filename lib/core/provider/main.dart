import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/models/chat.dart';

import 'package:WhatsAppClone/services/local_storage/db_service.dart';
import 'package:WhatsAppClone/services/local_storage/prefs_service.dart';

class MainModel extends ChangeNotifier {
  // active chats data
  List<Chat> _activeChats = [];
  List<Chat> get activeChats => _activeChats;

  /// get active chats from local db
  Future<void> getActiveChats() async {
    _activeChats = await DBservice.getChats();
    notifyListeners();
  }

  // user status data
  String _userStatus;
  String get userStatus => _userStatus;

  void updateUserStatus() {
    _userStatus = PrefsService.userStatus;
    notifyListeners();
  }

  bool _isLight;
  bool get isLight => _isLight;

  /// init model data
  Future<void> initModel(BuildContext context) async {
    // set active chats from local db storage
    _activeChats = await DBservice.getChats();
    // set user status from prefs local storage
    _userStatus = PrefsService.userStatus;
    // set isLight attribute
    _isLight = Theme.of(context).brightness == Brightness.light;
  }
}

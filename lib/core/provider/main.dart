import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/models/chat.dart';

import 'package:WhatsAppClone/services/local_storage/db_service.dart';

class MainModel extends ChangeNotifier {
  List<Chat> _activeChats = [];

  List<Chat> get activeChats => _activeChats;

  Future<void> getActiveChats({bool notify = false}) async {
    _activeChats = await DBservice.getChats();
    if (notify) {
      notifyListeners();
    }
  }
}

import 'package:stacked/stacked.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/status.dart';
import '../../../services/auth/user_service.dart';
import '../../../services/locator.dart';

class StatusViewModel extends ReactiveViewModel {
  // services
  final _userService = locator<UserService>();
  // status stream
  Stream<QuerySnapshot> _statusStream;

  /// call once after the model is construct
  void initalise() {
    // set status stream to firestore status snapshots
    _statusStream = _userService.statusStream;
  }

  /// evoke status delete methods
  Future<void> handleDeleteStatus(Status status) async {
    // delete status from firestore service
    var deleted = await _userService.deleteStatus(status);
    // stops method if failed to delete status
    if (!deleted) return;
    // get user last status
    await _userService.getUserStatus();
  }

  // whatever the user allow to delete status
  bool allowDelete(String username) {
    return _userService.allowDelete(username);
  }

  // username
  String get username => _userService.userName;
  // reactive user status
  String get userStatus => _userService.userStatus;
  // status stream
  Stream<QuerySnapshot> get statusStream => _statusStream;

  // listen to UserService changes
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_userService];
}

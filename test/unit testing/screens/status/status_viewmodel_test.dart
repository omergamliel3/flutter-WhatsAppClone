import 'package:WhatsAppClone/core/models/status.dart';
import 'package:WhatsAppClone/services/auth/user_service.dart';
import 'package:WhatsAppClone/services/locator.dart';
import 'package:WhatsAppClone/views/screens/status/status_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserServiceMock extends Mock implements UserService {}

void main() {
  group('StatusViewModel Test', () {
    test('After constructed should initialise model properties', () async {
      // mock user service
      var userService = UserServiceMock();
      // setup locator
      locator.registerSingleton<UserService>(userService);
      // construct model
      var model = StatusViewModel();
      // initalise model
      model.initalise();
      // verify status stream
      verify(userService.statusStream);
      // use username getter
      model.username;
      // verify service call
      verify(userService.userName);
      // use user status getter
      model.userStatus;
      // verify service call
      verify(userService.userStatus);
      // validate allow delete
      var username = 'username';
      model.allowDelete(username);
      // verify service call
      verify(userService.allowDelete(username));
      // dummy status data
      var status = Status(
          userName: 'username',
          content: 'test',
          timestamp: DateTime.now(),
          id: '111');
      // call handle delete status
      await model.handleDeleteStatus(status);
      // verify multiple service call
      verify(userService.deleteStatus(status));
    });
  });
}

import 'dart:io';
import 'package:path/path.dart';

// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

final path = r'C:\Users\omerg\AppData\Local\Android\Sdk';

Future<void> grantPermissions() async {
  //final envVars = Platform.environment;
  final adbPath = join(
    path,
    'platform-tools',
    Platform.isWindows ? 'adb.exe' : 'adb',
  );
  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.whatsappclone.WhatAppClone',
    'android.permission.READ_CONTACTS'
  ]);
  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.whatsappclone.WhatAppClone',
    'android.permission.WRITE_CONTACTS'
  ]);
  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.whatsappclone.WhatAppClone',
    'android.permission.CAMERA'
  ]);
  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.whatsappclone.WhatAppClone',
    'android.permission.READ_CALL_LOG'
  ]);
  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.whatsappclone.WhatAppClone',
    'android.permission.INTERNET'
  ]);
}

void main() {
  group('WhatsAppClone App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      // grant device permission
      await grantPermissions();
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Login', () async {
      await driver.waitFor(find.byValueKey('CONTINUE'));
      final login = find.byValueKey('CONTINUE');
      await driver.tap(login);
      await Future.delayed(Duration(seconds: 2));
      await driver.waitFor(find.byValueKey('UsernameFormField'));
      final textField = find.byValueKey('UsernameFormField');
      driver.tap(textField);
      driver.enterText('omergamliel', timeout: Duration(seconds: 1));
      await driver.tap(login);
    });

    test('Press FAB and select first contact', () async {
      // wait for FAB
      await driver.waitFor(find.byValueKey('FAB'));
      await Future.delayed(Duration(seconds: 1));
      final buttonFinder = find.byValueKey('FAB');
      // First, tap the button.
      await driver.tap(buttonFinder);
      // Delay
      await Future.delayed(Duration(seconds: 2));
      // Wait for first contact
      await driver.waitFor(find.byValueKey('contact0'));
      final contactFinder = find.byValueKey('contact0');
      // Tap first contact
      await driver.tap(contactFinder);
    });

    test('Tap First chat contact', () async {
      // Delay
      await Future.delayed(Duration(seconds: 2));
      // Wait for first chat
      await driver.waitFor(find.byValueKey('chat0'));
      final chatFinder = find.byValueKey('chat0');
      // Tap chat
      await driver.tap(chatFinder);
    });

    test('Compose messages', () async {
      await driver.waitFor(find.byValueKey('compose'));
      final compose = find.byValueKey('compose');
      await driver.tap(compose);
      await driver.waitFor(find.byValueKey('sendMsg'));
      final send = find.byValueKey('sendMsg');

      Future composeMsg(String msg) async {
        await driver.enterText(msg);
        await driver.tap(send);
        await Future.delayed(Duration(seconds: 1));
      }

      await composeMsg(
          'hello there, this is a test message from flutter driver');
      for (var i = 0; i < 10; i++) {
        await composeMsg('test message $i');
      }
      for (var i = 0; i < 10; i++) {
        await composeMsg('hello $i');
      }
      for (var i = 0; i < 10; i++) {
        await composeMsg('bye $i');
      }
    }, timeout: Timeout(Duration(minutes: 2)));
  });
}
